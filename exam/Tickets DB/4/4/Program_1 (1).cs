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
                SqlCommand myCommand1 = new SqlCommand("UPDATE Banks SET BankRating = 'ААА' WHERE BankID = 1", conn);
                myCommand1.ExecuteNonQuery();

                SqlCommand myCommand2 = new SqlCommand("insert into BANKS (BankID, BankName, BankRating, RegistrationNumber, ParentID) values (101, 'RoubleCrash', 'ВВВ-', 666, NULL)", conn);
                myCommand2.ExecuteNonQuery();

                SqlCommand myCommand3 = new SqlCommand ("delete from BANKS where BankID = 101", conn);
                myCommand3.ExecuteNonQuery();

                SqlCommand myCmd = new SqlCommand("select * from audit", conn);
                SqlDataReader reader = myCmd.ExecuteReader();
                try
                {
                    while (reader.Read())
                    {
                        Console.WriteLine(String.Format("{0}, {1}, {2}, {3}, {4}, {5}",
                            reader[0], reader[1], reader[2], reader[3], reader[4], reader[5]));
                    }
                }
                finally
                {
                    // Always call Close when done reading.
                    reader.Close();
                }


                Console.ReadLine();
            }
            catch (SqlException ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }
    }
}
