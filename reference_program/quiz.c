#include <stdio.h>

int getValidMarks(int quizNumber)
{
    int marks;

    do
    {
        printf("Enter marks of Quiz %d (0 - 10): ", quizNumber);
        scanf("%d", &marks);

        if (marks < 0 || marks > 10)
        {
            printf("Invalid input! Marks must be between 0 and 10.\n");
        }

    } while (marks < 0 || marks > 10);

    return marks;
}

int main()
{
    char studentName[50];

    int quiz1, quiz2, quiz3, quiz4;
    int total;

    float average, percentage;

    char grade;

    printf("===== Quiz Score Calculation System =====\n\n");

    printf("Enter Student Name: ");
    scanf("%s", studentName);

    quiz1 = getValidMarks(1);
    quiz2 = getValidMarks(2);
    quiz3 = getValidMarks(3);
    quiz4 = getValidMarks(4);

    total = quiz1 + quiz2 + quiz3 + quiz4;

    average = total / 4.0;

    percentage = (total / 40.0) * 100;

    if (percentage >= 90)
    {
        grade = 'A';
    }
    else if (percentage >= 80)
    {
        grade = 'B';
    }
    else if (percentage >= 70)
    {
        grade = 'C';
    }
    else if (percentage >= 60)
    {
        grade = 'D';
    }
    else
    {
        grade = 'F';
    }

    printf("\n===== Student Result =====\n");

    printf("Student Name : %s\n", studentName);
    printf("Total Marks  : %d / 40\n", total);
    printf("Average      : %.2f\n", average);
    printf("Percentage   : %.2f%%\n", percentage);
    printf("Grade        : %c\n", grade);

    return 0;
}

