public class GetNestedDepth
{
    private List<Branch> branches;

    private Branch()
    {
        this.branches = new List<Branch>();
    }

    public static void Main(string[] args)
    {
        Branch main = new Branch();
        main.branches.Add(new Branch());
        main.branches.Add(new Branch());
        main.branches[0].branches.Add(new Branch());
        main.branches[1].branches.Add(new Branch());
        main.branches[1].branches.Add(new Branch());
        main.branches[1].branches.Add(new Branch());
        main.branches[1].branches[0].branches.Add(new Branch());
        main.branches[1].branches[1].branches.Add(new Branch());
        main.branches[1].branches[1].branches.Add(new Branch());
        main.branches[1].branches[1].branches[0].branches.Add(new Branch());

        Console.WriteLine("Structure depth: " + Convert.ToString(GetDepth(main, 1, 0)));
    }

    private static int GetDepth(Branch main, int currDepth, int maxDepth)
    {
        foreach (var branch in main.branches)
        { 
            maxDepth = GetDepth(branch, currDepth + 1, maxDepth);
        }

        return (currDepth > maxDepth) ? currDepth : maxDepth;
    }
}
