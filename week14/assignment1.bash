#! /bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst(){

echo -n "Please Input an Instructor Full Name: "
read instName

echo ""
echo "Courses of $instName :"
cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | \
sed 's/;/ | /g'
echo ""

}

function courseCountofInsts(){

echo ""
echo "Course-Instructor Distribution"
cat "$courseFile" | cut -d';' -f7 | \
grep -v "/" | grep -v "\.\.\." | \
sort -n | uniq -c | sort -n -r 
echo ""

}

# TODO - 1
# Make a function that displays all the courses in given location
# function dislaplays course code, course name, course days, time, instructor
# Add function to the menu
# Example input: JOYC 310
# Example output: See the screenshots in canvas
function displayCoursesofClassroom(){

    echo -n "Please Input a Class Name: "
    read className
    echo ""
    echo "Courses in $className :"

    grep ";$className;" "$courseFile" | cut -d';' -f1,2,5,6,7 | \
    sed 's/;/ | /g'
    echo ""
}
# TODO - 2
# Make a function that displays all the courses that has availability
# (seat number will be more than 0) for the given course code
# Add function to the menu
# Example input: SEC
# Example output: See the screenshots in canvas
function displayAvailableCoursesofSubject(){

    echo -n "Please Input a Subject Name: "
    read subjectName
    echo ""
    echo "Available courses in $subjectName :"

    # subject is at the start of field 1, seats are field 4 (>0)
    awk -F';' -v subj="$subjectName" '
        $1 ~ "^"subj && $4+0 > 0 { print $0 }
    ' "$courseFile" | sed 's/;/ | /g'
    echo ""
}

while :
do
	echo ""
	echo "Please select and option:"
	echo "[1] Display courses of an instructor"
	echo "[2] Display course count of instructors"
	echo "[3] Display courses of a classroom"
	echo "[4] Display available courses of a subject"
	echo "[5] Exit"

	read userInput
	echo ""

	if [[ "$userInput" == "5" ]]; then
		echo "Goodbye"
		break

	elif [[ "$userInput" == "1" ]]; then
		displayCoursesofInst

	elif [[ "$userInput" == "2" ]]; then
		courseCountofInsts
	elif [[ "$userInput" == "3" ]]; then
		displayCoursesofClassroom
	elif [[ "$userInput" == "4" ]]; then
		displayAvailableCoursesofSubject

	# TODO - 3 Display a message, if an invalid input is given
        else
            echo "Invalid option. Please choose 1, 2, 3, 4, or 5."
        fi
done
