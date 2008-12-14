From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] New: journal activity on inactive partition causes inactive harddrive spinup
Date: Sun, 14 Dec 2008 11:39:34 -0800 (PST)
Message-ID: <bug-12224-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945AbYLNTji convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2008 14:39:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBEJdZYJ013273
	for <linux-ext4@vger.kernel.org>; Sun, 14 Dec 2008 11:39:36 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D12224

           Summary: journal activity on inactive partition causes inact=
ive
                    harddrive spinup
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.27.6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: csights@fastmail.fm


Latest working kernel version: 2.6.27.5
Earliest failing kernel version: 2.6.27.6
Distribution: Debian stable with custom compiled vanilla kernel

Problem Description:
    Activity on one partition (hda1) causes kjournald to also write to =
another
partition (sda1).  This in turn causes the harddrive which contains sda=
1 to
spinup or not spindown.
    I've activated laptop-mode using laptop-mode-tools. hda1 and sda1 a=
re both
formatted with ext3.
    On unaffected kernels (e.g. 2.6.27.5) btrace produces no output.  O=
n
affected kernels (e.g. 2.6.27.6, 2.6.27-rc7) btrace produces output as =
below.

/dev/hda1 on / type ext3 (rw,noatime,errors=3Dremount-ro,commit=3D12096=
00)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=3D0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=3D0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=3D5,mode=3D620)
debugfs on /sys/kernel/debug type debugfs (rw)

Steps to reproduce:
    1. start "btrace /dev/sda"
    2. begin compiling kernel
    3. within seconds btrace begins output similar to below.


Thanks for all your work!  Sorry if I've misplaced blame for this undes=
irable
change in behavior.

Using 2.6.27.8, btrace of /dev/sda while compiling on /dev/hda1
Dec =C2=A09 11:15:32 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 0.000000000
=C2=A01109 =C2=A0A =C2=A0WS 14375 + 8 <- (8,1) 14312
Dec =C2=A09 11:15:32 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 0.000006705
=C2=A01109 =C2=A0Q =C2=A0WS 14375 + 8 [kjournald]
Dec =C2=A09 11:15:32 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 0.000043581
=C2=A01109 =C2=A0G =C2=A0WS 14375 + 8 [kjournald]=20
Dec =C2=A09 11:15:32 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 0.000065651
=C2=A01109 =C2=A0P =C2=A0 N [kjournald]
Dec =C2=A09 11:15:32 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 0.000076267
=C2=A01109 =C2=A0I =C2=A0 W 14375 + 8 [kjournald]
Dec =C2=A09 11:15:32 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 0.000300318
=C2=A01109 =C2=A0D =C2=A0 W 14375 + 8 [kjournald]
Dec =C2=A09 11:15:32 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 0.000423518
=C2=A01109 =C2=A0U =C2=A0 N [kjournald] 1
Dec =C2=A09 11:15:32 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A08 =C2=A0 =C2=A0 0.010028373
=C2=A0 =C2=A0 3 =C2=A0C =C2=A0 W 14375 + 8 [0]
Dec =C2=A09 11:15:35 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A09 =C2=A0 =C2=A0 3.219049689
=C2=A01109 =C2=A0A =C2=A0WS 14383 + 8 <- (8,1) 14320
Dec =C2=A09 11:15:35 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 10 =C2=A0 =C2=A0 3.219058350
=C2=A01109 =C2=A0Q =C2=A0WS 14383 + 8 [kjournald]
Dec =C2=A09 11:15:35 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 11 =C2=A0 =C2=A0 3.219095505
=C2=A01109 =C2=A0G =C2=A0WS 14383 + 8 [kjournald]
Dec =C2=A09 11:15:35 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 12 =C2=A0 =C2=A0 3.219115061
=C2=A01109 =C2=A0P =C2=A0 N [kjournald]
Dec =C2=A09 11:15:35 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 13 =C2=A0 =C2=A0 3.219127074
=C2=A01109 =C2=A0I =C2=A0 W 14383 + 8 [kjournald]
Dec =C2=A09 11:15:35 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 14 =C2=A0 =C2=A0 3.219344699
=C2=A01109 =C2=A0D =C2=A0 W 14383 + 8 [kjournald]
Dec =C2=A09 11:15:35 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 15 =C2=A0 =C2=A0 3.219543607
=C2=A01109 =C2=A0U =C2=A0 N [kjournald] 1
Dec =C2=A09 11:15:35 localhost logger: =C2=A0 8,0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 16 =C2=A0 =C2=A0 3.229477275
=C2=A0 =C2=A0 3 =C2=A0C =C2=A0 W 14383 + 8 [0]


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
