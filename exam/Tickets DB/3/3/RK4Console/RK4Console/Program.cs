using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;

namespace RK4Console
{
    class Program
    {
        static void Main(string[] args)
        {
            SqlConnection myConnection = new SqlConnection(@"Data Source=OX\SQLEXPRESS;Initial Catalog=DBTemp;Integrated Security=True");

            try
            {
                myConnection.Open();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }
            Random random = new Random();
            int randomNumber = random.Next(10, 100);

            SqlCommand myCommand = new SqlCommand("INSERT INTO cust (name, category_id) " +
                                                "Values ('customer " + randomNumber + "', " + randomNumber + ")", myConnection);

            myCommand.ExecuteNonQuery();


            SqlCommand myCommand2 = new SqlCommand("UPDATE cust SET category_id = 1 WHERE name = 'Эльдар';", myConnection);

            myCommand2.ExecuteNonQuery();

            Console.ReadLine();
        }
    }
}
