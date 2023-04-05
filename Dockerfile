#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["AllergyServiceApi/AllergyServiceApi.csproj", "AllergyServiceApi/"]
COPY ["ASBusinessLogic/ASBusinessLogic.csproj", "ASBusinessLogic/"]
COPY ["ASDataFluentApi/ASDataFluentApi.csproj", "ASDataFluentApi/"]
COPY ["ASModels/ASModels.csproj", "ASModels/"]
RUN dotnet restore "AllergyServiceApi/AllergyServiceApi.csproj"
COPY . .
WORKDIR "/src/AllergyServiceApi"
RUN dotnet build "AllergyServiceApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AllergyServiceApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AllergyServiceApi.dll"]