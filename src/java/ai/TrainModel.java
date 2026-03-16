package ai;

import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;
//import weka.classifiers.functions.Logistic;
import weka.classifiers.trees.J48;
import weka.classifiers.trees.RandomForest;
import weka.core.SerializationHelper;

public class TrainModel {

    public static void main(String[] args) {

        try {

            // 1 Load dataset
            DataSource source = new DataSource("C:/Users/Admin/Documents/GitHub/Bill_Management/web/WEB-INF/invoice_dataset.arff");
            Instances data = source.getDataSet();

            // 2 Set class attribute
            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            System.out.println("Dataset loaded!");
            System.out.println("Instances: " + data.numInstances());
            System.out.println("Attributes: " + data.numAttributes());

            // 3 Create J48 Regression model
            //J48 model = new J48();
            RandomForest model = new RandomForest();
            // 4 Train model
            model.buildClassifier(data);

            // 5 Save model
            SerializationHelper.write("C:/Users/Admin/Documents/GitHub/Bill_Management/web/WEB-INF/risk_logistic.model", model);
            // 6 Check model đang dùng hiện tại
            System.out.println(model.getClass().getName());
            System.out.println("Model trained successfully!");
            System.out.println("Model saved to WEB_INF/risk_logistic.model");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
