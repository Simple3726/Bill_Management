package ai;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBConnection;
import weka.classifiers.Classifier;
import weka.core.DenseInstance;
import weka.core.Instance;
import weka.core.Instances;

public class PredictFraud {

    public static String predictInvoice(long invoiceId, Classifier model, Instances dataset) throws Exception {

        String sql =
                "SELECT "
                + "i.invoice_id, "
                + "i.amount, "
                + "DATEPART(HOUR, i.created_at) AS invoice_hour, "
                + "CASE WHEN DATENAME(WEEKDAY, i.created_at) IN ('Saturday','Sunday') "
                + "THEN 'yes' ELSE 'no' END AS is_weekend, "
                + "u.role AS user_role, "
                + "ISNULL(s.status,'CLOSED') AS shift_status, "
                + "i.status AS invoice_status, "
                + "(SELECT COUNT(*) FROM Invoice_History h WHERE h.invoice_id = i.invoice_id) AS edit_count, "
                + "CASE "
                + "WHEN EXISTS( "
                + "SELECT 1 FROM Invoices i2 "
                + "WHERE i2.created_by = i.created_by "
                + "AND ABS(DATEDIFF(MINUTE,i2.created_at,i.created_at)) < 2 "
                + "AND i2.invoice_id <> i.invoice_id "
                + ") "
                + "THEN 'yes' ELSE 'no' END AS duplicated_invoice "
                + "FROM Invoices i "
                + "JOIN Users u ON i.created_by = u.user_id "
                + "LEFT JOIN Shifts s ON s.user_id = i.created_by "
                + "AND i.created_at BETWEEN s.start_time AND s.end_time "
                + "WHERE i.invoice_id = ?";

        String prediction = "no";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, invoiceId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                double amount = rs.getDouble("amount");
                int hour = rs.getInt("invoice_hour");

                String weekend = rs.getString("is_weekend");
                String role = rs.getString("user_role");
                String shiftStatus = rs.getString("shift_status");
                String invoiceStatus = rs.getString("invoice_status");

                int editCount = rs.getInt("edit_count");

                String duplicate = rs.getString("duplicated_invoice");

                Instance inst = new DenseInstance(dataset.numAttributes());
                inst.setDataset(dataset);

                inst.setValue(0, amount);
                inst.setValue(1, hour);
                inst.setValue(2, weekend);
                inst.setValue(3, role);
                inst.setValue(4, shiftStatus);
                inst.setValue(5, invoiceStatus);
                inst.setValue(6, editCount);
                inst.setValue(7, duplicate);

                double result = model.classifyInstance(inst);

                prediction = dataset.classAttribute().value((int) result);

                if ("yes".equals(prediction)) {

                    String insertAlert =
                            "INSERT INTO Alerts(entity_type, entity_id, risk_score, message) "
                            + "VALUES ('INVOICE', ?, ?, ?)";

                    try (PreparedStatement psAlert = conn.prepareStatement(insertAlert)) {

                        psAlert.setLong(1, invoiceId);
                        psAlert.setInt(2, 80);
                        psAlert.setString(3, "AI detected suspicious invoice");

                        psAlert.executeUpdate();
                    }
                }
            }
        }

        return prediction;
    }
}