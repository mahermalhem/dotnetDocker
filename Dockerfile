# ---------- Build stage ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy csproj and restore
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o /out

# ---------- Runtime stage ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# 🔥 Make ASP.NET listen on all IPs
ENV ASPNETCORE_URLS=http://+:8080

# Copy build output
COPY --from=build /out .

# Expose port
EXPOSE 8080

# Run the app
ENTRYPOINT ["dotnet", "MyWeb.dll"]

# docker build -t maherdotnet .
# docker run -d -p 8080:8080 --name maher-app  maherdotnet .