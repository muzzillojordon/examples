using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using Microsoft.VisualBasic;
using Microsoft.VisualBasic.FileIO;
using System.Text;
using System.ComponentModel;
using System.Windows.Forms;



public partial class SDITagGenerator : System.Web.UI.Page
{
    public Dictionary<string, List<string>> FullTitlesDic = new Dictionary<string, List<string>>();
    List<string> PartTitlesLst = new List<String>();
    List<string> ParentTagLst = new List<string>();
    List<string> FinalTagNameLst = new List<string>();
    List<string> Sec4TagNameCheckLst = new List<string>();



    public string writeFullPath = "";
    //Line abbreviation for diagram titles
    public string LineAbbr = "";
    //Sub Area for diagram titles
    public string SubArea = "";
    //Line tag is associated with; ex. Pickle Line tag: = P|
    public string TagNameSec1 = "";
    //First screen tag to get to object; Pickle Line-Boiler Room tag: = P|B|
    public string TagNameSec2 = "";
    //First screen tag to get to object, can be used if more than one of the same group on first screen; Pickle Line-Boiler Room tag: = P|B|1|
    public string TagNameSec3 = "";
    //parent tag abbreviation + child tag abbreviation, can be up to 6 in length; Pickle Line-Boiler Room-Boiler1 tag: = P|B|1|B1|
    public string TagNameSec4 = "";
    //if there is the same object but multiple counts it can iterate them, N for none: = P|B|1|B1|N
    public string TagNameSec5 = "";


    //public string TagNameSec1 = "P";
    //public string TagNameSec2 = "*!";
    //public string TagNameSec3 = "1";
    //public string TagNameSec4 = "";
    //public string TagNameSec5 = "N";

    protected void Page_Load(object sender, EventArgs e)
    {
        FileUpload fileUpload = new FileUpload();
    }


    protected void Upload_Click(object sender, EventArgs e)
    {

        Sec4TagNameCheckLst = new List<string>();
        //   ParentTagLst = new List<string>();
        LineAbbr = LineAbbrTB.Value.ToLower().Trim();
        SubArea = SubAreaTB.Value.ToLower().Trim();
        TagNameSec1 = Section1TB.Value.ToUpper().Trim();
        TagNameSec2 = Section2TB.Value.ToUpper().Trim();
        TagNameSec3 = Section3TB.Value.ToUpper().Trim();
        TagNameSec5 = Section5TB.Value.ToUpper().Trim();

        if (this.FileUpload1.HasFile)
        {
            //Get uploaded file name
            string trailingPath = Path.GetFileName(FileUpload1.FileName);
            //Create new path to save on server to read from
            string ReadfullPath = Path.Combine(Server.MapPath("~/Files"), trailingPath);

            if (File.Exists(writeFullPath))
            {
                File.Delete(writeFullPath);
            }

            //Save file
            FileUpload1.SaveAs(ReadfullPath);

            //Read Data and put it in dictionary
            ReadData(ReadfullPath);

            //Make Tag names for dictionary items
            MakeTagName();
        }

    }

    /// <summary>
    /// Reads CSV File into dictionary (FullTitlesDic) Key: Name of Parent Diagram, Value: List of Parts contained in diagram.
    /// </summary>
    /// <param name="ReadfullPath"></param>
    private void ReadData(string ReadfullPath)
    {
        //Read File
        using (TextFieldParser parser = new TextFieldParser(ReadfullPath))
        {
            string DiagramFullTitle = "";

            parser.TextFieldType = FieldType.Delimited;
            parser.SetDelimiters(",");

            while (!parser.EndOfData)
            {
                //Processing row
                string[] fields = parser.ReadFields();

                string tempField = fields[0].Trim();

                //Check if data field is a diagram title
                if (IsDiagramName(tempField))
                {
                    if (DiagramFullTitle == "")
                        //Must be the First diagram title in data strip of diagram identifier ("-") and trim white spaces
                        DiagramFullTitle = tempField.Trim(new char[] { '-' }).Trim();
                    else
                    {
                        //New diagram title, therefore new group of part names. Add previous diagram's title and its part titles to dictionary
                        FullTitlesDic.Add(DiagramFullTitle, PartTitlesLst);
                        //Set up new diagram title for dictionary
                        DiagramFullTitle = tempField.Trim(new char[] { '-' }).Trim();
                        //Define new part titles list
                        PartTitlesLst = new List<String>();
                    }
                }
                else
                    //Must be part title add it to the parts list for this diagram
                    PartTitlesLst.Add(tempField);
            }
            FullTitlesDic.Add(DiagramFullTitle, PartTitlesLst);
        }
    }

