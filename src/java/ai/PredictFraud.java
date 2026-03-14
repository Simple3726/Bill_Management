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

    public static String predict(Classifier model, Instances dataset) throws Exception {

        String sql =
        "SELECT i.amount, " +
        "DATEPART(HOUR, i.created_at) AS invoice_hour, " +
        "i.status, " +
        "CASE WHEN DATENAME(WEEKDAY, i.created_at) IN ('Saturday','Sunday') " +
        "THEN 'yes' ELSE 'no' END AS is_weekend, " +
        "CASE WHEN EXISTS ( " +
        "SELECT 1 FROM Invoices i2 " +
        "WHERE i2.invoice_code = i.invoice_code " +
        "AND i2.invoice_id <> i.invoice_id ) " +
        "THEN 'yes' ELSE 'no' END AS duplicated_invoice, " +
        "'no' AS fraud " +
        "FROM Invoices i";

        String prediction = "";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                double amount = rs.getDouble("amount");
                int hour = rs.getInt("invoice_hour");
                String status = rs.getString("status");
                String weekend = rs.getString("is_weekend");
                String duplicate = rs.getString("duplicated_invoice");

                Instance inst = new DenseInstance(dataset.numAttributes());
                inst.setDataset(dataset);

                inst.setValue(0, amount);
                inst.setValue(1, hour);
                inst.setValue(2, status);
                inst.setValue(3, weekend);
                inst.setValue(4, duplicate);

                double result = model.classifyInstance(inst);

                prediction = dataset.classAttribute().value((int) result);
            }

        }

        return prediction;
    }
}
