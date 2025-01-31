#!/bin/bash


infinite_loop() {
  while true; do
    let a=2*3
  done
}


infinite_loop &
pid1=$!
echo "Первый процесс запущен с PID: $pid1"

infinite_loop &
pid2=$!
echo "Второй процесс запущен с PID: $pid2"

infinite_loop &
pid3=$!
echo "Третий процесс запущен с PID: $pid3"


sleep 1


cpulimit -p $pid1 -l 10 &

echo "Ограничение CPU для процесса $pid1 установлено на 10%"


sleep 5


kill $pid3
echo "Третий процесс с PID $pid3 завершен"


echo "Вы можете запустить 'top' в другом терминале для проверки использования CPU первым процессом."
