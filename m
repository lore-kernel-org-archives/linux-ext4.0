From: Cristian Paslaru <cristian@paslaru.com>
Subject: 7TB drive conversion from ext3 to ext4 issues
Date: Tue, 21 Sep 2010 17:15:12 +0300
Message-ID: <AANLkTi=FZu-jwHJ74AHczQgN-ijtfeTE7BfQhjWJ7y7Y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41992 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab0IUOPd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Sep 2010 10:15:33 -0400
Received: by pvg2 with SMTP id 2so1429711pvg.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Sep 2010 07:15:32 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

The environment:
- # uname -a
Linux HOST 2.6.18-194.11.3.el5PAE #1 SMP date time TZ 2010 i686 i686
i386 GNU/Linux
- CentOS release 5.5 (Final)
- glibc-2.5-49.el5_5.4
- e2fsprogs-1.39-23.el5
- e4fsprogs-1.41.9-3.el5
- # free
             total       used       free     shared    buffers     cached
Mem:       8306676    8280328      26348          0     687092    6859776
-/+ buffers/cache:     733460    7573216
Swap:      1839432        324    1839108

Used also for e2image the last e2fsprogs 1.41.12:
# ./e2image -I /dev/sdb1 /opt/e2fsck/sdb1_e4image_normal&
[2] 12880
# e2image 1.41.12 (17-May-2010)


Steps to reproduce:
1. Started to convert "7TB" drive ( used for backups, availability is
not primary concern ) from ext3 to ext4
     WARNING: The size of this disk is 7.0 TB (6997575467008 bytes)
# tune4fs -O extents,uninit_bg /dev/sdb1
# e4fsck -y -v /dev/sdb1

Had memory errors, as there a lot of hard-links, as this is the way
the incremental backups where done, using rsync --link-dest option,
with an usage space of 90%, meaning lot of data, files, and
hard-links.
Configured:
  # cat /etc/e4fsck.conf
  [scratch_files]
         directory = /opt/e2fsck
to reduce memory usage, but with slowdown ...

Now e4fsck reached 44% in 2 days, and slowed very slow, and reached
after 45% after 3 more weeks :)

2. I found about e2image, and started using this in my thinking of a
faster fsck on a 64bit machine.
- # e4image -r /dev/sdb1 - | bzip2 -c > sdb1_e4image.bz2
- decompress with | cp --sparse=always /proc/self/fd/0 ...
- # e4fsck -v -y -f sdb1_e4image # (took only 2 days to complete)
   Now I found out that e2image/e4image -I does not work on raw
metadata images dump, I tried a hack for this:
- root [~/work/e2fsprogs-1.41.12/misc]# ./e2image sdb1_e4image
sdb1_e4image_normal
   Now I restored the normal image metadata backup made using the raw
image backup
- root [~/work/e2fsprogs-1.41.12/misc]# ./e2image -I /dev/sdb1
sdb1_e4image_normal

3. Trying to find back my data:
root [~/work/e2fsprogs-1.41.12/misc]# e4fsck -v -y /dev/sdb1
e4fsck 1.41.9 (22-Aug-2009)
e4fsck: Group descriptors look bad... trying backup blocks...
e4fsck: Bad magic number in super-block when using the backup blocks
e4fsck: going back to original superblock
e4fsck: Device or resource busy while trying to open /dev/sdb1
Filesystem mounted or opened exclusively by another program?

root [~/work/e2fsprogs-1.41.12/misc]# ../e2fsck/e2fsck -n -v /dev/sdb1
e2fsck 1.41.12 (17-May-2010)
../e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...
../e2fsck/e2fsck: Bad magic number in super-block when using the backup blocks
../e2fsck/e2fsck: going back to original superblock
../e2fsck/e2fsck: Device or resource busy while trying to open /dev/sdb1
Filesystem mounted or opened exclusively by another program?

root [~/work/e2fsprogs-1.41.12/misc]# ../e2fsck/e2fsck -n -v -b 0 /dev/sdb1
e2fsck 1.41.12 (17-May-2010)
Superblock has an invalid journal (inode 8).
Clear? no

../e2fsck/e2fsck: Illegal inode number while checking ext3 journal for /backup

I appreciate any help on recovering that drive data back.

Thanks.
