<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Dashboard" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="large-12 column fullWidth">
        <h1>Dashboard</h1>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

    <div class="row">
        <div class="small-12 medium-10 large-7 small-centered columns">

            <div class="header panel">
                <div class="sign">
                    <h1>Welcome</h1>
                </div>
                <p>
                    Hello, I am Jordon Muzzillo. I have made this website to further distinguish myself from others, and save time and effort for potential employers. 
                    Below are four widgets that give a summary of who I am, and how I can benefit your organization. The tabs on the left-hand side of the screen will 
                    direct you to pages that provide more information about myself. This site contains numerous facts and details about myself, please have a look around 
                    and get to know me a little better. If you believe that I would make a good candidate for your company, in the footer of every page there is a contact link that contains multiple ways to for us to get in touch.
                </p>
            </div>

        </div>

    </div>

    <%--Top widgets --%>
    <div id="WidgetDiv" class="row" data-equalizer="topWidgets">
        <%--TOP WIDGET 1 --%>
        <div class="large-3 column">
            <div class="panel radius dash-widget" id="TopWidget_1" data-equalizer-watch="topWidgets">
                <div class="row panel-primary">
                    <div class="large-2 columns widget-icon-hover">
                        <a href="#"><i id="WhoIAmI" class="fi-megaphone QucikView"></i></a>
                    </div>
                    <div class="large-10 columns">
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="panel-text">Who I am</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row panel-footer">
                    <div class="large-12 columns">
                        <a>
                            <span id="WhoIAm" class="QucikView secondary radius label "><i class="fi-arrow-right right"></i>View Quick Details</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <%--TOP WIDGET 2 --%>
        <div class="large-3 column">
            <div class="panel radius dash-widget" id="TopWidget_2" data-equalizer-watch="topWidgets">
                <div class="row panel-primary">
                    <div class="large-2 columns widget-icon-hover">
                        <a href="#"><i id="EducationI" class="fi-book QucikView"></i></a>
                    </div>
                    <div class="large-10 columns">
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="panel-text">Education have I received</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row panel-footer">
                    <div class="large-12 columns">
                        <a href="#">
                            <span id="Education" class="QucikView secondary radius label"><i class="fi-arrow-right right"></i>View Quick Details</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <%--TOP WIDGET 3 --%>
        <div class="large-3 column">
            <div class="panel radius dash-widget" id="TopWidget_3" data-equalizer-watch="topWidgets">
                <div class="row panel-primary">
                    <div class="large-2 columns widget-icon-hover">
                        <a href="#"><i id="ExperienceI" class="fi-compass QucikView"></i></a>
                    </div>
                    <div class="large-10 columns">
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="panel-text">Experience I have gained</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row panel-footer">
                    <div class="large-12 columns">
                        <a href="#">
                            <span id="Experience" class="QucikView secondary radius label "><i class="fi-arrow-right right"></i>View Quick Details</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <%--TOP WIDGET 4 --%>
        <div class="large-3 column">
            <div class="panel radius dash-widget" id="TopWidget_4" data-equalizer-watch="topWidgets">
                <div class="row panel-primary">
                    <div class="large-2 columns widget-icon-hover">
                        <a href="#"><i id="SkillsI" class="fi-star QucikView"></i></a>
                    </div>
                    <div class="large-10 columns">
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="panel-text">Skills I earned</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row panel-footer">
                    <div class="large-12 columns ">
                        <a href="#">
                            <span id="Skills" class="QucikView secondary radius label "><i class="fi-arrow-right right"></i>View Quick Details</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--QuickView Modal For Footer--%>
    <div id="QuickView_Modal" class="reveal-modal" data-reveal="" aria-labelledby="" aria-hidden="true" role="dialog">
        <div class="QuickView-container">
            <%--WHO AM I--%>
            <div id="WhoIAmDiv" class="medium-12 large-12 columns text-center QuickViewInfo" visible="False">
                <div class="row">
                    <div class="small-12 columns text-left">
                        <h3>Who I Am Quick View</h3>
                    </div>
                </div>
                <div class="row">
                    <div class="small-12 columns">
                        <h4 class="OverView h4_white">Overview</h4>
                    </div>
                    <div class="row text-left">
                        <div class="small-12 columns">
                            <ul class="disc">
                                <li>Age: 26</li>
                                <li>Sex: Male</li>
                                <li>I am a dedicated and loyal individual. I seek to further 
                                    not only my skills and add value to life 
                                    but, also that of those within my circle of influence.</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="small-12 columns">
                        <h4 class="Achievements h4_white">Achievements</h4>
                    </div>
                    <div class="row text-left">
                        <div class="small-12 columns">
                            <div class="row text-left">
                                <div class="medium-6 columns">
                                    <ul class="disc">
                                        <li>Competed in organized competition:
                                        <ul>
                                            <li>Basketball</li>
                                            <li>Football</li>
                                            <li>Rugby</li>
                                            <li>MMA</li>
                                            <li>Motocross</li>
                                        </ul>
                                        </li>
                                    </ul>
                                </div>
                                <div class="medium-6 columns">
                                    <ul class="disc">
                                        <li>Learned multiple skilled disciplines:
                                        <ul>
                                            <li>Welding and metal fabrication</li>
                                            <li>Outdoors life</li>
                                            <li>Technology</li>
                                        </ul>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="small-12 columns">
                        <h4 class="Goals h4_white">Goals</h4>
                    </div>
                    <div class="row text-left">
                        <div class="small-12 columns">
                            <ul class="disc">
                                <li>Short Term
                                     <ul>
                                         <li>Develop real-world work experience within the field of engineering.
                                             As I further my degree in Mechanical Engineering, it has become time to 
                                             start developing real-world experience that will aid in career placement 
                                             when I graduate. 
                                         </li>
                                     </ul>
                                </li>
                                <li>Long Term
                                     <ul>
                                         <li>To become a tremendous asset to an organization, reaching higher positions 
                                             as the company and myself grow and helping as a  
                                             vital partner to the long-term success.
                                         </li>
                                     </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <%--Education--%>
            <div id="EducationDiv" class="medium-12 large-12 columns text-center QuickViewInfo" visible="False">
                <div class="row">
                    <div class="small-12 columns text-left">
                        <h3>Education Quick View</h3>
                    </div>
                </div>
                <div class="row">
                    <div class="small-12 columns">
                        <h4 class="OverView h4_white">Overview</h4>
                    </div>
                    <div class="row text-left">
                        <div class="small-12 columns">
                            <ul class="disc">
                                <li>HighSchool
                                    <ul>
                                        <li>LakeWood Park Christian School </li>
                                        <li>East Noble High School</li>
                                    </ul>
                                </li>
                                <li>College
                                    <ul>
                                        <li>Indiana University Purdue University Fort Wayne</li>
                                        <li>Finished a bachelor's degree in Information Systems From IPFW in December 2013</li>
                                        <li>Graduate with bachelors in Mechanical Engineering From IPFW in May 2018 </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="small-12 columns">
                        <h4 class="Achievements h4_white">Achievements</h4>
                    </div>
                    <div class="row text-left">
                        <div class="small-12 columns">
                            <ul class="disc">
                                <li>High School
                                    <ul>
                                        <li>Graduated from East Noble High School in 2009
                                        </li>
                                    </ul>
                                </li>
                                <li>College
                                    <ul>
                                        <li>Graduated with bachelors in Information Systems From IPFW in December 2013 </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="small-12 columns">
                        <h4 class="Goals h4_white">Goals</h4>
                    </div>
                    <div class="row text-left">
                        <div class="small-12 columns">
                            <ul class="disc">
                                <li>Short Term
                                     <ul>
                                         <li>To be focused and driven on gaining knowledge in the skills that are required of me.
                                         </li>
                                     </ul>
                                </li>
                                <li>Long Term
                                     <ul>
                                         <li>To pursue an MBA program that with a focus on project management. 
                                             After working for a period of one to two years in the field of engineering 
                                             I will reevaluate this goal and make adjustments.
                                         </li>
                                     </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <%--Experience--%>
            <div id="ExperienceDiv" class="medium-12 large-12 columns text-center QuickViewInfo" visible="False">
                <div class="row">
                    <div class="small-12 columns text-left">
                        <h3>Experience Quick View</h3>
                    </div>
                </div>
                <div class="row">
                    <div class="small-12 columns">
                        <h4 class="OverView h4_white">Overview</h4>
                    </div>
                    <div class="row text-left">
                        <div class="small-12 columns">
                            <ul class="disc">
                                <li>Dog Pound Fitness
                                    <ul>
                                        <li>A startup company that I attempted. The company made and distributed Cross 
                                            Training equipment.</li>
                                    </ul>
                                </li>
                                <li>Franklin Electric
                                    <ul>
                                        <li>June 2013 to August 2013</li>
                                        <li>The worlds leading global provider of complete water and fueling systems.</li>
                                        <li>I received an internship and worked as a member of their Internal Applications Development Team for a summer.</li>
                                    </ul>
                                </li>
                                <li>Custom Software Solutions
                                    <ul>
                                        <li>2011 to 2013 - August 2013 to May 2016</li>
                                        <li>A small software company located in Fort Wayne.</li>
                                        <li>Responsible for converting classic ASP pages to ASP.net 
                                            as well as maintaining websites, programs, and reports.
                                        </li>
                                    </ul>
                                </li>
                                <li>Metalworking Lubricants Company
                                    <ul>
                                        <li>September 2017 To January 2018</li>
                                        <li>A custom blender of metal removal and metal fabricating fluids established in 1952. </li>
                                        <li>During my time at Steel Dynamics, I reached the maximum amount of hours an intern is allowed to work in a year. 
                                            Steel Dynamics worked out a deal with one of the oil suppliers to hire me until my hours reset at the end of the year (Approximately three months). 
                                            During this time I conducted weekly tasks such as inventory and performed a lubrication study of the Cold Mill. </li>
                                    </ul>
                                </li>
                                <li>Steel Dynamics: Flat Roll Group - Butler Division
                                    <ul>
                                        <li>May 2016 to September 2017: January 2018 to Current</li>
                                        <li>One of the most efficient flat roll steel sheet mills in the world</li>
                                        <li>I Worked in the Cold Mill as an engineering intern for two years. Most of my time was spent working with the Continuous Pickle Line, Push-Pull Pickle Line, and Reversing Mill.</li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="small-12 columns">
                        <h4 class="Goals h4_white">Goals</h4>
                    </div>
                    <div class="row text-left">
                        <div class="small-12 columns">
                            <ul class="disc">
                                <li>Short Term
                                     <ul>
                                         <li>Develop real-world work experience within the field of engineering.
                                             As I further my degree in Mechanical Engineering, it has become time to 
                                             start developing real-world experience that will aid in career placement 
                                             upon graduation.
                                         </li>
                                     </ul>
                                </li>
                                <li>Long Term
                                     <ul>
                                         <li>To continually seek experience, and look at every challenge as an opportunity to become better. 
                                             To continuously push myself and those around me to not be satisfied with the status quo. 
                                             To enjoy the journey of getting to where I want to go, not merely focusing on the destination.
                                         </li>
                                     </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <%--Skills--%>
            <div id="SkillsDiv" class="medium-12 large-12 columns text-center QuickViewInfo" visible="False">
                <div class="row">
                    <div class="small-12 columns text-left">
                        <h3>Skills Quick View</h3>
                    </div>
                </div>
                <div class="row">
                    <div class="small-12 columns">
                        <h4 class="OverView h4_white">Overview</h4>
                    </div>
                    <div class="row text-left">
                        <div class="small-4 columns">
                            <ul class="disc">
                                <li>Technical Program Tools 
                                    <ul>
                                        <li>MS Visual Studio</li>
                                        <li>Embedded VS</li>
                                        <li>Platform Builder</li>
                                        <li>Microsoft Office</li>
                                        <li>Microsoft Project</li>
                                        <li>Visio</li>
                                        <li>SolidWorks</li>
                                        <li>AutoCAD</li>
                                        <li>NI Multisim</li>
                                        <li>Adobe Photoshop</li>
                                        <li>Adobe Illustrator</li>
                                        <li>simplify3d</li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <div class="small-4 columns">
                            <ul class="disc">
                                <li>Programing Languages
                                    <ul>
                                        <li>ASP, ASP.net, Visual Basic, c#</li>
                                        <li>HTML</li>
                                        <li>Javascript, jquery</li>
                                        <li>c, c++, Java</li>
                                        <li>MatLab, Mathematica</li>
                                        <li>SQL Server, Microsoft Access, MySQL</li>
                                        <li>Ladder Logic</li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <div class="small-4 columns">
                            <ul class="disc">
                                <li>Other Relevant Skills
                                    <ul>
                                        <li>Computer building</li>
                                        <li>Welding and metal fabrication</li>
                                        <li>3d Printing</li>
                                        <li>Communication and team work</li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="small-12 columns">
                        <h4 class="Goals h4_white">Goals</h4>
                    </div>
                    <div class="row text-left">
                        <div class="small-12 columns">
                            <ul class="disc">
                                <li>Short Term
                                     <ul>
                                         <li>To get a certification in SolidWorks (CSWA)</li>
                                         <li>Add the ability to mill (CNC) with my 3d Printer</li>
                                     </ul>
                                </li>
                                <li>Long Term
                                     <ul>
                                         <li>To continually seek to build my knowledge in new and existing programs. Program in at least one language two times a week.</li>
                                         <li>Learn a new skill/hobby at least once a year (at the current moment I am working on 3d printing)</li>
                                     </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <a class="close-reveal-modal" aria-label="Close">&#215;</a>
    </div>
</asp:Content>
<asp:Content ID="ScriptContentPlaceHolder" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="Server">

    <script src="public/js/min/jquery.min.js"></script>
    <script src="public/js/min/foundation.min.js"></script>
    <script src="public/js/nonmin/dashboard.js"></script>


    <%--CALL JAVASCRIPT FUNCTIONs--%>

    <script type="text/javascript">
        window.onload = function () {
            DashboardScript();
        };
    </script>
</asp:Content>

