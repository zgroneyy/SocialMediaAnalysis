import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;


/**
 * Created by ckaan on 5.1.2017.
 */
public class Main {

    public static void main(String[] args){
//        ConfigurationBuilder cb = new ConfigurationBuilder();

//
//        cb.setDebugEnabled(true)
//                .setOAuthConsumerKey("eppBr7FAonranhOLGqlAtyXAo")
//                .setOAuthConsumerSecret("bGdrSC5xHgdzmhAuA4LWSJixgd7DXAQTDbx0rAwfwYvOSjMcxq")
//                .setOAuthAccessToken("1498522394-8oQSmaCjmC5Wm3vJAD823wVc7rV6NdNcqwVldRi")
//                .setOAuthAccessTokenSecret("ZFMhQEJeB6kJOwSnHHqgp9OQNgXpzTgirLzjSl0TrM506");
//
//        TwitterFactory tf = new TwitterFactory(cb.build());
//        twitter4j.Twitter twitter = tf.getInstance();

//        ArrayList<String> list = readCSVFile();
        ArrayList<String> list = new ArrayList<>();
        list.add("ckaanakyol");


        BufferedWriter writer = null;

        File logFile = new File("names3.txt");

        try {
            writer = new BufferedWriter(new FileWriter(logFile));
            for(int i = 0; i<list.size(); i++){

                String output  = getUrlContents("https://twitter.com/" + list.get(i), i<5423);
                String[] basket = output.split("\n");

                for(int j = 0; j<basket.length; j++)
                    System.out.println(basket[j]);
                String line = basket[53];

                String[] parts = line.split(">");
                while(parts.length<2){
                    output  = getUrlContents("https://twitter.com/" + list.get(i), i<5423);
                    basket = output.split("\n");
                    line = basket[53];
                    parts = line.split(">");
                }

                String name = parts[1];
                if(name.lastIndexOf("(@") == -1)
                    name = "David Daniels";
                else
                {
                    name = name.substring(0,name.lastIndexOf("(@")-1);
                    name = name.replaceAll("[^\\x00-\\x7F]", "");
                    name = name.replaceAll("[^A-Za-z0-9 ]", "");
                }
                System.out.println(name + " " + i);
                writer.write(name + "\n");
            }

        } catch (IOException e) {
            System.out.println(e);
        } finally {
            try {
            // Close the writer regardless of what happens...
            writer.close();
        } catch (Exception e) {
        }
    }


    }


    public static ArrayList<String> readCSVFile()
    {
        String csvFile = "C:\\Users\\ckaan\\Documents\\Java\\GetNames\\src\\names.csv";
        BufferedReader br = null;
        String line = "";
        String cvsSplitBy = ",";
        ArrayList list = null;
        try {

            br = new BufferedReader(new FileReader(csvFile));
            while ((line = br.readLine()) != null) {

                // use comma as separator
                String[] country = line.split(cvsSplitBy);

                list = new ArrayList<String>(Arrays.asList(country));

            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return list;
    }


    private static String getUrlContents(String theUrl, boolean gender)
    {
        StringBuilder content = new StringBuilder();

        // many of these calls can throw exceptions, so i've just
        // wrapped them all in one try/catch statement.
        try
        {
            // create a url object
            URL url = new URL(theUrl);

            // create a urlconnection object
            URLConnection urlConnection = url.openConnection();
            urlConnection.setConnectTimeout(50000);
            // wrap the urlconnection in a bufferedreader

            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));

            String line;

            // read from the urlconnection via the bufferedreader
            while ((line = bufferedReader.readLine()) != null)
            {
                content.append(line + "\n");
            }
            bufferedReader.close();

//            String a = content.toString();
//            String[] basket = a.split("\n");
//            if(basket.length<54)
//                return getUrlContents(theUrl,gender);
        }
        catch(Exception e)
        {
            if(gender)
                return getUrlContents("https://twitter.com/WilfordGemma",gender);
            else
                return getUrlContents("https://twitter.com/David_R_Daniels",gender);
        }
        return content.toString();
    }
}
