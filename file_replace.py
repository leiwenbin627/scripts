#!-*-coding:utf-8-*-
import os
import win32com.client
import shutil

# 处理Word文档的类
class RemoteWord:
    def __init__(self, filename=None):
        self.xlApp = win32com.client.DispatchEx('Word.Application')
        self.xlApp.Visible = 0
        self.xlApp.DisplayAlerts = 0  # 后台运行，不显示，不警告
        if filename:
            self.filename = filename
            if os.path.exists(self.filename):
                self.doc = self.xlApp.Documents.Open(filename)
            else:
                self.doc = self.xlApp.Documents.Add()  # 创建新的文档
                self.doc.SaveAs(filename)
        else:
            self.doc = self.xlApp.Documents.Add()
            self.filename = ''
    def replace_doc(self, string, new_string):
        '''替换文字'''
        self.xlApp.Selection.Find.ClearFormatting()
        self.xlApp.Selection.Find.Replacement.ClearFormatting()
        self.xlApp.Selection.Find.Execute(string, False, False, False, False, False, True, 1, True, new_string, 2)
    def save(self):
        '''保存文档'''
        self.doc.Save()
    def close(self):
        '''保存文件、关闭文件'''
        self.save()
        self.xlApp.Documents.Close()
        self.xlApp.Quit()
if __name__ == '__main__':

    file_dir =r'D:\\TB\\' #修改需要处理的目录

    list_dir = os.listdir(file_dir)
    for file_name in list_dir:
        new_file_name = str(file_name).replace("02-BM", "YXB")
        shutil.move(file_dir+file_name,file_dir+new_file_name)#替换文件名
        doc = RemoteWord(file_dir+new_file_name)#实例化一个文件对象
        doc.replace_doc('02-BM', 'YXB')  # 替换文本内容
        doc.save()
        doc.close()