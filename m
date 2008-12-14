From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Sun, 14 Dec 2008 14:30:01 -0800 (PST)
Message-ID: <20081214223001.9E693108047@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576AbYLNWaE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2008 17:30:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBEMU1Mg020111
	for <linux-ext4@vger.kernel.org>; Sun, 14 Dec 2008 14:30:02 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-12-14 14:30 -------
Reply-To: akpm@linux-foundation.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sun, 14 Dec 2008 11:39:34 -0800 (PST) bugme-daemon@bugzilla.kernel.org
wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12224
> 
>            Summary: journal activity on inactive partition causes inactive
>                     harddrive spinup
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.27.6
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: low
>           Priority: P1
>          Component: ext3
>         AssignedTo: fs_ext3@kernel-bugs.osdl.org
>         ReportedBy: csights@fastmail.fm
> 
> 
> Latest working kernel version: 2.6.27.5
> Earliest failing kernel version: 2.6.27.6

Thanks for being this specific.

> Distribution: Debian stable with custom compiled vanilla kernel
> 
> Problem Description:
>     Activity on one partition (hda1) causes kjournald to also write to another
> partition (sda1).  This in turn causes the harddrive which contains sda1 to
> spinup or not spindown.
>     I've activated laptop-mode using laptop-mode-tools. hda1 and sda1 are both
> formatted with ext3.
>     On unaffected kernels (e.g. 2.6.27.5) btrace produces no output.  On
> affected kernels (e.g. 2.6.27.6, 2.6.27-rc7) btrace produces output as below.

I think I've seen other reports of this.  Maybe it was you.

> /dev/hda1 on / type ext3 (rw,noatime,errors=remount-ro,commit=1209600)
> tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
> proc on /proc type proc (rw,noexec,nosuid,nodev)
> sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
> udev on /dev type tmpfs (rw,mode=0755)
> tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
> devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
> debugfs on /sys/kernel/debug type debugfs (rw)
> 
> Steps to reproduce:
>     1. start "btrace /dev/sda"
>     2. begin compiling kernel
>     3. within seconds btrace begins output similar to below.
> 
> 
> Thanks for all your work!  Sorry if I've misplaced blame for this undesirable
> change in behavior.
> 
> Using 2.6.27.8, btrace of /dev/sda while compiling on /dev/hda1

OK, that's a huge mess because bugzilla went and wordwrapped it.  Let
me fix it:

> Dec   9 11:15:32 localhost logger:    8,0      0            1       0.000000000    1109   A   WS 14375 + 8 <- (8,1) 14312
> Dec   9 11:15:32 localhost logger:    8,0      0            2       0.000006705   1109   Q   WS 14375 + 8 [kjournald]
> Dec   9 11:15:32 localhost logger:    8,0      0            3       0.000043581   1109   G   WS 14375 + 8 [kjournald] 
> Dec   9 11:15:32 localhost logger:    8,0      0            4       0.000065651   1109   P    N [kjournald]
> Dec   9 11:15:32 localhost logger:    8,0      0            5       0.000076267   1109   I    W 14375 + 8 [kjournald]
> Dec   9 11:15:32 localhost logger:    8,0      0            6       0.000300318   1109   D    W 14375 + 8 [kjournald]
> Dec   9 11:15:32 localhost logger:    8,0      0            7       0.000423518   1109   U    N [kjournald] 1
> Dec   9 11:15:32 localhost logger:    8,0      0            8       0.010028373      3   C    W 14375 + 8 [0]
> Dec   9 11:15:35 localhost logger:    8,0      0            9       3.219049689   1109   A   WS 14383 + 8 <- (8,1) 14320
> Dec   9 11:15:35 localhost logger:    8,0      0           10       3.219058350   1109   Q   WS 14383 + 8 [kjournald]
> Dec   9 11:15:35 localhost logger:    8,0      0           11       3.219095505   1109   G   WS 14383 + 8 [kjournald]
> Dec   9 11:15:35 localhost logger:    8,0      0           12       3.219115061   1109   P    N [kjournald]
> Dec   9 11:15:35 localhost logger:    8,0      0           13       3.219127074   1109   I    W 14383 + 8 [kjournald]
> Dec   9 11:15:35 localhost logger:    8,0      0           14       3.219344699   1109   D    W 14383 + 8 [kjournald]
> Dec   9 11:15:35 localhost logger:    8,0      0           15       3.219543607   1109   U    N [kjournald] 1
> Dec   9 11:15:35 localhost logger:    8,0      0           16       3.229477275       3   C    W 14383 + 8 [0]

I'm not familar with btrace.  What are we looking at here?

The only likely commit I see in
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.27.6 is "ext3:
wait on all pending commits in ext3_sync_fs", but I don't see how it
could cause this.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
