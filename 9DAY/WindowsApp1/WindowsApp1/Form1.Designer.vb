<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form은 Dispose를 재정의하여 구성 요소 목록을 정리합니다.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Windows Form 디자이너에 필요합니다.
    Private components As System.ComponentModel.IContainer

    '참고: 다음 프로시저는 Windows Form 디자이너에 필요합니다.
    '수정하려면 Windows Form 디자이너를 사용하십시오.  
    '코드 편집기에서는 수정하지 마세요.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.Button1 = New System.Windows.Forms.Button()
        Me.Button2 = New System.Windows.Forms.Button()
        Me.tb_userID = New System.Windows.Forms.TextBox()
        Me.tb_name = New System.Windows.Forms.TextBox()
        Me.tb_mDate = New System.Windows.Forms.TextBox()
        Me.SuspendLayout()
        '
        'Button1
        '
        Me.Button1.Location = New System.Drawing.Point(162, 165)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(75, 23)
        Me.Button1.TabIndex = 0
        Me.Button1.Text = "<< 이전"
        Me.Button1.UseVisualStyleBackColor = True
        '
        'Button2
        '
        Me.Button2.Location = New System.Drawing.Point(387, 165)
        Me.Button2.Name = "Button2"
        Me.Button2.Size = New System.Drawing.Size(75, 23)
        Me.Button2.TabIndex = 1
        Me.Button2.Text = "다음 >>"
        Me.Button2.UseVisualStyleBackColor = True
        '
        'tb_userID
        '
        Me.tb_userID.Location = New System.Drawing.Point(67, 66)
        Me.tb_userID.Name = "tb_userID"
        Me.tb_userID.Size = New System.Drawing.Size(100, 21)
        Me.tb_userID.TabIndex = 2
        '
        'tb_name
        '
        Me.tb_name.Location = New System.Drawing.Point(270, 66)
        Me.tb_name.Name = "tb_name"
        Me.tb_name.Size = New System.Drawing.Size(100, 21)
        Me.tb_name.TabIndex = 3
        '
        'tb_mDate
        '
        Me.tb_mDate.Location = New System.Drawing.Point(467, 66)
        Me.tb_mDate.Name = "tb_mDate"
        Me.tb_mDate.Size = New System.Drawing.Size(100, 21)
        Me.tb_mDate.TabIndex = 4
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(7.0!, 12.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(641, 222)
        Me.Controls.Add(Me.tb_mDate)
        Me.Controls.Add(Me.tb_name)
        Me.Controls.Add(Me.tb_userID)
        Me.Controls.Add(Me.Button2)
        Me.Controls.Add(Me.Button1)
        Me.Name = "Form1"
        Me.Text = "Form1"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents Button1 As Button
    Friend WithEvents Button2 As Button
    Friend WithEvents tb_userID As TextBox
    Friend WithEvents tb_name As TextBox
    Friend WithEvents tb_mDate As TextBox
End Class
