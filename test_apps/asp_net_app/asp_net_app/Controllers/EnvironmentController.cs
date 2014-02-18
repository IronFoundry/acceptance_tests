using asp_net_app.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace asp_net_app.Controllers
{
    public class EnvironmentController : ApiController
    {


        public IEnumerable<EnvironmentSetting> GetEnvironment()
        {
            var settings = Environment.GetEnvironmentVariables();
            foreach(var key in settings.Keys)
            {
                yield return new EnvironmentSetting { Name = key.ToString(), Value = settings[key].ToString() };
            }
        }

        public EnvironmentSetting Get(string id)
        {
            var settings = Environment.GetEnvironmentVariables();
            if (settings.Contains(id))
            {
                return new EnvironmentSetting() { Name = id, Value = settings[id].ToString() };
            }

            throw new HttpResponseException(HttpStatusCode.NotFound);
        }
    }
}
