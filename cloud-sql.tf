
resource "random_id" "db_name_suffix" {
  byte_length = 4
}
resource "google_sql_database_instance" "postgres" {
  name = "postgres-instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_11"  
  settings{
    tier = "db-f1-micro"
    user_labels = {
      "environment" = "development"
    }
    backup_configuration {
      enabled = false
    }
  }
}

resource "google_sql_user" "users" {
  name     = "user2"
  instance = google_sql_database_instance.postgres.name
  password = "password"
}
resource "google_sql_database" "database" {
  name     = "main-database"
  instance = google_sql_database_instance.postgres.name
}