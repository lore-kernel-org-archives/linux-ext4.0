From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Mon, 15 Dec 2008 13:49:11 -0800 (PST)
Message-ID: <20081215214911.3E1DA108042@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756524AbYLOVtN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2008 16:49:13 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBFLnBqQ029854
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2008 13:49:12 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D12224





------- Comment #7 from csights@fastmail.fm  2008-12-15 13:49 -------
Hi,
        Following Ted's suggestion, I began with 2.6.27.6 and then reve=
rsed the
patch=20
for commit a0b8bfb34743b6e6c2bb06ad5a270590d90270f7.  This "fixed" the=20
problem such that activity on hda1 no longer caused kjournald to write =
to=20
sda1.




> Is /dev/sda1 even mounted?  It doesn't included up in your /etc/mtab
> listing.

Just to confirm, I posted the wrong mtab previously.  sda1 is mounted d=
uring=20
my tests.  This is how it looks:

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



> ------- Comment #6 from sandeen@redhat.com =A02008-12-14 21:07 ------=
-
>
> Dec 14 20:02:18 localhost kernel: kjournald(1109): WRITE block 12520 =
on
> sda1
>
> is the first thing I see in the log above, with no indication of anyt=
hing
> else on sda1 before that.

        I only copied the lines from the log during the short compile "=
test".
        Here is another test which is a little more clean, using 2.6.27=
=2E6
(without=20
the commit mentioned above reverted).=20

        First unmount, then remount /dev/sda1 to flush the filesystem c=
aches:
# umount /dev/sda1; mount /mnt/sda; btrace /dev/sda | logger -s

        then switch to another console and restart laptop mode (to chan=
ge the
commit=20
time on sda1):
#/etc/init.d/laptop-mode restart

        Finally generate some activity on hda1.  ("make menuconfig")
        The following is syslog from the mount of /dev/sda1 (on /mnt/sd=
a) until
"make=20
clean" finished:

Dec 15 16:34:48 localhost kernel: kjournald starting.  Commit interval =
5=20
seconds
Dec 15 16:34:48 localhost kernel: EXT3 FS on sda1, internal journal
Dec 15 16:34:48 localhost kernel: EXT3-fs: mounted filesystem with orde=
red=20
data mode.
Dec 15 16:34:54 localhost kernel: hda: cache flushes not supported
Dec 15 16:34:56 localhost kernel: hda: cache flushes not supported
Dec 15 16:34:57 localhost logger:   8,0    0        1     0.000000000  =
4140  A =20
WS 12423 + 8 <- (8,1) 12360
Dec 15 16:34:57 localhost logger:   8,0    0        2     0.000006146  =
4140  Q =20
WS 12423 + 8 [kjournald]
Dec 15 16:34:57 localhost logger:   8,0    0        3     0.000114819  =
4140  G =20
WS 12423 + 8 [kjournald]
Dec 15 16:34:57 localhost logger:   8,0    0        4     0.000143314  =
4140  P =20
N [kjournald]
Dec 15 16:34:57 localhost logger:   8,0    0        5     0.000159797  =
4140  I =20
W 12423 + 8 [kjournald]
Dec 15 16:34:57 localhost logger:   8,0    0        6     0.000348089  =
4140  D =20
W 12423 + 8 [kjournald]
Dec 15 16:34:57 localhost logger:   8,0    0        7     0.000463746  =
4140  U =20
N [kjournald] 1
Dec 15 16:34:57 localhost logger:   8,0    0        8     0.010034518  =
   3  C =20
W 12423 + 8 [0]
Dec 15 16:34:57 localhost logger:   8,0    0        9     0.010557490  =
4140  A =20
WS 12431 + 8 <- (8,1) 12368
Dec 15 16:34:57 localhost logger:   8,0    0       10     0.010563916  =
4140  Q =20
WS 12431 + 8 [kjournald]
Dec 15 16:34:57 localhost logger:   8,0    0       11     0.010589617  =
4140  G =20
WS 12431 + 8 [kjournald]
Dec 15 16:34:57 localhost logger:   8,0    0       12     0.010606658  =
4140  P =20
N [kjournald]
Dec 15 16:34:57 localhost logger:   8,0    0       13     0.010616157  =
4140  I =20
W 12431 + 8 [kjournald]
Dec 15 16:34:57 localhost logger:   8,0    0       14     0.010749414  =
4140  D =20
W 12431 + 8 [kjournald]
Dec 15 16:34:57 localhost logger:   8,0    0       15     0.010836297  =
4140  U =20
N [kjournald] 1
Dec 15 16:34:57 localhost logger:   8,0    0       16     0.021000161  =
   3  C =20
