using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DB_rk4
{
    class Program
    {
        static void Main(string[] args)
        {
            string connectionString = @"server = Али-ПК; database = DB_BANK; integrated security=true;";
            SqlConnection conn = new SqlConnection(connectionString);

            try
            {
                conn.Open();
                SqlCommand myCommand1 = new SqlCommand("INSERT INTO WeatherReading (ReadingTime, Temperature) VALUES ('20080101 0:10',82.00),  ('20080101 0:11',89.22), ('20080101 0:12',600.32), ('20080101 0:13',88.22), ('20080101 0:14',99.01);", conn);
                myCommand1.ExecuteNonQuery();


                SqlCommand myCmd = new SqlCommand("select * from WeatherReading", conn);
                SqlDataReader reader = myCmd.ExecuteReader();
                try
                {
                    while (reader.Read())
                    {
                        Console.WriteLine(String.Format("{0}, {1}, {2}",
                            reader[0], reader[1], reader[2]));
                    }
                }
                finally
                {
                    // Always call Close when done reading.
                    reader.Close();
                }

                myCmd = new SqlCommand("select * from WeatherReading_exception", conn);
                reader = myCmd.ExecuteReader();
                try
                {
                    while (reader.Read())
                    {
                        Console.WriteLine(String.Format("{0}, {1}, {2}",
                            reader[0], reader[1], reader[2]));
                    }
                }
                finally
                {
                    // Always call Close when done reading.
                    reader.Close();
                }


                
            }
            catch (SqlException ex)
            {
                Console.WriteLine(ex.ToString());
            } 
            Console.ReadLine();
        }
    }
}
