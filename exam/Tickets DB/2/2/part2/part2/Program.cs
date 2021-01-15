using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace database
{
    class Program
    {
        private static string connect = "Data Source=ULTRATOP\\SQL_ANTON_SERVER;Integrated Security=True;Connect Timeout=15;Encrypt=False;TrustServerCertificate=False";
        private static int next_id;
        private static void print_student_2()
        {
            {
                // Создаем подключение
                SqlConnection conn = new SqlConnection(connect);
                try
                {
                    conn.Open();
                    DataSet ds = new DataSet();
                    new SqlDataAdapter("select * from tempdb2.dbo.student", conn).Fill(ds, "st");
                    // Получаем таблицу данных
                    DataTable dt = ds.Tables["st"];
                    // Распечатываем содержимое таблтцы
                    Console.WriteLine("Таблиа студентов:");
                    Console.WriteLine("".PadLeft(30, '='));
                    foreach (DataRow row in dt.Rows)
                    {
                        foreach (DataColumn col in dt.Columns)
                            Console.Write(row[col] + " ");
                        Console.WriteLine();
                        Console.WriteLine("".PadLeft(30, '_'));
                    }                    
                }
                catch (Exception e)
                {
                    Console.WriteLine("Ошибка: " + e);
                }
                finally
                {
                    // Закрываем подключение
                    conn.Close();
                }
            }
        }
      
        static void Main(string[] args)
        {
            Console.WriteLine("-----------------------------");

            string sqlqry = @"SELECT * FROM tempdb2.dbo.student";
            string sqlins = @"insert into tempdb2.dbo.student values(@number, @name, @surname, @date, @user)";
            // Создаем подключение
            SqlConnection conn = new SqlConnection(connect);

            SqlCommand cmdqry = new SqlCommand(sqlqry, conn);
            SqlCommand cmdins = new SqlCommand(sqlins, conn);
            cmdins.Parameters.Add("@number", SqlDbType.Char, 8, "studentIdNumber");
            cmdins.Parameters.Add("@name", SqlDbType.VarChar, 20, "firstName");
            cmdins.Parameters.Add("@surname", SqlDbType.VarChar, 20, "lastName");
            cmdins.Parameters.Add("@date", SqlDbType.DateTime2, 3, "rowCreateDate");
            cmdins.Parameters.Add("@user", SqlDbType.VarChar, 20, "rowCreateUser");

            try
            {
                // Создаем адаптер данных и модифицирующие команды
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmdqry;
                da.InsertCommand = cmdins;

                // Создаем и наполняем набор данных
                DataSet ds = new DataSet();
                da.Fill(ds, "st");
                DataTable dt = ds.Tables[0];

                if (dt.Rows.Count > 0)
                    next_id = Convert.ToInt32(dt.Rows[dt.Rows.Count - 1][1]) + 1;
                else
                    next_id = 1;

                //Добавление
                Console.WriteLine("до INSERT:");
                print_student_2();
                DataRow newRow = dt.NewRow();
                newRow["studentIdNumber"] = next_id.ToString();
                newRow["firstName"] = "Student_name";
                newRow["lastName"] = "Student_surname";
                newRow["rowCreateDate"] = DateTime.Now;
                newRow["rowCreateUser"] = "dbo";
                dt.Rows.Add(newRow);
                Console.WriteLine();                
                da.Update(dt);

                Console.WriteLine("после INSERT:");
                print_student_2();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: " + e);
            }
            finally
            {
                // Закрываем подключение
                conn.Close();
            }
            Console.WriteLine();
            Console.WriteLine("Для выхода нажмите enter...");
            Console.ReadLine();        
        }
    }
}
