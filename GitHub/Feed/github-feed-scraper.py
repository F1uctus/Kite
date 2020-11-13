import sys
import requests
from pathlib import Path
from bs4 import BeautifulSoup

script_dir = Path(__file__).parent

def get_token() -> str:
    with open(script_dir / 'token-github-feed.ignore.txt', 'r') as f:
        return f.read()


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("options: <user-name> <news-limit>")
        exit(1)

    user_name = sys.argv[1]
    if len(sys.argv) < 3:
        limit = 20
    else:
        limit = int(sys.argv[2])

    debug = any(arg for arg in sys.argv if arg in {"--debug", "-d"})

    URL = f"https://github.com/{user_name}.private.atom?token={get_token()}"

    page = requests.get(URL)
    entry = BeautifulSoup(page.content, "html.parser").feed.entry

    i = 0
    with open(script_dir / "last-request.ignore.txt", "w") as out_file:
        while entry is not None and i < limit:
            title = entry.title.string

            if debug:
                print(title)

            description_div = BeautifulSoup(
                entry.content.string,
                "html.parser"
            ).find("div", ["repo-description"])

            description = ""
            if description_div is not None \
               and description_div.p is not None \
               and description_div.p.string is not None:
                description = description_div.p.string

            out_file.write(f"title[{title}]; description[{description}]\n")

            i += 1
            entry = entry.find_next("entry")
