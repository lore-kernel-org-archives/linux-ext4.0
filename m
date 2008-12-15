From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Sun, 14 Dec 2008 17:25:54 -0800 (PST)
Message-ID: <20081215012554.EC9E210800F@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbYLOB01 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2008 20:26:27 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBF1PtSS026843
	for <linux-ext4@vger.kernel.org>; Sun, 14 Dec 2008 17:25:56 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D12224





------- Comment #4 from csights@fastmail.fm  2008-12-14 17:25 -------
http://bugzilla.kernel.org/show_bug.cgi?id=3D12224

> I think I've seen other reports of this. =A0Maybe it was you.

Yes, that was me.  :)

> # sysctl -w vm.block_dump=3D1
>
> to see if you get any info about inodes on sda1 being dirtied.

        I waited until 20:02, then ran:

# sysctl -w vm.block_dump=3D1; btrace /dev/sda | logger -s

        and switched to a different terminal and ran in the linux kerne=
l
directory=20
(on hda1):

# make clean

        I waited until "btrace" indicated activity on sda1, then stoppe=
d the
"make=20
clean".  If you would like me let it run a few more seconds let me know=
=2E
        Below is the output from /var/log/syslog.  The btrace and block=
_dump
output=20
is interleaved.  Lines containing "logger" are from btrace.

