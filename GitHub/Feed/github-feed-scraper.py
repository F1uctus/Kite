import sys
import requests
from bs4 import BeautifulSoup


def get_token() -> str:
    with open('token-github-feed.txt', 'r') as f:
        return f.read()


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("options: <user-name> <news-limit>")
        exit(1)
    elif len(sys.argv) < 3:
        user_name = sys.argv[1]
        limit = 20
    else:
        user_name = sys.argv[1]
        limit = int(sys.argv[2])

    URL = f"https://github.com/{user_name}.private.atom?token={get_token()}"

    page = requests.get(URL)
    entry = BeautifulSoup(page.content, "html.parser").feed.entry

    i = 0
    with open("last-request.txt", "w") as out_file:
        while entry is not None and i < limit:
            title = entry.title.string
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