W 12431 + 8 [0]
Dec 15 16:34:59 localhost logger:   8,0    0       17     2.350235673  =
4140  A =20
WS 12439 + 8 <- (8,1) 12376
Dec 15 16:34:59 localhost logger:   8,0    0       18     2.350244612  =
4140  Q =20
WS 12439 + 8 [kjournald]
Dec 15 16:34:59 localhost logger:   8,0    0       19     2.350278974  =
4140  G =20
WS 12439 + 8 [kjournald]
Dec 15 16:34:59 localhost logger:   8,0    0       20     2.350301044  =
4140  P =20
N [kjournald]
Dec 15 16:34:59 localhost logger:   8,0    0       21     2.350316130  =
4140  I =20
W 12439 + 8 [kjournald]
Dec 15 16:34:59 localhost logger:   8,0    0       22     2.350568397  =
4140  D =20
W 12439 + 8 [kjournald]
Dec 15 16:34:59 localhost logger:   8,0    0       23     2.350684333  =
4140  U =20
N [kjournald] 1
Dec 15 16:34:59 localhost logger:   8,0    0       24     2.360609899  =
   3  C =20
W 12439 + 8 [0]
Dec 15 16:35:52 localhost logger:   8,0    0       25    55.121164875  =
4140  A =20
WS 12447 + 8 <- (8,1) 12384
Dec 15 16:35:52 localhost logger:   8,0    0       26    55.121172697  =
4140  Q =20
WS 12447 + 8 [kjournald]
Dec 15 16:35:52 localhost logger:   8,0    0       27    55.121203707  =
4140  G =20
WS 12447 + 8 [kjournald]
Dec 15 16:35:52 localhost logger:   8,0    0       28    55.121221865  =
4140  P =20
N [kjournald]
Dec 15 16:35:52 localhost logger:   8,0    0       29    55.121232202  =
4140  I =20
W 12447 + 8 [kjournald]
Dec 15 16:35:52 localhost logger:   8,0    0       30    55.121458767  =
4140  D =20
W 12447 + 8 [kjournald]
Dec 15 16:35:52 localhost logger:   8,0    0       31    55.121571910  =
4140  U =20
N [kjournald] 1
Dec 15 16:35:52 localhost logger:   8,0    0       32    55.131824892  =
   3  C =20
W 12447 + 8 [0]
Dec 15 16:35:57 localhost logger:   8,0    0       33    59.696845185  =
4140  A =20
WS 12455 + 8 <- (8,1) 12392
Dec 15 16:35:57 localhost logger:   8,0    0       34    59.696853566  =
4140  Q =20
WS 12455 + 8 [kjournald]
Dec 15 16:35:57 localhost logger:   8,0    0       35    59.696888486  =
4140  G =20
WS 12455 + 8 [kjournald]
Dec 15 16:35:57 localhost logger:   8,0    0       36    59.696908880  =
4140  P =20
N [kjournald]
Dec 15 16:35:57 localhost logger:   8,0    0       37    59.696920334  =
4140  I =20
W 12455 + 8 [kjournald]
Dec 15 16:35:57 localhost logger:   8,0    0       38    59.697142709  =
4140  D =20
W 12455 + 8 [kjournald]
Dec 15 16:35:57 localhost logger:   8,0    0       39    59.697256410  =
4140  U =20
N [kjournald] 1
Dec 15 16:35:57 localhost logger:   8,0    0       40    59.707057938  =
   3  C =20
W 12455 + 8 [0]
Dec 15 16:36:04 localhost logger:   8,0    0       41    67.363585697  =
4140  A =20
WS 12463 + 8 <- (8,1) 12400
Dec 15 16:36:04 localhost logger:   8,0    0       42    67.363595196  =
4140  Q =20
WS 12463 + 8 [kjournald]
Dec 15 16:36:04 localhost logger:   8,0    0       43    67.363627043  =
4140  G =20
WS 12463 + 8 [kjournald]
Dec 15 16:36:04 localhost logger:   8,0    0       44    67.363646319  =
4140  P =20
N [kjournald]
Dec 15 16:36:04 localhost logger:   8,0    0       45    67.363657215  =
4140  I =20
W 12463 + 8 [kjournald]
Dec 15 16:36:04 localhost logger:   8,0    0       46    67.363869253  =
4140  D =20
W 12463 + 8 [kjournald]
Dec 15 16:36:04 localhost logger:   8,0    0       47    67.363980161  =
4140  U =20
N [kjournald] 1
Dec 15 16:36:04 localhost logger:   8,0    0       48    67.373786717  =
   3  C =20
W 12463 + 8 [0]

>
> If you let the system just sit idle, do you get sda1 hits from the sy=
sctl
> and/or blktrace?

        If I let the system sit idle using 2.6.27.5 (the last unaffecte=
d=20
version) 'btrace /dev/sda' shows no activity, even if there is activity=
 on=20
hda1.
        If I let the system sit idle using 2.6.27.6 (the first affected=
=20
version) 'btrace /dev/sda' shows kjournald doing something with sda1 if=
 there=20
is activity on hda1.  If hda1 is inactive then there is also no activit=
y on=20
sda1.

Thanks!
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
