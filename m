From: Bo Branten <bosse@acc.umu.se>
Subject: Re: [PATCH] e2fsck: zap extent-format inode with no extent header
Date: Sun, 29 Nov 2015 18:39:58 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1511291838260.27997@suiko.acc.umu.se>
References: <20151128215132.GD10580@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.acc.umu.se ([130.239.18.156]:46824 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbbK2RkC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Nov 2015 12:40:02 -0500
In-Reply-To: <20151128215132.GD10580@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Thank you for this patch, I tryed it on my computer and it does fix the 
error our bug caused:

bo@ubuntu:~/src/e2fsprogs-1.42.13$ sudo mount -t ext4 /dev/sdb5 /mnt
bo@ubuntu:~/src/e2fsprogs-1.42.13$ ls -l /mnt
ls: cannot access /mnt/testa: Input/output error
total 20
drwx------ 2 root root 16384 Nov 28 18:09 lost+found
-????????? ? ?    ?        ?            ? testa
-rw-r--r-- 1 root root     1 Nov 28 18:15 testb
bo@ubuntu:~/src/e2fsprogs-1.42.13$ sudo umount /mnt
bo@ubuntu:~/src/e2fsprogs-1.42.13$ sudo ./e2fsck/e2fsck -fy /dev/sdb5
e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Inode 12 has corrupt extent header.  Clear inode? yes

Pass 2: Checking directory structure
Entry 'testa' in / (2) has deleted/unused inode 12.  Clear? yes

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Inode bitmap differences:  -12
Fix? yes

Free inodes count wrong for group #0 (115, counted=116).
Fix? yes

Free inodes count wrong (115, counted=116).
Fix? yes


/dev/sdb5: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sdb5: 12/128 files (0.0% non-contiguous), 15/256 blocks
bo@ubuntu:~/src/e2fsprogs-1.42.13$ sudo mount -t ext4 /dev/sdb5 /mnt
bo@ubuntu:~/src/e2fsprogs-1.42.13$ ls -l /mnt
total 20
drwx------ 2 root root 16384 Nov 28 18:09 lost+found
-rw-r--r-- 1 root root     1 Nov 28 18:15 testb
bo@ubuntu:~/src/e2fsprogs-1.42.13$

