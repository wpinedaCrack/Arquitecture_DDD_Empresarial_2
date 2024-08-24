﻿/*
 * using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

namespace Pacagroup.Ecommerce.Services.WebApi
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}*/
using HealthChecks.UI.Client;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc.ApiExplorer;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Pacagroup.Ecommerce.Services.WebApi.Modules.Authentication;
using Pacagroup.Ecommerce.Services.WebApi.Modules.Feature;
using Pacagroup.Ecommerce.Services.WebApi.Modules.HealthCheck;
using Pacagroup.Ecommerce.Services.WebApi.Modules.Injection;
//using Pacagroup.Ecommerce.Services.WebApi.Modules.Mapper;
using Pacagroup.Ecommerce.Services.WebApi.Modules.RateLimiter;
using Pacagroup.Ecommerce.Services.WebApi.Modules.Redis;
using Pacagroup.Ecommerce.Services.WebApi.Modules.Swagger;
//using Pacagroup.Ecommerce.Services.WebApi.Modules.Validator;
using Pacagroup.Ecommerce.Services.WebApi.Modules.Versioning;
using Pacagroup.Ecommerce.Services.WebApi.Modules.Watch;
using WatchDog;
using Pacagroup.Ecommerce.Persistence;
using Pacagroup.Ecommerce.Application.UseCases;
using Pacagroup.Ecommerce.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

//builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

//builder.Services.AddMapper();
builder.Services.AddFeature(builder.Configuration);
builder.Services.AddPersistenceServices(builder.Configuration);//Inyeccion desde Persistence
builder.Services.AddInfrastructureServices();//**
builder.Services.AddApplicationServices();//Inyeccion desde Apliacación

builder.Services.AddInjection(builder.Configuration);
builder.Services.AddAuthentication(builder.Configuration);
builder.Services.AddVersioning();
builder.Services.AddSwagger();
//builder.Services.AddValidator();
builder.Services.AddHealthCheck(builder.Configuration);
builder.Services.AddWatchDog(builder.Configuration);
builder.Services.AddRedisCache(builder.Configuration);
builder.Services.AddRatelimiting(builder.Configuration);

var app = builder.Build();
var provider = app.Services.GetRequiredService<IApiVersionDescriptionProvider>();
// configure the Http request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        // build a swagger endpoint for each discovered API version
       
        foreach (var description in provider.ApiVersionDescriptions)
        {
            c.SwaggerEndpoint($"/swagger/{description.GroupName}/swagger.json", description.GroupName.ToUpperInvariant());
        }
    });
}

app.UseWatchDogExceptionLogger();
app.UseHttpsRedirection();
app.UseCors("policyApiEcommerce");

app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.UseRateLimiter();
app.UseEndpoints(endpoints => { });


app.MapControllers();
app.MapHealthChecksUI();
app.MapHealthChecks("/health", new Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions
{
    Predicate = _ => true,
    ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
});

app.UseWatchDog(conf =>
{
    conf.WatchPageUsername = builder.Configuration["WatchDog:WatchPageUsername"];
    conf.WatchPagePassword = builder.Configuration["WatchDog:WatchPagePassword"];
});

app.Run();

public partial class Program { };
