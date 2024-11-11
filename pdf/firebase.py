
import firebase_admin
from firebase_admin import credentials, firestore, auth
from reportlab.lib.pagesizes import letter, A4
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfbase import pdfmetrics
import datetime
import json

class FirebaseFirestore:

    def __init__ (self, socketIO):
        if(not firebase_admin._apps):
            cred = credentials.Certificate("serviceAccount.json")
            firebase_admin.initialize_app(cred)
        self.db = firestore.client()
        self.socketIO = socketIO
        self.listenToFirebase()

    def listenToFirebase(self):
        collection_ref = self.db.collection('Volunteer')
        listener = collection_ref.on_snapshot(self.collection_listener)
        
    def collection_listener(self, doc_snapshot, changes, read_time):
        doc_lst = []
        for doc in doc_snapshot:
            doc_lst.append(json.dumps(doc.to_dict(), indent=4, sort_keys=True, default=str))
        self.socketIO.emit("update", doc_lst)

    def create_user_with_email_and_password(self, email, password):
        try:
            user = auth.create_user(
                email=email,
                password=password
            )
            print('Successfully created new user:', user.uid)
            return user
        except Exception as e:
            print('Error creating new user:', e)
            return None
        
    def generate_pdf(self, docId: str) -> None:
        doc_ref = self.db.collection('Volunteer').document(docId)
        doc = doc_ref.get()
        user_list = []
        if (doc.exists):
            data = doc.to_dict()
            for uid in data["Completed"]:
                user_info =  self.get_user(uid)        
                if(user_info == None):
                    user_list.append({
                        "username": "Deleted User",
                        "chineseName": "Deleted User",
                        "studentNumber": "Deleted User",
                        "email": "Deleted User",
                    })
                    print("user doesn't exist")
                    continue
                else:
                    user_list.append(user_info)
            self.create_pdf(data, user_list, docId)
        else:
            print("No such document1")
        

    def get_user(self, uid: str):
        print(uid)
        doc_ref = self.db.collection('SCIE-Students').document(uid)
        doc = doc_ref.get()
        if (doc.exists):
            return doc.to_dict()
        else:
            print("No such document")

    def create_pdf(self, volunteerInfo, user_list, docId):
        c = canvas.Canvas(f"{docId}_report.pdf", pagesize=A4)
        pdfmetrics.registerFont(TTFont('NotoSan', 'NotoSansSC-VariableFont_wght.ttf')) 
        
        width, height = A4
        styles = getSampleStyleSheet()

        col_widths1 = [80, 80, 100, 150, 120,]
        col_widths2 = [100, 100, 100, 50, 50, 80]
        col_widths3 = [100, 100, 100, 150, 50]


        # Set the title of the PDF document
        c.setTitle("Simple PDF Document")
        pStyle = ParagraphStyle(name="Address", fontName='NotoSan');
        # Add some text to the PDF
        c.drawString(100, height - 100, "Hello, this is a simple PDF document created with Python!")
        current = datetime.datetime.now()
        student_list = [
            [
                user["username"],
                Paragraph(user["chineseName"], pStyle),
                user["studentNumber"],
                user["email"],
                str(current)[:10],
            ] for user in user_list
        ]
        # Define data for the first table
        data1 = [
            ["English name", "Chinese name", "Student number", "Email", "Report generated time"],
        ] + student_list

        # Create the first Table object
        table1 = Table(data1,colWidths=col_widths1)

        # Add some style to the first table
        style1 = TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.grey),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.white),
            ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ])
        table1.setStyle(style1)

        # Move the origin up for the first table
        table1.wrapOn(c, width, height)
        table1.drawOn(c, 30, height - 200)
        
        # Define data for the second table
        data2 = [
            ["Date", "Activity", "Kind", "Count", "Cs hours", "Host club"],
            [
                str(volunteerInfo["Time"])[:10],
                Paragraph(volunteerInfo["EventName"], pStyle),
                Paragraph(str(volunteerInfo["Kind"]), pStyle),
                str(volunteerInfo["Count"]),
                str(volunteerInfo["CsHours"]),
                Paragraph(volunteerInfo["HostClub"], pStyle),
            ],
        ]

        # Create the second Table object
        table2 = Table(data2,colWidths=col_widths2)

        table2.setStyle(style1)

        # Move the origin up for the second table
        table2.wrapOn(c, width, height)
        table2.drawOn(c, 30, height - 350 - len(user_list) * 50)

        data3 = [
            ["Details", "Location", "Event officer", "Event officer's email", "Spots"],
            [
                Paragraph(volunteerInfo["Details"], pStyle),
                Paragraph(volunteerInfo["Location"], pStyle),
                Paragraph(volunteerInfo["EventOfficer"], pStyle),
                volunteerInfo["Email"],
                str(volunteerInfo["Spots"]),
            ]
        ]
        
        table3 = Table(data3,colWidths=col_widths3)
        table3.setStyle(style1)
        table3.wrapOn(c, width, height)
        table3.drawOn(c, 30, height - 550)

        # story = []
        # story.append(table1, table2)

        # Save the PDF file
        c.save()

# f = FirebaseFirestore()
# f.generate_pdf("v18DIMwofWebaqXgYnPx")