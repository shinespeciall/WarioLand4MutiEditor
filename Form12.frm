VERSION 5.00
Begin VB.Form Form12 
   Caption         =   "Model Maker"
   ClientHeight    =   8760
   ClientLeft      =   5760
   ClientTop       =   3660
   ClientWidth     =   10740
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form12"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8760
   ScaleWidth      =   10740
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton Command4 
      Caption         =   "Next"
      Height          =   375
      Left            =   2160
      TabIndex        =   7
      Top             =   8160
      Width           =   1695
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Last"
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   8160
      Width           =   1695
   End
   Begin VB.PictureBox Picture2 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      Height          =   4575
      Left            =   4200
      ScaleHeight     =   4515
      ScaleWidth      =   6315
      TabIndex        =   5
      ToolTipText     =   "Use Arrow Keys to move MOD to change position"
      Top             =   1680
      Width           =   6375
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Cancel"
      Height          =   615
      Left            =   9120
      TabIndex        =   4
      Top             =   7800
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Done"
      Height          =   615
      Left            =   7200
      TabIndex        =   3
      Top             =   7800
      Width           =   1335
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   4200
      TabIndex        =   2
      Top             =   960
      Width           =   6375
   End
   Begin VB.PictureBox Picture1 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      Height          =   7095
      Left            =   120
      ScaleHeight     =   7035
      ScaleWidth      =   3675
      TabIndex        =   0
      ToolTipText     =   "Click and choose"
      Top             =   720
      Width           =   3735
      Begin VB.Shape Shape1 
         BorderColor     =   &H000000FF&
         BorderWidth     =   2
         Height          =   384
         Left            =   960
         Top             =   2400
         Visible         =   0   'False
         Width           =   384
      End
   End
   Begin VB.Label Label3 
      Caption         =   "Page: 0"
      Height          =   375
      Left            =   4080
      TabIndex        =   9
      Top             =   8160
      Width           =   1695
   End
   Begin VB.Label Label2 
      Caption         =   "Tiles"
      Height          =   375
      Left            =   240
      TabIndex        =   8
      Top             =   240
      Width           =   2895
   End
   Begin VB.Label Label1 
      Caption         =   "Nmae It ! (The App will number the MOD Automatically)"
      Height          =   375
      Left            =   4200
      TabIndex        =   1
      Top             =   360
      Width           =   6375
   End
End
Attribute VB_Name = "Form12"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public TilePage As Integer
Public IX As Integer
Public JY As Integer
Public NowTile As String

Public IX2 As Integer
Public JY2 As Integer

Private Sub Command1_Click()
Dim xmax As Integer, ymax As Integer, xmin As Integer, ymin As Integer
Dim tmpstr As String
Dim i As Integer, j As Integer

For j = 0 To 15
For i = 0 To 10
If MODforSave(i, j) <> "0000" Then
If i > xmax Then xmax = i
If j > ymax Then ymax = j
End If
Next i
Next j

xmin = xmax
ymin = ymax

For j = 0 To 15
For i = 0 To 10
If MODforSave(i, j) <> "0000" Then
If i < xmin Then xmin = i
If j < ymin Then ymin = j
Exit For
End If
Next i
Next j

tmpstr = Right("00" & Hex(xmax - xmin + 1), 2) & Right("00" & Hex(ymax - ymin + 1), 2)
For j = ymin To ymax
For i = xmin To xmax
tmpstr = tmpstr & MODforSave(i, j)
Next i
Next j

For i = 0 To 500
If TileMOD(0, i) = "" Then Exit For
Next i

TileMOD(0, i) = Right("000" & CStr(i - 3), 3) & " " & Form12.Text1.Text
TileMOD(1, i) = tmpstr

Open MODfilepath For Append As #3
Print #3, ""
Print #3, TileMOD(0, i)
Print #3, TileMOD(1, i);
Close #3

Form12.Picture2.Cls
Erase MODforSave()
Form12.Visible = False
Form10.Combo1.AddItem TileMOD(0, i)
Form10.Enabled = True
Form10.SetFocus
End Sub

Private Sub Command2_Click()
Form12.Picture2.Cls
Erase MODforSave()
Form12.Visible = False
Form10.Enabled = True
Form10.SetFocus
End Sub

