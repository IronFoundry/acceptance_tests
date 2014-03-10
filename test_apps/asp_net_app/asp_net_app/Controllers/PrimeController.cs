using asp_net_app.Prime;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace asp_net_app.Controllers
{
    public class PrimeController : Controller
    {
        //
        // GET: /Prime/
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult PrimeSearch(int PrimeSearchValue)
        {
            var sieve = new PrimeSieve(PrimeSearchValue);
            sieve.ComputePrimes();
            var values = sieve.ToArray();

            ViewBag.PrimeNumbers = values;

            return View("Index");
        }
	}
}