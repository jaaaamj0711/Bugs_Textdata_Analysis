# Bugs 음악 스트리밍 사이트 분석
![image](https://user-images.githubusercontent.com/55734436/116523902-b7e97280-a911-11eb-8f5e-40e8ec32c6a9.png)

## 분석 목표

1.	노래 재생시간과 가사 길이의 상관성은 어떠한가
2.	시대에 따라 사용하는 단어의 변화는 어떠한가
3.	어떤 조합의 단어가 노래에서 같이 사용되는가

## 데이터 출처:
https://music.bugs.co.kr/

## 데이터 수집 방법: 
크롬 개발자 도구를 이용한 웹크롤링

## 분석 결과 요약 

### 1. 노래 재생시간과 가사 길이의 상관성은 어떠한가
![image](https://user-images.githubusercontent.com/55734436/116522180-dd757c80-a90f-11eb-80e9-baf6b3df006d.png)

### 2.시대에 따라 사용하는 단어의 변화는 어떠한가
![image](https://user-images.githubusercontent.com/55734436/116521297-c3876a00-a90e-11eb-9e70-037210829ed5.png)
![image](https://user-images.githubusercontent.com/55734436/116521263-b8ccd500-a90e-11eb-8f69-8037da336d5a.png)

- 1940년~1950년대의 노래 가사들을 보면 그 시대가 잘 반영되어 있음을 알 수 있다. 소쩍꿍, 닐리리, 고향 등의 단어를 보면 옛날 시대를 의미함을 알 수 있다.
- 1970년대로 갈수록 조금씩 현대에 맞는 단어들이 등장하고 있다.

<img src="https://user-images.githubusercontent.com/55734436/116521819-69d36f80-a90f-11eb-96d8-25484cc988b1.png" width="600" height="400">

- 2000년대에 접어들면서 노래 가사에 영어가 등장하기 시작했다. 

**종합적으로 사랑이라는 단어는 늘 많이 존재한다. 모든 시대에 사랑을 표현한 노래들이 많이 나왔음을 짐작해볼 수 있다.**

### 3. 어떤 조합의 단어가 노래에서 같이 사용되는가

#### Top 1-30
<img src="https://user-images.githubusercontent.com/55734436/116522590-51b02000-a910-11eb-96a8-3542adf0a4a1.png" width="600" height="400">

- 널, 날이라는 단어와 사랑이라는 단어의 조합으로 구성된 노래 가사들이 많았다.

#### Top 31-60
<img src="https://user-images.githubusercontent.com/55734436/116522895-a0f65080-a910-11eb-8021-bd7334da3311.png" width="600" height="400">

- 하늘, 바람, 빛, 행복등의 단어의 조합으로 구성된 노래 가사들이 많았다.

#### [최종 PPT](https://github.com/jaaaamj0711/Bugs_Textdata_Analysis/blob/main/%E1%84%8B%E1%85%B3%E1%86%B7%E1%84%8B%E1%85%A1%E1%86%A8%20%E1%84%8E%E1%85%A1%E1%84%90%E1%85%B3%20%E1%84%83%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%90%E1%85%A5%20%E1%84%87%E1%85%AE%E1%86%AB%E1%84%89%E1%85%A5%E1%86%A8%20(1).pdf)

