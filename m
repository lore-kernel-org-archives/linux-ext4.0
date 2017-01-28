From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193431] New: 512 byte inodes + inline_data + journal_data ==
 segfaults/buserrors in userspace mmap
Date: Sat, 28 Jan 2017 12:38:26 +0000
Message-ID: <bug-193431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751473AbdA1Mtb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 28 Jan 2017 07:49:31 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id BD63F203E3
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2017 12:38:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 7CE5820380
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2017 12:38:27 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193431

            Bug ID: 193431
           Summary: 512 byte inodes + inline_data + journal_data ==
                    segfaults/buserrors in userspace mmap
           Product: File System
           Version: 2.5
    Kernel Version: Multiple ( tested on 3.16, 4.1 and 4.9 )
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: rabbit@rabbit.us
        Regression: No

Created attachment 253361
  --> https://bugzilla.kernel.org/attachment.cgi?id=253361&action=edit
Backtrace attempt

Steps to reproduce:


root@Ahasver:~# dd if=/dev/zero of=zeros.img bs=128M count=1
1+0 records in
1+0 records out
134217728 bytes (134 MB) copied, 1.61473 s, 83.1 MB/s


root@Ahasver:~# losetup -f zeros.img


root@Ahasver:~# mke2fs -t ext4 -I 512 -j -O inline_data /dev/loop0
mke2fs 1.43.3 (04-Sep-2016)
journal checksum features.
Discarding device blocks: done                            
Creating filesystem with 131072 1k blocks and 32768 inodes
Filesystem UUID: 675cf4a8-fb74-4a4a-9f28-f01b462b1933
Superblock backups stored on blocks: 
    8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done 



root@Ahasver:~# mount -o data=journal /dev/loop0 /mnt


root@Ahasver:~# rm -f /usr/lib/locale/locale-archive


root@Ahasver:~# ln -s /mnt/locale-archive /usr/lib/locale/locale-archive


root@Ahasver:~# localedef -i en_US -c -f ISO-8859-1 en_US
Segmentation fault



I am also attaching a gdb backtrace of the error as seen using the Debian
Stretch Installer RC1. The backtraced line 773 seems to be this one:
https://sources.debian.net/src/glibc/2.24-9/locale/programs/locarchive.c/#L773

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
