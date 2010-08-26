From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16711] Oops with 2.6.36-rc1
Date: Thu, 26 Aug 2010 10:30:30 GMT
Message-ID: <201008261030.o7QAUUJs016372@demeter1.kernel.org>
References: <bug-16711-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:32846 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0HZKaf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 06:30:35 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7QAUV46016374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 10:30:31 GMT
In-Reply-To: <bug-16711-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16711





--- Comment #8 from Tobias <devnull@plzk.org>  2010-08-26 10:29:21 ---
John,

wrt #5: This is a Macbook 2.1, I replaced RAM and HDD a while back. lscpi
output attached. I have an OSX install on it that it never used, and Ubuntu
10.04. Ubuntu install consists of an unencrypted /boot partition and an
encrypted partition where LVM provides / and /home. 

fdisk -l shows:

/dev/sda1               1          26      204819+  ee  GPT
/dev/sda2   *          26        5248    41943040   af  HFS / HFS+
/dev/sda3            5248        5308      487424   83  Linux
/dev/sda4            5308       60802   445750272   ef  EFI (FAT-12/16/32)

mount:

/dev/mapper/vg-root on / type ext4 (rw,errors=remount-ro)
proc on /proc type proc (rw,noexec,nosuid,nodev)
none on /sys type sysfs (rw,noexec,nosuid,nodev)
none on /sys/fs/fuse/connections type fusectl (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /sys/kernel/security type securityfs (rw)
none on /dev type devtmpfs (rw,mode=0755)
none on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
none on /dev/shm type tmpfs (rw,nosuid,nodev)
none on /var/run type tmpfs (rw,nosuid,mode=0755)
none on /var/lock type tmpfs (rw,noexec,nosuid,nodev)
none on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
/dev/mapper/vg-home on /home type ext4 (rw)
/dev/sda3 on /boot type ext3 (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc
(rw,noexec,nosuid,nodev)
gvfs-fuse-daemon on /home/tobias/.gvfs type fuse.gvfs-fuse-daemon
(rw,nosuid,nodev,user=tobias)

That said this is a stock setup.

wrt #6: I think I am running into the same issue as described in [1]. People
are saying it is fixed in maverick, so I am hoping for an upgrade or backport
to lucid.
What puzzles me is that the exact issue (trying to build a -git kernel) was
reported to lkml from a maverick user [2], and the thread suggests that there
are kernel patches available to fix this. Now I am unsure where if
kernel-package or source itself are broken.

Please let me know if there are things I can do to be of help (things that
break my setup are no option unfortunately).

[1] https://bugs.launchpad.net/ubuntu/+source/kernel-package/+bug/58307
[2] http://marc.info/?t=128247993200002&r=1&w=2

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
