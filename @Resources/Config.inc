[Variables]
    ; skin scale
    s=1

    osu-username=F1uctus

    ; https://openweathermap.org/
    city-id=520555
    ; metric/imperial
    units="metric"
    
    ; translation variables
    ;= English/Russian
    lang=English
    ;= en/ru
    lang-code=en
    
    ;= dark/light
    theme=light
    
    ; colors corresponding to each theme
    dark-color-bg=36,36,36
    dark-color-font=230,230,230

    light-color-bg=255,255,255
    light-color-font=50,50,50

    color-bg=#[#theme]-color-bg#
    color-font=#[#theme]-color-font#  

    color-highlight=#color-font#
    color-accent=867540

    opacity-highlight=50
    opacity-bg=200

    font-face=Google Sans
    font-face-accent=Google Sans Bold
    
    font-size-regular=(#s# * 12)
    font-size-title=(#s# * 18)
    font-size-accent=(#s# * 42)

    margin-x=(#s# * 15)
    margin-y=(#s# * 15)

    corner-radius=(#s# * 5)

; Global styles

[RegularStringStyle]
    StringStyle=Normal
    StringEffect=None
    FontFace=#font-face#
    FontSize=#font-size-regular#
    FontColor=#color-font#
    ClipString=2
    ClipStringW=#skinw#
    AntiAlias=1

[TitleStringStyle]
    StringStyle=Normal
    StringEffect=None
    FontFace=#font-face-accent#
    FontSize=#font-size-title#
    FontColor=#color-font#
    X=#margin-x#
    Y=#margin-y#
    Text=#title#
    ClipString=2
    ClipStringW=#skinw#
    InlineSetting=Color | #color-accent#
    InlinePattern=\p{Lu}
    AntiAlias=1

[BackgroundStyle]
    Shape=Rectangle 0, 0, #skinw#, #skinh# | Fill Color #color-bg#,#opacity-bg# | StrokeWidth 0 
    AntiAlias=1
    UpdateDivider=-1
