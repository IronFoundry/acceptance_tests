using System.Diagnostics;
using asp_net_app.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace asp_net_app.Controllers
{
    public class InstanceController : ApiController
    {
        [HttpGet]
        public int ProcessId()
        {
            return Process.GetCurrentProcess().Id;
        }

        [HttpGet]
        public string MachineName()
        {
            return Environment.MachineName;
        }
    }
}