Private Sub Command3_Click()
Form12.Picture1.Cls
NowTile = ""
Form12.Shape1.Visible = False
TilePage = TilePage - 1
Dim a As Boolean, i As Integer, j As Integer
For j = 0 To 15
For i = 0 To 7
a = DrawTile16(i, j, Hex(128 * TilePage + i + 8 * j), Form12.Picture1, , 24)
DoEvents
Next i
Next j
If TilePage = 0 Then
Form12.Command3.Enabled = False
Else
Form12.Command3.Enabled = True
End If
Form12.Command4.Enabled = True
Form12.Label3.Caption = "Page: " & TilePage
End Sub

Private Sub Command4_Click()
Form12.Picture1.Cls
NowTile = ""
Form12.Shape1.Visible = False
TilePage = TilePage + 1
Dim a As Boolean, i As Integer, j As Integer
For j = 0 To 15
For i = 0 To 7
a = DrawTile16(i, j, Hex(128 * TilePage + i + 8 * j), Form12.Picture1, , 24)
DoEvents
Next i
Next j
If TilePage = 6 Then
Form12.Command4.Enabled = False
Else
Form12.Command4.Enabled = True
End If
Form12.Command3.Enabled = True
Form12.Label3.Caption = "Page: " & TilePage
End Sub

Private Sub Form_Activate()                   ' start when activate
If TilePage > 0 Then TilePage = 0
Form12.Label3.Caption = "Page: " & TilePage
Form12.Label1.FontSize = 12
Form12.Label2.FontSize = 12
Form12.Label3.FontSize = 12
Form12.Text1.FontSize = 12
Form12.Picture1.BackColor = &H0&
Form12.Command3.Enabled = False

Form12.height = 9345
Form12.width = 10980
Form12.Icon = LoadResPicture(101, vbResIcon)
Form12.Top = MDIForm1.height / 2 - Form12.height / 2 - 500
Form12.Left = MDIForm1.width / 2 - Form12.width / 2 - 1000

Dim i As Integer, j As Integer
For j = 0 To 15
For i = 0 To 7
DrawTile16 i, j, Hex(i + 8 * j), Form12.Picture1, , 24
DoEvents
Next i
Next j

For j = 0 To 16
For i = 0 To 11
DrawTile16 i, j, MODforSave(i, j), Form12.Picture2, , 24
DoEvents
Next i
Next j
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
Dim i As Integer, j As Integer

If KeyCode = 37 Then 'Left
For j = 0 To 16
For i = 0 To 10
MODforSave(i, j) = MODforSave(i + 1, j)
Next i
MODforSave(11, j) = "0000"
Next j

ElseIf KeyCode = 39 Then 'Right
For j = 0 To 16
For i = 10 To 0 Step -1
MODforSave(i + 1, j) = MODforSave(i, j)
Next i
MODforSave(0, j) = "0000"
Next j

ElseIf KeyCode = 38 Then 'Up
For i = 0 To 11
For j = 0 To 15
MODforSave(i, j) = MODforSave(i, j + 1)
Next j
MODforSave(i, 16) = "0000"
Next i

ElseIf KeyCode = 40 Then 'Down
For i = 0 To 11
For j = 15 To 0 Step -1
MODforSave(i, j + 1) = MODforSave(i, j)
Next j
MODforSave(i, 0) = "0000"
Next i
End If

If KeyCode = 37 Or KeyCode = 38 Or KeyCode = 39 Or KeyCode = 40 Then
Form12.Picture2.Cls
For j = 0 To 16
For i = 0 To 11
DrawTile16 i, j, MODforSave(i, j), Form12.Picture2, , 24
Next i
Next j
End If

End Sub

Private Sub Form_Unload(Cancel As Integer)
Command2_Click
End Sub

Private Sub Picture1_Click()
If IX < 8 And JY < 16 Then
NowTile = Right("000" & Hex(CLng(128 * TilePage + IX + 8 * JY)), 4)
Form12.Shape1.Visible = True
Form12.Shape1.Left = IX * 384
Form12.Shape1.Top = JY * 384
End If
End Sub

Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
IX = X \ 384
JY = Y \ 384
End Sub

Private Sub Picture2_Click()
If IX2 < 11 And JY2 < 16 Then
MODforSave(IX2, JY2) = NowTile
DrawTile16 IX2, JY2, NowTile, Form12.Picture2, True, 24
End If
End Sub

Private Sub Picture2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
IX2 = X \ 384
JY2 = Y \ 384
End Sub

Private Sub Text1_Click()
Form12.KeyPreview = False
End Sub

Private Sub Text1_GotFocus()
Form12.KeyPreview = False
End Sub

Private Sub Text1_LostFocus()
Form12.KeyPreview = True
End Sub
