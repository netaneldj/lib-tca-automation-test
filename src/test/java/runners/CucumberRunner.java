package runners;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.Constants;
import cucumber.api.CucumberOptions;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import net.masterthought.cucumber.presentation.PresentationMode;
import net.masterthought.cucumber.sorting.SortingMethod;

@CucumberOptions
        (plugin = { "pretty", "html:target/cucumber-html-report","json:target/cucumber-json-report/cucumber-json.json","junit:target/cucumber-junit-report",},

                features = {"classpath:apiTesting//features"})
public class CucumberRunner {
    
	@Test
    public void testParallel(){
        String tag = System.getProperty("tag");
        System.out.println("karate.tag system.property was "+tag);
        String karateOutputPath = "target/karate-reports";
		Results results = Runner.path("classpath:apiTesting//features")
                                .tags(tag, "~@ignore")
                                .outputCucumberJson(true)
                                .parallel(1);
		System.out.println("Result Dir: "+results.getReportDir());
        generateReport(karateOutputPath);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());        
    }

    public static void generateReport(String karateOutputPath) {   
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy_MM_dd_HH_mm_ss");
        LocalDateTime now = LocalDateTime.now();
        String currentDateTime = dtf.format(now);     
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        String currentDir = System.getProperty("user.dir");
        String folderPath = currentDir + "/target/" + "Regression" + currentDateTime;
        File file = new File(folderPath);
        file.mkdirs();
        String env = System.getProperty(Constants.KARATE_ENV, "dev");
        Configuration config = new Configuration(file, "Cucumber_Reports");
        config.setBuildNumber("1.0.0");
        config.addClassifications("suite", "Karate TCA Automation");
        config.addClassifications("env", env);
        config.setSortingMethod(SortingMethod.NATURAL);
        config.addPresentationModes(PresentationMode.EXPAND_ALL_STEPS);
        config.addPresentationModes(PresentationMode.PARALLEL_TESTING);
        config.setQualifier("sample", "Karate TCA Automation");
        config.setTrendsStatsFile(new File("target/test-classes/apiTesting.json"));
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();        
    }
}