    /// <summary>
    /// Makes parent tag name, parent abbreviation to add to child tag, as well as child tag
    /// </summary>
    private void MakeTagName()
    {
        string subAreaTitle = "";
        string subAreaKeyAbbr = "";
        string itemsParentTitleTemp = "";
        string itemsParentTitleTempNoSpec = "";
        string subAreaTitleFileName = "";
        string ChildDiagramFnameTemp = "";
        int subAreakeylength = 0;
        int subAreaChid1keylength = 0;
        int subAreaChid2keylength = 0;
        bool isSubAreaFlag = true; //flag for if main sub area, Main sub area needs a different file name structure. Example Boiler Room
        FinalTagNameLst = new List<string>();
        String FileName = FileUpload1.FileName + "Done.csv";
        StringWriter stringWriter = new StringWriter();


        List<Tuple<string, string>> CildTagsTemp = new List<Tuple<string, string>>();
        List<Tuple<string, string, string, string>> DiagramNamesTemp = new List<Tuple<string, string, string, string>>();



        foreach (KeyValuePair<string, List<String>> pair in FullTitlesDic)
        {

            string DiagrNamNoSpec = "";
            string CldNamNoSpec = "";
            List<string> CldNamNoSpeclst = new List<string>();

            StringBuilder sb = new StringBuilder();

            DiagrNamNoSpec = pair.Key.ToString();

            foreach (char c in DiagrNamNoSpec)
            {
                if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == ' ')
                {
                    sb.Append(c);
                }
            }
            DiagrNamNoSpec = sb.ToString();

            int cldItemsCount = 0;
            cldItemsCount = pair.Value.Count;

            for (int i = 0; i < cldItemsCount; i++)
            {
                sb = new StringBuilder();
                CldNamNoSpec = pair.Value.ToString();
                foreach (char c in CldNamNoSpec)
                {
                    if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == ' ')
                    {
                        sb.Append(c);
                    }
                }
                CldNamNoSpec = sb.ToString();
                CldNamNoSpeclst.Add(CldNamNoSpec);
            }

            //Get abbreviation length based on how many layers deep screens go
            //var abbLengths = GetAbbrLenths(pair.Value); //pair.value
            var abbLengths = GetAbbrLenths(CldNamNoSpeclst);
            subAreakeylength = abbLengths.Item1;
            subAreaChid1keylength = abbLengths.Item2;
            subAreaChid2keylength = abbLengths.Item3;

            //Create parent tag name, which will also be used as the start of the child tag names
            //subAreaKeyAbbr = CreateParentTag(pair.Key, subAreakeylength);
            subAreaKeyAbbr = CreateParentTag(DiagrNamNoSpec, subAreakeylength);


            //Create diagram file name file name
            //var subAreaTitletup = CreateDiagramFileName(pair.Key, subAreaKeyAbbr, isSubAreaFlag);
            var subAreaTitletup = CreateDiagramFileName(DiagrNamNoSpec, subAreaKeyAbbr, isSubAreaFlag);

            subAreaTitle = subAreaTitletup.Item1;
            subAreaTitleFileName = subAreaTitletup.Item2;

            //create diagram parts names
            FinalTagNameLst = CreateChildTag(CldNamNoSpeclst, subAreaKeyAbbr, subAreakeylength, subAreaChid1keylength, subAreaChid2keylength); // pair.value

            isSubAreaFlag = false;

            DiagramNamesTemp.Add(Tuple.Create(pair.Key, subAreaTitle, subAreaTitleFileName, subAreaTitleFileName.Length.ToString()));

            itemsParentTitleTemp = pair.Key;

