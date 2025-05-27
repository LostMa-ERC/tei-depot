import click
from pathlib import Path
import duckdb

DB_PATH = Path(__file__).parent.parent.joinpath("heurist.db")
RESULTS_DIR = Path(__file__).parent.joinpath("results")


@click.command()
@click.argument("sql")
@click.argument("csv")
def cli(sql, csv):
    conn = duckdb.connect(str(DB_PATH))
    with open(sql) as f:
        query = f.read()
    rel = conn.sql(query)
    fp = RESULTS_DIR.joinpath(csv)
    rel.write_csv(str(fp))


if __name__ == "__main__":
    cli()
