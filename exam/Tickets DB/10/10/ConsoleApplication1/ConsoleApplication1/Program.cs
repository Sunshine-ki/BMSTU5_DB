using System;
using System.Data;
using System.Data.SqlClient;

namespace App4
{
    class Program
    {
        static void Main(string[] args)
        {
            string connectionStr = @"server = (local)\SQLEXPRESS;integrated security = true;database = tempdb"; 
            string version = "2.0.13";
            string version1 = "1.0.12";

            string qInsert = @"insert into Version(DatabaseVersion) values (@version)";
            string qDelete = @"delete from Version where DatabaseVersion = @version";
            string qUpdate = @"update Version set DatabaseVersion = @version where DatabaseVersion = @version1";
            SqlConnection connect = new SqlConnection(connectionStr);
            SqlCommand cmdInsert = new SqlCommand(qInsert, connect);
            SqlCommand cmdDelete = new SqlCommand(qDelete, connect);
            SqlCommand cmdUpdate = new SqlCommand(qUpdate, connect);
            cmdInsert.Parameters.Add("@version", SqlDbType.VarChar, 10);
            cmdDelete.Parameters.Add("@version", SqlDbType.VarChar, 10);
            cmdUpdate.Parameters.Add("@version", SqlDbType.VarChar, 10);
            cmdUpdate.Parameters.Add("@version1", SqlDbType.VarChar, 10);
            try
            {
                connect.Open();
                cmdInsert.Parameters["@version"].Value = version;
                cmdInsert.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                try
                {
                    cmdDelete.Parameters["@version"].Value = version1;
                    cmdDelete.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Console.WriteLine(ex.Message);
                }
                finally
                {
                    try
                    {
                        cmdUpdate.Parameters["@version"].Value = version;
                        cmdUpdate.Parameters["@version1"].Value = version1;
                        cmdUpdate.ExecuteNonQuery();
                    }
                    catch (SqlException ex)
                    {
                        Console.WriteLine(ex.Message);
                    }
                }
                connect.Close();
            }
            Console.ReadLine();
        }
    }
}