Dec 14 20:02:11 localhost kernel: cc1(2825): dirtied inode 550552 (.282=
3.tmp)=20
on hda1
Dec 14 20:02:12 localhost kernel: cc1(2831): dirtied inode 550552 (.282=
9.tmp)=20
on hda1
Dec 14 20:02:12 localhost kernel: cc1(2831): dirtied inode 550552 (.282=
9.tmp)=20
on hda1
Dec 14 20:02:12 localhost kernel: as(2851): dirtied inode 550552 (.2847=
=2Etmp)=20
on hda1
Dec 14 20:02:12 localhost kernel: as(2857): dirtied inode 550552 (.2853=
=2Etmp)=20
on hda1
Dec 14 20:02:13 localhost kernel: cc1(2861): dirtied inode 550552 (.285=
9.tmp)=20
on hda1
Dec 14 20:02:13 localhost kernel: cc1(2866): dirtied inode 550552 (.286=
4.tmp)=20
on hda1
Dec 14 20:02:14 localhost kernel: cc1(2870): dirtied inode 550552 (.286=
8.tmp)=20
on hda1
Dec 14 20:02:14 localhost kernel: cc1(2874): dirtied inode 667799 (cc7U=
OalO.s)=20
on hda1
Dec 14 20:02:15 localhost kernel: as(2875): dirtied inode 667800 (cco6Z=
96S.o)=20
on hda1
Dec 14 20:02:15 localhost kernel: collect2(2876): dirtied inode 678207=20
(ccDA8hIA.ld) on hda1
Dec 14 20:02:15 localhost kernel: collect2(2876): dirtied inode 678208=20
(cc8CSPAJ.le) on hda1
Dec 14 20:02:15 localhost kernel: ld(2877): dirtied inode 550552 (.2872=
=2Etmp)=20
on hda1
Dec 14 20:02:15 localhost kernel: cc1(2889): dirtied inode 667799 (ccpO=
cjsE.s)=20
on hda1
Dec 14 20:02:15 localhost kernel: as(2890): dirtied inode 667800 (ccswK=
xcx.o)=20
on hda1
Dec 14 20:02:15 localhost kernel: collect2(2891): dirtied inode 678207=20
(ccUNFhhm.ld) on hda1
Dec 14 20:02:15 localhost kernel: collect2(2891): dirtied inode 678208=20
(ccmKXZiq.le) on hda1
Dec 14 20:02:16 localhost kernel: ld(2892): dirtied inode 550552 (.2887=
=2Etmp)=20
on hda1
Dec 14 20:02:16 localhost kernel: ld(2892): dirtied inode 550552 (.2887=
=2Etmp)=20
on hda1
Dec 14 20:02:16 localhost kernel: make(2898): READ block 10191456 on hd=
a1
Dec 14 20:02:16 localhost kernel: make(2898): READ block 10909096 on hd=
a1
Dec 14 20:02:16 localhost kernel: cc1(2901): dirtied inode 667799 (cc6h=
y8wW.s)=20
on hda1
Dec 14 20:02:17 localhost kernel: as(2902): dirtied inode 667800 (ccNZW=
ld0.o)=20
on hda1
Dec 14 20:02:17 localhost kernel: collect2(2903): dirtied inode 678207=20
(ccQ6Vp5L.ld) on hda1
Dec 14 20:02:17 localhost kernel: collect2(2903): dirtied inode 678208=20
(cc4aaKMY.le) on hda1
Dec 14 20:02:17 localhost kernel: ld(2904): dirtied inode 550552 (.2899=
=2Etmp)=20
on hda1
Dec 14 20:02:17 localhost kernel: cc1(2915): dirtied inode 667799 (ccvj=
O98E.s)=20
on hda1
Dec 14 20:02:17 localhost kernel: as(2916): dirtied inode 667800 (ccGHS=
TjA.o)=20
on hda1
Dec 14 20:02:17 localhost kernel: collect2(2917): dirtied inode 678207=20
(cc6n7Vqv.ld) on hda1
Dec 14 20:02:17 localhost kernel: collect2(2917): dirtied inode 678208=20
(ccAnMFjC.le) on hda1
Dec 14 20:02:18 localhost kernel: ld(2918): dirtied inode 550552 (.2913=
=2Etmp)=20
on hda1
Dec 14 20:02:18 localhost kernel: cc1(2927): dirtied inode 667799 (ccgX=
oLEp.s)=20
on hda1
Dec 14 20:02:18 localhost kernel: pdflush(132): WRITE block 378016 on h=
da1
Dec 14 20:02:18 localhost kernel: pdflush(132): WRITE block 378024 on h=
da1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16189 (=
syslog)=20
on hda1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16189 (=
syslog)=20
on hda1
Dec 14 20:02:18 localhost kernel: pdflush(132): WRITE block 329472 on h=
da1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16531=20
(kern.log) on hda1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16531=20
(kern.log) on hda1
Dec 14 20:02:18 localhost kernel: pdflush(132): WRITE block 329480 on h=
da1
Dec 14 20:02:18 localhost kernel: pdflush(132): WRITE block 492056 on h=
da1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16537 (=
debug)=20
on hda1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16537 (=
debug)=20
on hda1
Dec 14 20:02:18 localhost kernel: pdflush(132): WRITE block 1851400 on =
hda1
Dec 14 20:02:18 localhost kernel: pdflush(132): WRITE block 10993664 on=
 hda1
Dec 14 20:02:18 localhost kernel: as(2928): dirtied inode 667800 (cc0Kv=
Dl5.o)=20
on hda1
Dec 14 20:02:18 localhost kernel: pdflush(133): WRITE block 378024 on h=
da1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16189 (=
syslog)=20
on hda1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16189 (=
syslog)=20
on hda1
Dec 14 20:02:18 localhost kernel: pdflush(133): WRITE block 329464 on h=
da1
Dec 14 20:02:18 localhost kernel: pdflush(133): WRITE block 329472 on h=
da1
Dec 14 20:02:18 localhost kernel: collect2(2929): dirtied inode 678207=20
(ccf6U3lS.ld) on hda1
Dec 14 20:02:18 localhost kernel: collect2(2929): dirtied inode 678208=20
(cciOTsnM.le) on hda1
Dec 14 20:02:18 localhost kernel: pdflush(133): WRITE block 329480 on h=
da1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16531=20
(kern.log) on hda1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16531=20
(kern.log) on hda1
Dec 14 20:02:18 localhost kernel: pdflush(133): WRITE block 492048 on h=
da1
Dec 14 20:02:18 localhost kernel: pdflush(133): WRITE block 492056 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 378024 on=
 hda1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 329480 on=
 hda1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 10752024 =
