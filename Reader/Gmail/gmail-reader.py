import pickle
import os.path
from pathlib import Path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

# If modifying these scopes, delete the file token.pickle.
SCOPES = ["https://www.googleapis.com/auth/gmail.readonly"]
script_dir = Path(__file__).parent

def get_messages(labels: list[str]):
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists("token.ignore.pickle"):
        with open("token.ignore.pickle", "rb") as token:
            creds = pickle.load(token)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                "credentials.ignore.json", SCOPES
            )
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open("token.ignore.pickle", "wb") as token:
            pickle.dump(creds, token)

    service = build("gmail", "v1", credentials=creds)

    # Call the Gmail API
    results = service.users().messages().list(userId="me", maxResults=10).execute()
    messages = results.get("messages", [])

    for x in messages:
        details = service.users().messages().get(userId="me", id=x["id"]).execute()
        subject = [
            h for h in details["payload"]["headers"] if h["name"] == "Subject"
        ][0]["value"]
        if any(label in details["labelIds"] for label in labels):
            yield subject, details["snippet"], "UNREAD" in details["labelIds"]


if __name__ == "__main__":
    from sys import argv

    if len(argv) < 3:
        print("options: <messages-limit> <label1> <label2> ...")
        exit(1)

    limit = int(argv[1])
    labels = [a.strip().upper() for a in argv[2:] if not a.startswith("-")]

    messages = [(a, b, c) for a, b, c in get_messages(labels)]

    while len(messages) < limit:
        messages.append(("", "", 0))

    with open(script_dir / "last-request.ignore.txt", "w+") as out_file:
        for subject, snippet, is_unread in messages:
            out_file.write(f"subject[{subject}]snippet[{snippet}]unread[{int(is_unread)}]\n")
