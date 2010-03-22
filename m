From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Mon, 22 Mar 2010 21:51:56 GMT
Message-ID: <201003222151.o2MLpuWI030555@demeter.kernel.org>
References: <bug-13549-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35647 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab0CVVv6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2010 17:51:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2MLpudE030556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 21:51:57 GMT
In-Reply-To: <bug-13549-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13549





--- Comment #12 from Eric Sandeen <sandeen@redhat.com>  2010-03-22 21:51:35 ---
I'm afraid I've not been able to reproduce it:

create a sparse loopback filesystem:

[root@inode test]# touch fsfile
[root@inode test]# truncate --size 1020054732800 fsfile 
[root@inode test]# ls -lh fsfile 
-rw-r--r--. 1 root root 950G Mar 22 16:28 fsfile
[root@inode test]# mkfs.ext4 fsfile 
mke2fs 1.41.10 (10-Feb-2009)

<at this point I checked that the filesystem size and features are similar to
your fs>

[root@inode test]# ls -lh fsfile 
-rw-r--r--. 1 root root 950G Mar 22 16:28 fsfile

Grow the container by about 50G:

[root@inode test]# truncate --size 1099511627776 fsfile 
[root@inode test]# ls -lh fsfile 
-rw-r--r--. 1 root root 1.0T Mar 22 16:32 fsfile

Resize while mounted:

[root@inode test]# mount -o loop fsfile  mnt/
[root@inode test]# resize2fs /dev/loop0 
resize2fs 1.41.10 (10-Feb-2009)
Filesystem at /dev/loop0 is mounted on /mnt/test/mnt; on-line resizing required
old desc_blocks = 60, new_desc_blocks = 64
Performing an on-line resize of /dev/loop0 to 268435456 (4k) blocks.
The filesystem on /dev/loop0 is now 268435456 blocks long.

No oops ... so I'm not sure what is going on here.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