on hda1
Dec 14 20:02:18 localhost kernel: ld(2930): dirtied inode 550552 (.2925=
=2Etmp)=20
on hda1
Dec 14 20:02:18 localhost kernel: gcc(2926): dirtied inode 667799 (?) o=
n hda1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16537 (=
debug)=20
on hda1
Dec 14 20:02:18 localhost kernel: rsyslogd(2827): dirtied inode 16537 (=
debug)=20
on hda1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8384 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8392 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8400 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8408 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8416 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8424 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8432 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8440 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8448 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8456 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8464 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8472 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8480 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8488 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8496 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8504 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8512 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8520 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8528 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8536 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8544 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8552 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8560 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(305): WRITE block 8568 on h=
da1
Dec 14 20:02:18 localhost kernel: kjournald(1109): WRITE block 12520 on=
 sda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 327960 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 1835024 on =
hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 1835048 on =
hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 378024 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 378032 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 329480 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 492056 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 492064 on h=
da1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16189 (=
syslog)=20
on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16189 (=
syslog)=20
on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16189 (=
syslog)=20
on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16531=20
(kern.log) on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16531=20
(kern.log) on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16531=20
(kern.log) on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16537 (=
debug)=20
on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16537 (=
debug)=20
on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16537 (=
debug)=20
on hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 378032 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 329480 on=
 hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16189 (=
syslog)=20
on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16189 (=
syslog)=20
on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): WRITE block 329488 on=
 hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 492064 on=
 hda1
Dec 14 20:02:19 localhost logger:   8,0    0        1     0.000000000  =
1109  A =20
WS 12583 + 8 <- (8,1) 12520
Dec 14 20:02:19 localhost logger:   8,0    0        2     0.000006426  =
1109  Q =20
WS 12583 + 8 [kjournald]
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8576 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8584 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8592 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8600 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8608 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8616 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8624 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8632 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8640 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8648 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8656 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8664 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8672 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8680 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8688 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8696 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8704 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8712 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8720 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8728 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8736 on h=
da1
Dec 14 20:02:19 localhost logger:   8,0    0        3     0.000039670  =
1109  G =20
WS 12583 + 8 [kjournald]
Dec 14 20:02:19 localhost logger:   8,0    0        4     0.000061461  =
1109  P =20
N [kjournald]
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16535=20
(user.log) on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16535=20
(user.log) on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16535=20
(user.log) on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16539=20
(messages) on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16539=20
(messages) on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16539=20
(messages) on hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8744 on h=
da1
Dec 14 20:02:19 localhost logger:   8,0    0        5     0.000071797  =
1109  I =20
W 12583 + 8 [kjournald]
Dec 14 20:02:19 localhost logger:   8,0    0        6     0.000272381  =
1109  D =20
W 12583 + 8 [kjournald]
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 329488 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 378032 on=
 hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 492064 on=
 hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 328464 on=
 hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 329208 on=
 hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16531=20
(kern.log) on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16531=20
(kern.log) on hda1
Dec 14 20:02:19 localhost logger:   8,0    0        7     0.000381893  =
1109  U =20
N [kjournald] 1
Dec 14 20:02:19 localhost logger:   8,0    0        8     0.028911225  =
   3  C =20
W 12583 + 8 [0]
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8752 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8760 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8768 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8776 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 492064 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 492072 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 378032 on=
 hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 329488 on=
 hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 378040 on=
 hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 328464 on=
 hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 329208 on=
 hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 329496 on=
 hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16537 (=
debug)=20
on hda1
Dec 14 20:02:19 localhost kernel: rsyslogd(2827): dirtied inode 16537 (=
debug)=20
on hda1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8784 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8792 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8800 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8808 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8816 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8824 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8832 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8840 on h=
da1
Dec 14 20:02:19 localhost kernel: kjournald(305): WRITE block 8848 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 0 on hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 327960 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 376984 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 491760 on h=
da1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 8912896 on =
hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 8912904 on =
hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 8913064 on =
hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 8913184 on =
hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 8994816 on =
hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 10747904 on=
 hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 10747912 on=
 hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 10747920 on=
 hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 10749224 on=
 hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 10749384 on=
 hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 10751824 on=
 hda1
