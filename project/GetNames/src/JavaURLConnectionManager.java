import java.net.*;
import java.io.*;

/**
 * A complete Java class that demonstrates how to read content (text) from a URL
 * using the Java URL and URLConnection classes.
 * @author alvin alexander, alvinalexander.com
 */
public class JavaURLConnectionManager
{
    public static void main(String[] args)
    {
//        String output  = getUrlContents("https://twitter.com/asfdsasdsaasfasdsadas");
//        String[] basket = output.split("\n");
//        int count = 0;
//
//        for(String s: basket)
//            System.out.println(s);

        /*String line = basket[53];
        System.out.println(line);

        String[] parts = line.split(">");
        String name = parts[1];
        name = name.substring(0,name.indexOf('(')-1);
        System.out.println(name);*/

        String a = "_*231sd__1_";
        System.out.println(a.replaceAll("[^A-Za-z0-9]", ""));
    }

    private static String getUrlContents(String theUrl)
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
            urlConnection.setConnectTimeout(5000);
            // wrap the urlconnection in a bufferedreader
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));

            String line;

            // read from the urlconnection via the bufferedreader
            while ((line = bufferedReader.readLine()) != null)
            {
                content.append(line + "\n");
            }
            bufferedReader.close();
        }
        catch(Exception e)
        {
            System.out.println(e);
        }
        return content.toString();
    }
}