package ai;

import weka.classifiers.Classifier;
import weka.core.SerializationHelper;

public class WekaModelLoader {

    private static Classifier model;

    public static Classifier getModel() {

        if (model == null) {
            try {
                model = (Classifier) SerializationHelper.read(
                        WekaModelLoader.class.getResourceAsStream("/ai/risk_logistic.model")
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return model;
    }
}
