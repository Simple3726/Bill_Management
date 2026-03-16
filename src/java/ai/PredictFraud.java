package ai;

import entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import javax.servlet.http.HttpSession;
import utils.DBConnection;
import weka.classifiers.Classifier;
import weka.core.DenseInstance;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.SerializationHelper;
import weka.core.converters.ConverterUtils;

public class PredictFraud {

    public static String predictInvoice(long invoiceId, Classifier model, Instances dataset) throws Exception {

        String sql
                = "SELECT "
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

        String prediction = "";
        double riskScore = 0;
        double[] dist = null;
        String formattedScore = "";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

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

                // tạo instance
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

                // fraud chưa biết
                inst.setMissing(dataset.classIndex());

                // predict
                double result = model.classifyInstance(inst);

                prediction = dataset.classAttribute().value((int) result);

                // probability
                dist = model.distributionForInstance(inst);
                formattedScore = String.format("%.2f", dist[1]);
                int fraudIndex = dataset.classAttribute().indexOfValue("yes");

                riskScore = dist[fraudIndex];

//                System.out.println("Prediction: " + prediction);
//                System.out.println("Risk score: " + riskScore);
//                System.out.println("dist = [" + dist[0] + ", " + dist[1] + "]");
            } else {
                return "Invoice not found";
            }
        }
        return prediction +  formattedScore ;
    }

//    public static void main(String[] args) throws Exception {
//
//        String arffPath = "C:/Users/Admin/Documents/GitHub/Bill_Management/web/WEB-INF/invoice_dataset.arff";
//        String modelPath = "C:/Users/Admin/Documents/GitHub/Bill_Management/web/WEB-INF/risk_logistic.model";
//
//        //long invoiceId = 3; // test trực tiếp id
//        ConverterUtils.DataSource source = new ConverterUtils.DataSource(arffPath);
//        Instances dataset = source.getDataSet();
//        dataset.setClassIndex(dataset.numAttributes() - 1);
//
//        Classifier model = (Classifier) SerializationHelper.read(modelPath);
//        System.out.println(model);
//        for (int i = 1; i < 10; i++) {
//            String result = PredictFraud.predictInvoice(i, model, dataset);
//            System.out.println("Prediction = " + result + "\n");
//        }
//
//    }
}
