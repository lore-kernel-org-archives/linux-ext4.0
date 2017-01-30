From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193431] 512 byte inodes + inline_data + journal_data ==
 segfaults/buserrors in userspace mmap
Date: Mon, 30 Jan 2017 11:11:25 +0000
Message-ID: <bug-193431-13602-cJhNfVyoEp@https.bugzilla.kernel.org/>
References: <bug-193431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750971AbdA3LUX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 06:20:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 8DCA92026F
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 11:11:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id D58FE20256
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 11:11:25 +0000 (UTC)
In-Reply-To: <bug-193431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193431

Peter Rabbitson <rabbit@rabbit.us> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|INVALID                     |---

--- Comment #3 from Peter Rabbitson <rabbit@rabbit.us> ---
I assure you the problem is real. In my frustration/excitement I did not
properly trim down the testcase, and ignored the obvious change in behavior (
SIGUS -> SIGSEGV ).

Unfortunately I won't have time in the next couple days to properly trim this
down. All I currently have is the tarball of a minimalistic chroot left over
from a failed debian install ( 35MiB
SHA1:18917303621bd99ef8c319107ed0dcd2eb44abe0 ):
https://ipfs.io/ipfs/QmVbjsxH93Wy4Lnx1pThdd1iQ33TpeysoHuwzFb7awef5U/chroot_with_failing_locales_reconfig.tar.xz

The failure is as follows, showcasing a successful run and a failing run right
after ( the 512 inode size was a red herring: 256 fails as well ):


root@Ahasver:~# dd if=/dev/zero of=zeros.img bs=512M count=1
1+0 records in
1+0 records out
536870912 bytes (537 MB) copied, 11.8806 s, 45.2 MB/s


root@Ahasver:~# losetup -f zeros.img


root@Ahasver:~# mke2fs -t ext4 -j -O inline_data /dev/loop0
mke2fs 1.43.3 (04-Sep-2016)
Discarding device blocks: done                            
Creating filesystem with 131072 4k blocks and 32768 inodes
Filesystem UUID: 027504fd-e49d-42a3-bcd5-4ea3a05af5ed
Superblock backups stored on blocks: 
    32768, 98304

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done


root@Ahasver:~# mount /dev/loop0 /mnt


root@Ahasver:~# cd /mnt


root@Ahasver:/mnt# tar -Jxf ~/chroot_with_failing_locales_reconfig.tar.xz 


root@Ahasver:/mnt# cd chroot_with_failing_locales_reconfig/


root@Ahasver:/mnt/chroot_with_failing_locales_reconfig# ./chroot.bash 


root@Ahasver:/# dpkg-reconfigure -u locales
Generating locales (this might take a while)...
  en_US.ISO-8859-1... done
  en_US.UTF-8... done
Generation complete.


root@Ahasver:/# exit


root@Ahasver:/mnt/chroot_with_failing_locales_reconfig# cd


root@Ahasver:~# umount /mnt


root@Ahasver:~# mount -o data=journal /dev/loop0 /mnt


root@Ahasver:~# cd /mnt/chroot_with_failing_locales_reconfig/


root@Ahasver:/mnt/chroot_with_failing_locales_reconfig# ./chroot.bash 


root@Ahasver:/# dpkg-reconfigure -u locales
Generating locales (this might take a while)...
  en_US.ISO-8859-1...Bus error
 done
  en_US.UTF-8...Bus error
 done
Generation complete.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
