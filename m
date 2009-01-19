From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11688] Oops while writing on a newly ext4 formated 1TB partition on a external USB drive
Date: Sun, 18 Jan 2009 17:18:15 -0800 (PST)
Message-ID: <20090119011815.BFC3310800F@picon.linux-foundation.org>
References: <bug-11688-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756427AbZASBSr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 20:18:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0J1IFUS017174
	for <linux-ext4@vger.kernel.org>; Sun, 18 Jan 2009 17:18:16 -0800
In-Reply-To: <bug-11688-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11688





------- Comment #6 from vedranf@vedranf.mine.nu  2009-01-18 17:18 -------
                total       used       free     shared    buffers     cached
Mem:       1773      1730       43        0            23           1185
-/+ buffers/cache:   521       1252
Swap:            0          0          0

/dev/mapper/vg-root on / type ext3 (rw,errors=remount-ro)
/dev/mapper/vg-home on /home type ext3 (rw,usrquota)
/dev/mapper/vg-var on /var type ext3 (rw)
/dev/sda3 on /media/disk type ext4dev (rw,nosuid,nodev,uhelper=hal)
/dev/sda2 on /media/disk-1 type ext3 (rw,nosuid,nodev,uhelper=hal,data=ordered)

Copying from /home to /media/disk so only these are active if I understand you
correctly. 

# debugfs -R "stat <8>" /dev/mapper/vg-home                               
debugfs 1.41.3 (12-Oct-2008)
Inode: 8   Type: regular    Mode:  0600   Flags: 0x0
Generation: 0    Version: 0x00000000
User:     0   Group:     0   Size: 134217728
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 262416
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x487a96ce -- Mon Jul 14 01:59:10 2008
atime: 0x00000000 -- Thu Jan  1 01:00:00 1970
mtime: 0x487a96ce -- Mon Jul 14 01:59:10 2008
Size of extra inode fields: 0

# debugfs -R "stat <8>" /dev/sda3                                           
debugfs 1.41.3 (12-Oct-2008)
Inode: 8   Type: regular    Mode:  0600   Flags: 0x80000
Generation: 0    Version: 0x00000000
User:     0   Group:     0   Size: 134217728
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 262144
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x48ee6d44 -- Thu Oct  9 22:44:52 2008
atime: 0x00000000 -- Thu Jan  1 01:00:00 1970
mtime: 0x48ee6d44 -- Thu Oct  9 22:44:52 2008
Size of extra inode fields: 0


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
