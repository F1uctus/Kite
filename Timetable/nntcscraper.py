import requests
import re
import sys
import os
from typing import Dict, List
from datetime import datetime
from bs4 import BeautifulSoup


def clear_str(s) -> str:
    return s.strip().lower()


class Lesson:
    def __init__(
        self,
        teacher: str = "",
        discipline: str = "",
        pair_num: str = "",
        place: str = "",
    ):
        super().__init__()
        self.teacher = teacher
        self.discipline = discipline
        self.pair_num = pair_num
        self.place = place

    def __str__(self):
        return f"'{self.pair_num}'\t'{self.discipline}'\t'{self.teacher}'\t'{self.place}'"


SCHEDULE_URL = "https://nntc.nnov.ru/sites/default/files/sched/zameny.html"
GROUP_NAME_PATTERN = r"(\d)?([А-Яа-я]{2,6})-(\d{2})-(\d+)?"
OUTPUT_FILE_NAME = "last-schedule.txt"


def request_schedule(group_name: str) -> Dict[str, Lesson]:
    group_name = clear_str(group_name)

    # add course digit if missing
    if not group_name[0].isdigit():
        year_current_YY = datetime.now().year % 100
        year_of_receipt_YY = (
            int(re.match(GROUP_NAME_PATTERN, group_name).group(3)) % 100
        )
        course = year_current_YY - year_of_receipt_YY
        if course == 0:
            course = 1
        group_name = f"{course}{group_name}"
    
    page = requests.get(SCHEDULE_URL)
    tables = BeautifulSoup(page.content, "html.parser").find_all("table")

    days = {}

    for table in tables:
        # day name is separated from table by 1 \n
        day_name = table.previous_element.previous_element.capitalize()
        rows = table.find_all("tr")
        group_found = False
        lesson_rows = []

        # searching for group row, fill lessons until next group name
        for row in rows:
            row_text = clear_str(row.text)
            if re.match(GROUP_NAME_PATTERN, row_text):
                if row_text == group_name:
                    group_found = True
                    continue
                elif not group_found:
                    continue
                else:
                    break
            if group_found:
                lesson_rows.append(row)

        lessons: List[Lesson] = []

        # prettify lessons
        for i, lesson in enumerate(lesson_rows):
            cells = [cell for cell in lesson.find_all("td") if cell.text.strip() != ""]
            teacher = cells[0].text if len(cells) > 0 else ""
            discipline = cells[1].text if len(cells) > 1 else "Нет"
            pair_num = cells[2].text if len(cells) > 2 else ""
            place = cells[3].text if len(cells) > 3 else ""
            lessons.append(Lesson(teacher, discipline, pair_num, place))
        days[day_name] = lessons
    return days


def save_schedule(out_dir: str, days: Dict[str, Lesson]):
    with open(
        os.path.join(out_dir, OUTPUT_FILE_NAME), "w", encoding="utf-8"
    ) as out_file:
        for day, lessons in days.items():
            out_file.write(day + ":\n")
            for l in lessons:
                out_file.write(str(l) + "\n")


if __name__ == "__main__":
    work_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
    if len(sys.argv) < 2:
        print("NNTC schedule scraper v1.0 by @f1uctus")
        group_name = input("Please enter your group name: ")
    else:
        group_name = sys.argv[1]

    days = request_schedule(group_name)
    save_schedule(work_dir, days)

