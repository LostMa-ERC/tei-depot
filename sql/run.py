import click
from pathlib import Path
import duckdb

DB_PATH = Path(__file__).parent.parent.joinpath("heurist.db")
RESULTS_DIR = Path(__file__).parent.joinpath("results")


@click.command()
@click.argument("sql")
def cli(sql):
    conn = duckdb.connect(str(DB_PATH), read_only=True)
    with open(sql) as f:
        query = f.read()
    rel = conn.sql(query)
    stem = f"{Path(sql).stem}.csv"
    fp = RESULTS_DIR.joinpath(stem)
    rel.write_csv(str(fp))


if __name__ == "__main__":
    cli()