Dec 14 20:02:19 localhost kernel: pdflush(133): WRITE block 10752520 on=
 hda1
Dec 14 20:02:19 localhost kernel: cc1(2945): dirtied inode 667799 (ccvt=
36ES.s)=20
on hda1
Dec 14 20:02:20 localhost kernel: as(2946): dirtied inode 667800 (ccM4g=
5ZY.o)=20
on hda1
Dec 14 20:02:20 localhost kernel: collect2(2947): dirtied inode 678207=20
(ccjYE2NG.ld) on hda1
Dec 14 20:02:20 localhost kernel: collect2(2947): dirtied inode 678208=20
(ccEzo3JR.le) on hda1
Dec 14 20:02:20 localhost kernel: ld(2948): dirtied inode 550552 (.2943=
=2Etmp)=20
on hda1
Dec 14 20:02:20 localhost kernel: cc1(2957): dirtied inode 667799 (cc6Z=
PFDy.s)=20
on hda1
Dec 14 20:02:20 localhost kernel: as(2958): dirtied inode 667800 (ccAj2=
mWp.o)=20
on hda1
Dec 14 20:02:20 localhost kernel: collect2(2959): dirtied inode 678207=20
(ccpJQzdj.ld) on hda1
Dec 14 20:02:20 localhost kernel: collect2(2959): dirtied inode 678208=20
(ccU1Uk0l.le) on hda1
Dec 14 20:02:20 localhost kernel: ld(2960): dirtied inode 550552 (.2955=
=2Etmp)=20
on hda1
Dec 14 20:02:21 localhost kernel: cc1(2969): dirtied inode 667799 (cc7l=
Uzdi.s)=20
on hda1
Dec 14 20:02:21 localhost kernel: as(2970): dirtied inode 667800 (cc2Kn=
xYS.o)=20
on hda1
Dec 14 20:02:21 localhost kernel: collect2(2971): dirtied inode 678207=20
(ccYyMJRv.ld) on hda1
Dec 14 20:02:21 localhost kernel: collect2(2971): dirtied inode 678208=20
(cc0coqFi.le) on hda1
Dec 14 20:02:21 localhost kernel: ld(2972): dirtied inode 550552 (.2967=
=2Etmp)=20
on hda1
Dec 14 20:02:22 localhost kernel: cc1(2981): dirtied inode 667799 (ccnY=
uG29.s)=20
on hda1
Dec 14 20:02:22 localhost kernel: as(2982): dirtied inode 667800 (ccLRJ=
3tt.o)=20
on hda1
Dec 14 20:02:22 localhost kernel: collect2(2985): dirtied inode 678207=20
(cc39KpHM.ld) on hda1
Dec 14 20:02:22 localhost kernel: collect2(2985): dirtied inode 678208=20
(ccKCIBak.le) on hda1
Dec 14 20:02:22 localhost kernel: ld(2986): dirtied inode 550552 (.2979=
=2Etmp)=20
on hda1



>
> (Also, I didn't see any info about sda1 in the posted fstab...)

Oops!  copied the "mount" output when sda wasn't mounted.  Here is the =
output=20
of "mount" current when the above output was generated:

/dev/hda1 on / type ext3 (rw,noatime,errors=3Dremount-ro,commit=3D12096=
00)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=3D0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=3D0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=3D5,mode=3D620)
/dev/sda1 on /mnt/sda type ext3 (rw,noatime,commit=3D1209600)
debugfs on /sys/kernel/debug type debugfs (rw)


C.


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
