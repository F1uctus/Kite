[Variables]
    ; skin scale
    s=1
    bgcolor=30,30,30,200
    accentcolor=255,152,0
    highlightcolor=200,200,200,50
    fontf=Roboto

; #################### GLOBAL STYLES

[Appearance]
    StringCase=Upper
    StringStyle=Normal
    StringEffect=None
    FontFace=#fontf#
    FontSize=(#s# * 11)
    FontColor=EEEEEE
    AntiAlias=1

[BackgroundStyle]
    Shape=Rectangle 0,0,#skinw#,#skinh# | Extend Opt
    Opt=Fill Color #bgcolor# | StrokeWidth 0 
    AntiAlias=1
    UpdateDivider=-1
