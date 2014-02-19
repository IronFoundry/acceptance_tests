using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace asp_net_app.Controllers
{
    public class LogController : ApiController
    {
        
        public object GetLog(string entry)
        {
            return WriteLogEntry(entry);
        }

        public object PostLog(string entry)
        {
            return WriteLogEntry(entry);
        }

        private object WriteLogEntry(string entry)
        {
            Console.WriteLine(entry);
            return "Posted: " + entry;
        }                
    }
}