            int listCount = FinalTagNameLst.Count;
            for (int i = 0; i < listCount; i++)
            {
                if (IsExpandedChild(pair.Value[i])) // pair.value
                {

                    itemsParentTitleTemp = pair.Value[i].Trim(new char[] { '~' }).Trim();
                    itemsParentTitleTempNoSpec = CldNamNoSpeclst[i].Trim(new char[] { '~' }).Trim();  //Just added

                    //StringBuilder sb = new StringBuilder();
                    //foreach (char c in itemsParentTitleTemp)
                    //{
                    //    if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == ' ')
                    //    {
                    //        sb.Append(c);
                    //    }
                    //}
                    //itemsParentTitleTemp = sb.ToString();

                    if (SubArea == "")
                        ChildDiagramFnameTemp = ("d_" + LineAbbr + "_" + itemsParentTitleTempNoSpec.ToLower());
                    else
                        ChildDiagramFnameTemp = ("d_" + LineAbbr + "_" + SubArea + "_" + itemsParentTitleTempNoSpec.ToLower());

                    string ChildDiagramFnameTemp2 = ChildDiagramFnameTemp.Replace(" ", "_");
                    DiagramNamesTemp.Add(Tuple.Create(itemsParentTitleTemp, FinalTagNameLst[i], ChildDiagramFnameTemp2, ChildDiagramFnameTemp2.Length.ToString()));
                }
                else
                {
                    CildTagsTemp.Add(Tuple.Create(itemsParentTitleTemp + " - " + pair.Value[i].Trim(), FinalTagNameLst[i])); //pair.value
                }
            }
        }

        int DiagramNamesTempCount = DiagramNamesTemp.Count();
        int CildTagsTempCount = CildTagsTemp.Count();
        int Count = 0;

        if (CildTagsTempCount > DiagramNamesTempCount)
            Count = CildTagsTempCount;
        else
            Count = DiagramNamesTempCount;

        for (int i = 0; i < Count; i++)
        {
            var Line = "";

            if (i < DiagramNamesTempCount)
            {
                string FN1 = DiagramNamesTemp[i].Item1;
                string FN2 = DiagramNamesTemp[i].Item2;
                string FN3 = DiagramNamesTemp[i].Item3;
                string FN4 = DiagramNamesTemp[i].Item4;

                string TN1 = CildTagsTemp[i].Item1;
                string TN2 = CildTagsTemp[i].Item2;

                Line = String.Format("{0},{1},{2},{3},{4},{5}", FN1, FN2, FN3, FN4, TN1, TN2);
            }
            else
            {
                string TN1 = CildTagsTemp[i].Item1.ToUpper();
                string TN2 = CildTagsTemp[i].Item2;

                Line = String.Format("{0},{1},{2},{3},{4},{5}", "", "", "", "", TN1, TN2);
            }
            stringWriter.WriteLine(Line);
        }

        //Double check every tag is unique
        if (IsProblem(FinalTagNameLst))
            AllGoodLab.Text = "File has duplicates or tags that were made are to long";
        else
        {
            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", FileName));
            Response.ContentType = "application/ms-excel";


            HtmlTextWriter htmlTextWriter = new HtmlTextWriter(stringWriter);
            Response.Write(stringWriter.ToString());
            Response.End();
        }


    }

    /// <summary>
    /// Creates diagram file tags
    /// </summary>
    /// <param name="nameInFile"></param>
    /// <returns></returns>
    private Tuple<string, string> CreateDiagramFileName(string nameInFile, string parentabbr, bool isSubAreaFlag)
    {
        string diagramFileName = "";
        string fileName = "";
        StringBuilder builder = new StringBuilder();


        //StringBuilder sb = new StringBuilder();

        //foreach (char c in nameInFile)
        //{
        //    if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == ' ')
        //    {
        //        sb.Append(c);
        //    }
        //}
        //nameInFile = sb.ToString();

        //Put full diagram tag file name together; The file diagram name must be all lower case
        if (isSubAreaFlag)
            builder = new StringBuilder(TagNameSec1 + "|" + TagNameSec2 + "|" + TagNameSec3 + "|");
        else
            builder = new StringBuilder(TagNameSec1 + "|" + TagNameSec2 + "|" + TagNameSec3 + "|" + parentabbr + "|");

        if (SubArea == "")
            fileName = "d_" + LineAbbr + "_" + nameInFile.ToLower();
        else
            fileName = "d_" + LineAbbr + "_" + SubArea + "_" + nameInFile.ToLower();

        builder.Append(fileName);
        builder.Replace(" ", "_");

        diagramFileName = builder.ToString();

        string Ftemp = fileName.Replace(' ', '_');

        Tuple<string, string> tup = new Tuple<string, string>(diagramFileName, Ftemp);

        return tup;
    }
    /// <summary>
    /// Creates child expand diagram file tag
    /// </summary>
    /// <returns></returns>
    private string CreateChldExpDiaFN(string ChldExpTitle, string ChldExpAbbr)
    {
        string ChildExpandFN = "";

        //Put full child diagram tag file name together; The file diagram name must be all lower case
        StringBuilder builder = new StringBuilder(TagNameSec1 + "|" + TagNameSec2 + "|" + TagNameSec3 + "|");
        builder.Append(ChldExpAbbr + "|");

        if (SubArea == "")
            builder.Append("d_" + LineAbbr + "_" + ChldExpTitle.ToLower());
        else
            builder.Append("d_" + LineAbbr + "_" + SubArea + "_" + ChldExpTitle.ToLower());


        builder.Replace(" ", "_");

        ChildExpandFN = builder.ToString();

        return ChildExpandFN;
    }

    /// <summary>
    /// Creates parent tags names, this tag name will also be the start of its child tag names
    /// </summary>
    /// <param name="ParentName"></param>
    /// <returns></returns>
    private string CreateParentTag(string ParentName, int ParentAbbrvMaxLength)
    {
        string ParentTagReadyStr = "";
        ParentName = ParentName.ToUpper();
        string pTagName = "";
        int k = 1;

        if (TitleNeedsShortenName(ParentName, ParentAbbrvMaxLength))
            ParentTagReadyStr = ShortenName(ParentName, ParentAbbrvMaxLength);
        else
            ParentTagReadyStr = ParentName;

        pTagName = CreateAbbreviation(ParentTagReadyStr);

        if (ParentTagLst.Count == 0)
        {
            ParentTagLst.Add(pTagName);
        }
        else
        {
            //Check to make sure name does not exist
            while (ParentTagLst.FirstOrDefault(x => x == pTagName) != null)
            {
                k++;
                //Part abbreviation is already used so iterate it
                if (pTagName.Length < ParentAbbrvMaxLength)
                    pTagName = pTagName + k;
                else
                {
                    if (k >= 10)
                        pTagName = pTagName.Remove(pTagName.Length - 2) + k;
                    else
                        pTagName = pTagName.Remove(pTagName.Length - 1) + k;
                }
            }
            k = 1;
            ParentTagLst.Add(pTagName);
        }

        return pTagName;
    }

    //creates child Abbreviations 
    private List<string> CreateChildTag(List<string> PartTitlesLst, string subAreakeyAbbr, int subAreakeylength, int subAreaChid1keylength, int subAreaChid2keylength)
    {
        int listCount = PartTitlesLst.Count;
        StringBuilder builder;

        string Child1FileName = "";
        string Child2FileName = "";
        string Child1KeyAbbr = "";
        string Child2KeyAbbr = "";

        string ItemAbbreviation = "";
        bool isChild1Item = false;
        bool isChild2Item = false;

        int AbbrLength = 0;
        string AbbrKey = "";
        //Check Lists
        List<string> PartAbbrCheckLst = new List<string>();
        List<string> ChildKeyAbbrCheckLst = new List<string>();
        //List holding the generated tag names for each part in a single diagram 
        List<string> PartTagNamesLst = new List<string>();

        //Set K to one so first iteration is at 2 (if it uses the iteration count there must have been a like title before)
        //and count on if still not unique
        int k = 1;




        for (int i = 0; i < listCount; i++)
        {
            string PartTitle = PartTitlesLst[i].ToUpper();
            builder = new StringBuilder();

            //Generate child key Abbreviation
            if (IsExpandedChild(PartTitle))
            {
                //Need to make child expand tag abbreviation as normal so remove child identifier 
                //PartTitle = PartTitlesLst[i].Remove(0, 1).Trim();
                PartTitle = PartTitle.Remove(0, 1).Trim();
                Child1FileName = "";
                Child2FileName = "";

                //check if still another level. Child 2
                if (IsExpandedChild(PartTitle))
                {
                    // PartTitle = PartTitlesLst[i].Trim(new char[] { '~' }).Trim();
                    //PartTitle = PartTitle.Remove(0, 1).Trim();
                    PartTitle = PartTitle.Remove(0, 1).Trim();
                    isChild1Item = false;
                    isChild2Item = true;
                    //make abbreviation for child 2
                    Child2KeyAbbr = GetAbbreviation(PartTitle, subAreaChid2keylength);

                    if (ChildKeyAbbrCheckLst.Count == 0)
                    {
                        //list empty, part abbreviation must be unique and must not be child
                        ChildKeyAbbrCheckLst.Add(Child2KeyAbbr);
                    }
                    else
                    {
                        //Other part abbreviations have been already created so check to make sure this parts abbreviation is unique
                        while (ChildKeyAbbrCheckLst.FirstOrDefault(x => x == Child2KeyAbbr) != null)
                        {
                            //Part abbreviation not unique used so iterate it
                            k++;
                            Child2KeyAbbr = makeUnique(Child2KeyAbbr, subAreaChid2keylength, k);
                        }
                        k = 1;
                        ChildKeyAbbrCheckLst.Add(Child2KeyAbbr);
                    }
                }
                else
                {
                    isChild1Item = true;
                    isChild2Item = false;
                    //make abbreviation for child 1
                    Child1KeyAbbr = GetAbbreviation(PartTitle, subAreaChid1keylength);

                    if (ChildKeyAbbrCheckLst.Count == 0)
                    {
                        //list empty, part abbreviation must be unique and must not be child
                        ChildKeyAbbrCheckLst.Add(Child1KeyAbbr);
                    }
                    else
                    {
                        //Other part abbreviations have been already created so check to make sure this parts abbreviation is unique
                        while (ChildKeyAbbrCheckLst.FirstOrDefault(x => x == Child1KeyAbbr) != null)
                        {
                            //Part abbreviation not unique used so iterate it
                            k++;
                            Child1KeyAbbr = makeUnique(Child1KeyAbbr, subAreaChid1keylength, k);
                        }
                        k = 1;
                        ChildKeyAbbrCheckLst.Add(Child1KeyAbbr);
                    }
                }
            }

            if (isChild1Item == true)
            {
                AbbrLength = subAreaChid1keylength;
                AbbrKey = subAreakeyAbbr + Child1KeyAbbr;
            }
            else if (isChild2Item == true)
            {
                AbbrLength = subAreaChid2keylength;
                AbbrKey = subAreakeyAbbr + Child1KeyAbbr + Child2KeyAbbr;
            }
            else
            {
                AbbrLength = subAreakeylength;
                AbbrKey = subAreakeyAbbr;
            }

            //Generate Abbreviation
            ItemAbbreviation = GetAbbreviation(PartTitle, AbbrLength);
            //Put together full abbreviation
            ItemAbbreviation = AbbrKey + ItemAbbreviation;

            //Make sure part abbreviation is unique
            //Add tag name to check list, to make sure all part abbreviation are unique
            if (PartAbbrCheckLst.Count == 0)
            {
                //list empty, part abbreviation must be unique and must not be child
                PartAbbrCheckLst.Add(ItemAbbreviation);
            }
            else
            {
                //Other part abbreviations have been already created so check to make sure this parts abbreviation is unique
                while (PartAbbrCheckLst.FirstOrDefault(x => x == ItemAbbreviation) != null)
                {
                    //Part abbreviation not unique used so iterate it
                    k++;
                    ItemAbbreviation = makeUnique(ItemAbbreviation, AbbrLength, k);
                }
                k = 1;
                PartAbbrCheckLst.Add(ItemAbbreviation);
            }

            //Create final tag
            if (isChild1Item == true && Child1FileName == "")
            {
                //Part is not a Part but a diagram, so create diagram name for child and use that as its tag abbreviation for its parts
                Child1FileName = CreateChldExpDiaFN(PartTitlesLst[i].Trim(new char[] { '~' }).Trim(), AbbrKey);
                builder.Append(Child1FileName);
            }
            else if (isChild2Item == true && Child2FileName == "")
            {
                //Part is not a Part but a diagram, so create diagram name for child and use that as its tag abbreviation for its parts
                //must remove file identifier, Note must do it 2 times because it is a child of a child and has a identifier of "~~"
                string tempExpDiaName = "";
                tempExpDiaName = PartTitlesLst[i].Trim(new char[] { '~' });

                Child2FileName = CreateChldExpDiaFN(tempExpDiaName.Trim(new char[] { '~' }).Trim(), AbbrKey);
                builder.Append(Child2FileName);
            }
            else
            {
                //part is a part not diagram, so create normal tag to Location Edit
                builder.Append(TagNameSec1 + "|" + TagNameSec2 + "|" + TagNameSec3 + "|" + ItemAbbreviation + "|" + TagNameSec5);
            }
            PartTagNamesLst.Add(builder.ToString());

            Sec4TagNameCheckLst.Add(ItemAbbreviation);
        }



        return PartTagNamesLst;
    }


    private string GetAbbreviation(string ItemName, int ItemAbbrLength)
    {
        string ItemAbbr = "";
        string NameTagReadyStr = "";

        //Check to see if part title needs to be shorten 
        if (TitleNeedsShortenName(ItemName, ItemAbbrLength))
            NameTagReadyStr = ShortenName(ItemName, ItemAbbrLength);//shorten parts title
        else
            NameTagReadyStr = ItemName;//part tag is ready for abbreviation 

        //create abbreviation 
        ItemAbbr = CreateAbbreviation(NameTagReadyStr);

        return ItemAbbr;
    }

    private string makeUnique(string ItemAbbr, int ItemAbbrLength, int Iteration)
    {

        if (ItemAbbr.Length < ItemAbbrLength)
            //part abbreviation can have another character so just add one on the end
            ItemAbbr = ItemAbbr + Iteration;
        else
        {
            //Part abbreviation has max characters so remove last and replace with indexed number
            if (Iteration >= 10)//if replacing last character with > 10 must remove last 2 characters.
                ItemAbbr = ItemAbbr.Remove(ItemAbbr.Length - 2) + Iteration;
            else
                ItemAbbr = ItemAbbr.Remove(ItemAbbr.Length - 1) + Iteration;
        }

        return ItemAbbr;

    }


    //Utility Functions
    private string CreateAbbreviation(string fullName)
    {
        string tagName = "";

        foreach (string c in fullName.Split(' '))
        {
            if (c != "")
                tagName += c.Substring(0, 1);
        }

        return tagName;
    }

    private bool IsDiagramName(string title)
    {
        if (title.EndsWith("-"))
        {
            return true;
        }
        return false;
    }

    private bool IsExpandedChild(string title)
    {
        if (title.StartsWith("~"))
        {
            return true;
        }
        return false;
    }

    private bool TitleNeedsShortenName(string Name, int AbbrvMaxLength)
    {
        int countWords = Name.Split().Length;
        if (countWords > AbbrvMaxLength)
            return true;
        else
            return false;
    }


    private Tuple<int, int, int> GetAbbrLenths(List<string> partsForDiagram)
    {
        int LayersCount = 0;
        string Temptitle = "";
        int subAreakey = 0; //key to all sub area items. EX: Deaerator tank (|DT)
        // int subAreaItem = 0;//sub area item opens to location edit. EX: Deaerator tank relief valve (|DTRF)
        int subAreaChid1key = 0; //key to all child 1 items. EX: Deaerator tank pump 1 (|DTP1)
        // int subAreachild1Item = 0;//sub area child 1 items open to location edit. EX: Deaerator tank pump 1 motor (|DTP1M)
        int subAreaChid2key = 0; //key to all child 2 items. EX: Deaerator tank pump 1 motor (|DTP1M)
        // int subAreachild2Item = 0;//sub area child 2 items open to location edit. EX: Deaerator tank pump 1 motor grease (|DTP1MG)


        int childCount = partsForDiagram.Count;

        for (int i = 0; i < childCount; i++)
        {
            if (IsExpandedChild(partsForDiagram[i]))
            {

                Temptitle = partsForDiagram[i].Remove(0, 1).Trim();

                if (LayersCount == 0)
                    LayersCount = 4;

                if (IsExpandedChild(Temptitle))
                {
                    LayersCount = 5;
                }
            }
        }

        //Note, all child other than first have abbreviation of length 1
        switch (LayersCount)
        {
            case 0:
                {
                    //3 layers
                    //sub area items open to location edit
                    subAreakey = 3;
                    //subAreaItem = 3;
                    subAreaChid1key = 0;
                    //subAreachild1Item = 0;
                    subAreaChid2key = 0;
                    // subAreachild2Item = 0;
                    break;
                }
            case 4:
                {
                    //4 layers
                    //sub area items open to location edit
                    //sub area items open child 1 diagram
                    //child 1 diagram items open to location edit 
                    subAreakey = 2;
                    // subAreaItem = 3;
                    subAreaChid1key = 2;
                    // subAreachild1Item = 2;
                    subAreaChid2key = 0;
                    // subAreachild2Item = 0;
                    break;
                }
            case 5:
                {
                    //5 layers
                    //sub area items open to location edit
                    //sub area items open child 1 diagram
                    //child 1 diagram items open to location edit
                    //child 1 diagram items open to child 2 diagram
                    //child 2 diagram items open to location edit
                    subAreakey = 2;
                    // subAreaItem = 3;
                    subAreaChid1key = 2;
                    // subAreachild1Item = 2;
                    subAreaChid2key = 1;
                    // subAreachild2Item = 1;
                    break;
                }
            default:
                {
                    break;
                }
        }

        Tuple<int, int, int> tuple = new Tuple<int, int, int>(subAreakey, subAreaChid1key, subAreaChid2key);

        return tuple;
    }


    private string ShortenName(string fullName, int MaxNameLgth)
    {
        List<string> d = new List<string>();
        string[] stringArray = { "EAST", "WEST", "NORTH", "SOUTH", "TOP", "BOTTOM", "MIDDLE", "OPERATOR", "DRIVE" };

        string ShortName = fullName;

        //Get all matched words
        d = stringArray.Where(s => fullName.Contains(s)).ToList();

        int dcount = d.Count();

        for (int i = 0; i < dcount; i++)
        {
            ShortName = ShortName.Replace(d[i], "").Trim();
        }

        //If name is still longer than 3
        while (GetWordCount(ShortName) > MaxNameLgth)
        {
            string lastWord = GetLastWord(ShortName);
            int LWcount = lastWord.Length;

            ShortName = ShortName.Remove(ShortName.Length - LWcount).Trim();
        }


        return ShortName.Trim();
    }

    private string GetLastWord(string fullName)
    {
        string[] TempSName = fullName.Split(' ');
        string lastWord = TempSName[TempSName.Length - 1];

        return lastWord;
    }

    private int GetWordCount(string fullName)
    {
        return fullName.Split().Length;
    }

    private bool IsProblem(List<string> PartTagNameLst)
    {
        bool isproblem = true;

        bool isUnique = PartTagNameLst.Distinct().Count() == PartTagNameLst.Count();
        string longestTag = Sec4TagNameCheckLst.Aggregate("", (max, cur) => max.Length > cur.Length ? max : cur);

        if (longestTag.Length <= 6)
            isproblem = false;

        if (isUnique)
            isproblem = false;


        return isproblem;
    }
}





//Define path to user desktop to save finished file to
//writeFullPath = Path.Combine(Environment.GetFolderPath(System.Environment.SpecialFolder.DesktopDirectory), FileUpload1.FileName + "Done.csv");

// writeFullPath = Path.Combine(Server.MapPath("~/Files"), FileUpload1.FileName + "Done.csv");


//using (StreamWriter writer = new StreamWriter(writeFullPath, true))
//{
//    var FLine = String.Format("{0},{1}", pair.Key, subAreaTitle);
//    writer.WriteLine(FLine);

//    int listCount = PartTagNameLst.Count;
//    for (int i = 0; i < listCount; i++)
//    {
//        var PLine = String.Format("{0},{1}", pair.Value[i].Trim(new char[] { '~' }).Trim(), PartTagNameLst[i]);
//        writer.WriteLine(PLine);
//    }
//}
