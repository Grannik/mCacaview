#!/bin/bash
 E='echo -e';
 e='echo -en';
#
 i=0; CLEAR; CIVIS;NULL=/dev/null
 trap "R;exit" 2
 ESC=$( $e "\e")
 TPUT(){ $e "\e[${1};${2}H" ;}
 CLEAR(){ $e "\ec";}
 CIVIS(){ $e "\e[?25l";}
 R(){ CLEAR ;stty sane;CLEAR;};                 # в этом варианте фон прозрачный
#
 ARROW(){ IFS= read -s -n1 key 2>/dev/null >&2
           if [[ $key = $ESC ]];then
              read -s -n1 key 2>/dev/null >&2;
              if [[ $key = \[ ]]; then
                 read -s -n1 key 2>/dev/null >&2;
                 if [[ $key = A ]]; then echo up;fi
                 if [[ $key = B ]];then echo dn;fi
              fi
           fi
           if [[ "$key" == "$($e \\x0A)" ]];then echo enter;fi;}
 UNMARK(){ $e "\e[0m";}
 MARK(){ $e "\e[30;47m";}
#
 HEAD()
{
 for (( a=2; a<=31; a++ ))
          do
TPUT $a 1;$E "\e[47;30m│\e[0m                                                                                \e[47;30m│\e[0m"
          done
TPUT  1 1;$E "\033[0m\033[47;30m┌────────────────────────────────────────────────────────────────────────────────┐\033[0m"
TPUT  3 3;$E "\e[1;36m*** cacaview ***\e[0m";
TPUT  4 3;$E "\e[2m ASCII image browser\e[0m";
TPUT  5 1;$E "\e[47;30m├\e[0m\e[1;30m────────────────────────────────────────────────────────────────────────────────\e[0m\e[47;30m┤\e[0m";
TPUT  6 3;$E "\e[32m INSTALL \e[0m Установка                             \e[32m sudo apt install caca-utils\e[0m";
TPUT  7 3;$E "\e[32m SYNOPSIS\e[0m Kраткий обзор                                  \e[32m cacaview [FILE...]\e[0m";
TPUT  8 3;$E "\e[32m SEE ALSO\e[0m Смотри так же                                             \e[32m img2txt\e[0m";
TPUT  9 3;$E "\e[32m EXAMPLE \e[0m Пример                            \e[32m cacaview /usr/share/pixmaps/*.*\e[0m";
TPUT 10 3;$E "\e[32m AUTHOR  \e[0m Автор. Эта страница руководства была написана:";
TPUT 11 3;$E "          Sam Hocevar \e[36msam@hocevar.net\e[0m";
TPUT 12 1;$E "\e[47;30m├\e[0m\e[1;30m────────────────────────────────────────────────────────────────────────────────\e[0m\e[47;30m┤\e[0m";
TPUT 13 3;$E "\e[2m Ключи\e[0m                                                                 \e[36m KEYS\e[0m";
TPUT 14 3;$E "\e[32m ?\e[0m                                                    Показать экран справки";
TPUT 15 3;$E "\e[32m n, p\e[0m              Перейти к следующему изображению, предыдущему изображению";
TPUT 16 3;$E "\e[32m Left, Right, Up, Down or h, l, k, j\e[0m           Прокрутите изображение вокруг";
TPUT 17 3;$E "\e[32m +, -\e[0m                                       Увеличение и уменьшение масштаба";
TPUT 18 3;$E "\e[32m z\e[0m                           Сбросить уровень масштабирования до нормального";
TPUT 19 3;$E "\e[32m f\e[0m Переключить полноэкранный режим (скрыть/показать меню и строки состояния)";
TPUT 20 3;$E "\e[32m d\e[0m Переключение режима сглаживания";
TPUT 21 3;$E "   (без сглаживания, упорядоченное сглаживание 4x4,";
TPUT 22 3;$E "   упорядоченное сглаживание 8x8 и случайное сглаживание)";
TPUT 23 3;$E "\e[32m q\e[0m                                                          Exit the program";
TPUT 24 1;$E "\e[47;30m├\e[0m\e[1;30m────────────────────────────────────────────────────────────────────────────────\e[0m\e[47;30m┤\e[0m"
TPUT 27 1;$E "\e[47;30m├\e[0m\e[1;30m────────────────────────────────────────────────────────────────────────────────\e[0m\e[47;30m┤\e[0m"
TPUT 29 1;$E "\e[47;30m├\e[0m\e[2m─ Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter ─────────────────────────────────────────────────────\e[0m\e[47;30m┤\e[0m"
}
FOOT(){ MARK;TPUT 32 1;$E "\033[0m\033[47;30m└────────────────────────────────────────────────────────────────────────────────┘\033[0m";UNMARK;}
  M0(){ TPUT 25 3; $e " Описание                                                       \e[32m DESCRIPTION \e[0m";}
  M1(){ TPUT 26 3; $e " Ошибки                                                                \e[32m BUGS \e[0m";}
  M2(){ TPUT 28 3; $e " Grannik Git                                                                 ";}
  M3(){ TPUT 30 3; $e " Exit                                                                        ";}
LM=3
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
# Функция возвращения в меню
     ES(){ MARK;$e " ENTER = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
 0) S=M0;SC; if [[ $cur == enter ]];then R;echo -e "
 cacaview — это легкая программа для просмотра изображений в текстовом режиме.
 Он отображает изображения с использованием цветных символов ASCII.
 Это мощное дополнение к известным консольным программам, таким как почтовый клиент
 mutt, программа чтения новостей slrn и веб-браузеры Links или W3M. cacaview может
 загружать наиболее распространенные форматы изображений:\e[32m
 PNG, JPEG, GIF, PNG, BMP\e[0m и т. д.
 Вы можете масштабировать и прокручивать изображение для получения более подробной
 информации, а также выбирать четыре различных режима дизеринга.
 Все команды доступны через одно нажатие клавиши.
";ES;fi;;
 1) S=M1;SC; if [[ $cur == enter ]];then R;echo -e "
 Пока нет поддержки соотношения сторон.
 Кроме того, поскольку пока нет способа загрузить изображение из cacaview,
 он совершенно бесполезен при запуске без аргумента.
";ES;fi;;
 2) S=M2;SC;if [[ $cur == enter ]];then R;echo -e "
 Mo 12 Jun 2023
 mCacaview Описание утилиты cacaview. ASCII image browser.
 Asciinema:  \e[36m https://asciinema.org/a/591037\e[0m
 Codeberg:   \e[36m https://codeberg.org/Grannik/mCacaview\e[0m
 Github:     \e[36m \e[0m
 Gitlab:     \e[36m \e[0m
 Sourceforge:\e[36m \e[0m
 Notabug:    \e[36m \e[0m
 Bitbucket:  \e[36m \e[0m
 Framagit:   \e[36m \e[0m
 GFogs:      \e[36m \e[0m
 Gitea       \e[36m \e[0m
 File:
 Archive:    \e[36m \e[0m
 Bastyon:\e[36m \e[0m
";ES;fi;;
 3) S=M3;SC;if [[ $cur == enter ]];then R;clear;ls -l;exit 0;fi;;
 esac;POS;done
