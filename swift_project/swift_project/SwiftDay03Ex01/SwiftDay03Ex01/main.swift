// 높다 낮다 게임
// 시스템이 1-100 난수발생
// 사용자가 정답을 입력해서 맞추는 프로그램
// 6번안에 맞추는 프로그램
// step 02
// 한 게임이 끝나면 재시도 여부 묻기
// 재시도하면 모든변수 초기화 프로그램 다시시작


// 사용자입력 문자 예상:숫자,문자,그외, min보다 작거나 또는 max보다 큰 수 입력
// 사용자입력의 유효성충족시 시스템넘버와 사용자 입력넘버 비교
// 시스템넘버와 사용자 입력넘버 비교 경우의수 = 1.사용자넘버가 시스템넘버보다 높은경우(1-100에서 사용자넘버보다 낮은 범위의 수를 범위로 설정하여 재질문 2, 사용자넘버가 시스템넘버보다 낮은경우(1-100에서 사용자넘버보다 높은 범위의 수를 범위로 설정하여 재질문) 3.사용자넘버가 시스템넘버와 같은경우:정답 4.조건3이 될때까지 1,2의 조건을 반복하며 틀렸다는 메시지나 정답이아니며 다시입력하라는 메세지와 6회이상 안된다는 조건에 근거해서 1번 싸이클이 돌때마다 남은시도횟수:6-n회 또는 n회 시도라는 표현으로 작성한다. 남은시도횟수 0이되거나 6회 시도횟수에 도달하면 게임이 종료되었다는 메시지를 프린트한다. 5.게임이 종료되면 재시도하겠는지를 묻는 (y/n) 선택하라는 사용자입력을 요구한다. (y/n)입력하는 사용자입력의 경우의 수를 구한후 사용자가 y또는 n을 대소문자 관계없이 적을 경우를 제외한 나머지 유효성을 검사한후 다시 y/n을 입력하라는 메시지를 프린트하면서 제대로된 (y/n)문자를 입력하지 않을 경우 다음 코드로 넘어가지 않도록 한다. 6.사용자입력 유효성검사에 통과하면 y의 경우 와 n의 경우로 나눠서 게임전체코드를 반복하도록하는 반복문을 사용한다. y의 경우 초기값만 변경가능하도록 하거나 전체코드를 다시 반복하게 한다. n의 경우 게임종료 및 수고하셨습니다. 다음에 다시 만나요 같은 사랑어린 석별인사를 한ㄷ
 


// 난수 발생기
// 낙타봉 표기법 myName<--> 뱀 표기법 my_name
import Foundation

var sysNum = int.random(int.min...max)
var min = 1
var max = 100
var count = 0

