From: Angelo Dureghello <angelo70@gmail.com>
Subject: Re: ext4 errors on kernel 3.17.0
Date: Wed, 19 Nov 2014 14:09:32 +0100
Message-ID: <546C968C.60908@gmail.com>
References: <54663355.2080903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63591 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaKSNJg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Nov 2014 08:09:36 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so8821375wiv.2
        for <linux-ext4@vger.kernel.org>; Wed, 19 Nov 2014 05:09:35 -0800 (PST)
Received: from [192.168.0.2] (host15-234-dynamic.54-79-r.retail.telecomitalia.it. [79.54.234.15])
        by mx.google.com with ESMTPSA id ek9sm2150543wib.21.2014.11.19.05.09.33
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 19 Nov 2014 05:09:34 -0800 (PST)
In-Reply-To: <54663355.2080903@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

still fighting on this.

I am trying now with a simple mkfs.ext3 on the mmc card, verifying just 
after with
fsck.ext3.

On kernel 3.5.1 the fsck get a "clean" state, on 3.17.0 i am full of errors.

[root@barix ~]# fsck.ext3 /dev/mmcblk0p1
e2fsck 1.42.4 (12-June-2012)
ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
fsck.ext3: Group descriptors look bad... trying backup blocks...
Superblock has an invalid journal (inode 8).
Clear<y>? Automount: /dev/mmcblk0p1 inserted
Automount: DEVICE LOCK found quiting...
yes
*** ext3 journal has been deleted - filesystem is now ext2 only ***

/dev/mmcblk0p1 was not cleanly unmounted, check forced.
Resize inode not valid.  Recreate<y>? yes
Pass 1: Checking inodes, blocks, and sizes
The bad block inode looks invalid.  Clear<y>? yes
Root inode is not a directory.  Clear<y>? yes
Inode 5 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 6 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 8 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 9 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 10 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>?
.... (continue)


The card is detected correctly, exactly at the same way on both kernels

mmc0: host does not support reading read-only switch. assuming write-enable.
mmc0: new high speed SDHC card at address 0002
mmcblk0: mmc0:0002 SD 7.46 GiB
  mmcblk0: p1

But, mkfs.ext3 gives different output:

|kernel 3.5.1 |
||
|[root@barix ~]# mkfs.ext3 /dev/mmcblk0p1 |
|mke2fs 1.42.4 (12-June-2012) |
|Filesystem label= |
|OS type: Linux |
|Block size=4096 (||log||=2) |
|Fragment size=4096 (||log||=2) |
|Stride=0 blocks, Stripe width=0 blocks |
|488640 inodes, 1952881 blocks |
|97644 blocks (5.00%) reserved ||for||the super user |
|First data block=0 |
|Maximum filesystem blocks=2000683008 |
|60 block groups |
|32768 blocks per group, 32768 fragments per group |
|8144 inodes per group |
|Superblock backups stored on blocks: |
|||32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632 |
||
|Allocating group tables: done |
|Writing inode tables: done |
|Creating journal (32768 blocks): done |
|Writing superblocks and filesystem accounting information: done |
||
|kernel 3.17.0 |
||
|[root@barix ~]# mkfs.ext3 /dev/mmcblk0p1 |
|mke2fs 1.42.4 (12-June-2012) |
|Filesystem label= |
|OS type: Linux |
|Block size=4096 (||log||=2) |
|Fragment size=4096 (||log||=2) |
|Stride=0 blocks, Stripe width=0 blocks |
|240000 inodes, 959232 blocks |
|47961 blocks (5.00%) reserved ||for||the super user |
|First data block=0 |
|Maximum filesystem blocks=985661440 |
|30 block groups |
|32768 blocks per group, 32768 fragments per group |
|8000 inodes per group |
|Superblock backups stored on blocks: |
|||32768, 98304, 163840, 229376, 294912, 819200, 884736 |
||
|Allocating group tables: done |
|Writing inode tables: done |
|Creating journal (16384 blocks): done |
|Writing superblocks and filesystem accounting information: done


The recent 3.17.0 kernel shows
- about half of |||"Maximum filesystem blocks"
- |||8000 inodes per group instead of 8144 on 3.5.1
- about half of the inodes.

Could this be the reason of the mmc issues i am having ?

many thanks

|


