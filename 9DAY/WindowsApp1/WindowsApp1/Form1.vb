Imports System.Data  ' 데이터베이스 연동을 위한 네임스페이스 추가
Imports System.Data.SqlClient  ' SQL Server용 네임스페이스 추가

Public Class Form1
    Public curNum As Integer  ' 현재 커서 번호 전역변수
    Public dv As DataView  ' 데이터 뷰 전역변수
    Public dr As DataRow  ' 데이터 행 전역변수

    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load

        ' SQL Server에 접속하는 연결스트링 (DB는 sqlDB, 사용자는 vsUser, 비밀번호는 1234)
        Dim Conn As String = "Server=localhost;DataBase=sqlDB;user=vsUser;password=1234"
        Dim sqlCon As New SqlConnection(Conn)
        Dim user_Data = New DataSet()
        sqlCon.Open()

        '  userTbl의 아이디,이름,가입일 조회
        Dim strSQL As New SqlCommand("SELECT userID,name,mDate from userTbl", sqlCon)
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        da.SelectCommand = strSQL
        da.Fill(user_Data, "userTbl")

        dv = New DataView(user_Data.Tables("userTbl"))

        curNum = 0 ' 현재 행은 가장 첫행(0)을 가리킴

        dr = dv.Item(0).Row
        tb_userID.Text = dr.Item("userID") ' 아이디를 첫 번째 텍스트상자에 입력
        tb_name.Text = dr.Item("name")  ' 이름을 두 번째 텍스트상자에 입력
        tb_mDate.Text = dr.Item("mDate") ' 가입일을 세 번째 텍스트상자에 입력

        da.Dispose()
        sqlCon.Close()
    End Sub
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        If curNum = 0 Then  ' 첫 행이면 <이전>버튼을 눌러도 작동 안 하도록 함.
            MsgBox("이미 처음 행입니다")
            Exit Sub
        End If
        curNum = curNum - 1 ' 행 번호를 하나 앞으로

        dr = dv.Item(curNum).Row
        tb_userID.Text = dr.Item("userID")
        tb_name.Text = dr.Item("name")
        tb_mDate.Text = dr.Item("mDate")
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        If curNum + 1 = dv.Count Then  ' 마지막 행이면 <다음>버튼을 눌러도 작동 안 하도록 함.
            MsgBox("마지막 끝 행입니다")
            Exit Sub
        End If
        curNum = curNum + 1 ' 행 번호를 하나 다음으로

        dr = dv.Item(curNum).Row
        tb_userID.Text = dr.Item("userID")
        tb_name.Text = dr.Item("name")
        tb_mDate.Text = dr.Item("mDate")
    End Sub

End Class

