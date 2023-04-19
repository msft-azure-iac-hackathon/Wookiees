using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http;

namespace WebGetter
{
    public static class Function
    {
        [FunctionName("GetData")]
        public static async Task<IActionResult> Run()
        {

            // todo: get url from vault
            var url = "https://www.google.com";

            // rudimentay validation
            if(!Uri.TryCreate(url, UriKind.Absolute, out var uri))
                return new ObjectResult($"Configuration error: url is not a valid absolute url: {url}") { StatusCode = StatusCodes.Status500InternalServerError };

            // get data
            using var c = new HttpClient();
            var content = await c.GetAsync(uri.ToString());

            if(!content.IsSuccessStatusCode)
                return new ObjectResult($"Failed to obtain vale from url, response code {content.StatusCode}") { StatusCode = StatusCodes.Status500InternalServerError};

            // write data
            // todo: write data to blob

            string responseMessage = "This function executed successfully. (but no data was persisted)";

            return new OkObjectResult(responseMessage);
        }
    }
}
