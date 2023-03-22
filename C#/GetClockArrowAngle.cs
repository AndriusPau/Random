public class GetClockArrowAngle
{
    public static void Main(string[] args)
    {
        short hour, minute;

        Console.WriteLine("This is an analogue clock.\nPossible hour values are 1 - 12 and minute values are 0-59");
        
        while (true)
        {
            Console.WriteLine("Input the hour value: ");
            hour = Convert.ToInt16(Console.ReadLine());
            if (hour is > 0 and <= 12)
            {
                break;
            }
            Console.WriteLine("Please use numbers in the range of: 1 - 12");
        }

        while (true)
        {
            Console.WriteLine("Input the minute value: ");
            minute = Convert.ToInt16(Console.ReadLine());
            if (minute is >= 0 and < 60)
            {
                break;
            }
            Console.WriteLine("Please use numbers in the range of: 0 - 59");
        }

        Console.WriteLine("The angle between the arrows is " + Convert.ToString(GetAngle(hour, minute)) + " degrees.");
    }


    private static double GetAngle(short hour, short minute)
    {
        var arrowHour = (Convert.ToDouble(hour) * 30) + (Convert.ToDouble(minute) / 60 * 30);
        var arrowMinute = Convert.ToDouble(minute) * 360 / 60;
        var difference = Math.Abs(arrowHour - arrowMinute);
        return (difference < 180) ? (difference) : (360 - difference);
    }
}
