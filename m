From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 117421] New: e2fsprogs: mke2fs ignores sparse_super2 when also
 using extent or 64bit
Date: Sat, 30 Apr 2016 11:08:21 +0000
Message-ID: <bug-117421-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40316 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbcD3LI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 Apr 2016 07:08:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 41143201FA
	for <linux-ext4@vger.kernel.org>; Sat, 30 Apr 2016 11:08:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 66EDA201DD
	for <linux-ext4@vger.kernel.org>; Sat, 30 Apr 2016 11:08:22 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=117421

            Bug ID: 117421
           Summary: e2fsprogs: mke2fs ignores sparse_super2 when also
                    using extent or 64bit
           Product: File System
           Version: 2.5
    Kernel Version: 4.2.8
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: kellyc@surroundbackgrounds.com
        Regression: No

Package: e2fsprogs
Version: 1.42.12-1.1
Severity: normal
File: /sbin/mke2fs

When creating an ext3/ext4 filesystem the sparse_super2 option is ignored and
defaults back to sparse_super when using extent or 64bit.
mke2fs should respect the use of sparse_super2 when using either or both -O
extent or -O 64bit.


Normal formatting using sparse_super and works as expected creating 2 backup
superblocks.

mke2fs /dev/sdq1 -t ext4 -b 4096 -O sparse_super2
mke2fs 1.42.12 (29-Aug-2014)
Creating filesystem with 61049344 4k blocks and 15269888 inodes
Filesystem UUID: cdaa09a3-dcb2-473a-9da8-7517a632db14
Superblock backups stored on blocks:
        32768, 61046784

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done



Using extent option with sparse_super2 creates more than 2 backup superblocks.


mke2fs /dev/sdq1 -t ext4 -b 4096 -O sparse_super2 -O extent
mke2fs 1.42.12 (29-Aug-2014)
Creating filesystem with 61049344 4k blocks and 15269888 inodes
Filesystem UUID: 4634627d-bd41-4f96-923d-21746f12cf1f
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,  
2654208,4096000, 7962624, 11239424, 20480000, 23887872

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done



Using 64bit option with sparse_super2 creates more than 2 backup superblocks.


mke2fs /dev/sdq1 -t ext4 -b 4096 -O sparse_super2 -O 64bit
mke2fs 1.42.12 (29-Aug-2014)
Creating filesystem with 61049344 4k blocks and 15269888 inodes
Filesystem UUID: ef3ed24c-0183-40c9-b2de-0b8e9bb868bb
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
4096000, 7962624, 11239424, 20480000, 23887872

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done



mke2fs (mkfs.ext4) should respect the sparse_super2 option when used with 64bit
or extent.




-- System Information:
Debian Release: 8.3
  APT prefers stable
  APT policy: (500, 'stable')
Architecture: amd64 (x86_64)

Kernel: Linux 4.2.8-1-pve (SMP w/24 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash
Init: systemd (via /run/systemd/system)

Versions of packages e2fsprogs depends on:
ii  e2fslibs    1.42.12-1.1
ii  libblkid1   2.25.2-6
ii  libc6       2.19-18+deb8u3
ii  libcomerr2  1.42.12-1.1
ii  libss2      1.42.12-1.1
ii  libuuid1    2.25.2-6
ii  util-linux  2.25.2-6


e2fsprogs recommends no packages.

Versions of packages e2fsprogs suggests:
pn  e2fsck-static  <none>
pn  gpart          <none>
ii  parted         3.2-7

-- no debconf information

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
