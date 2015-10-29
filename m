From: Chris Hunter <chris.hunter@yale.edu>
Subject: errors following e2fsck + enable quota
Date: Thu, 29 Oct 2015 01:35:39 -0400
Message-ID: <5631B02B.2060404@yale.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.yale.edu ([130.132.50.187]:53441 "EHLO
	vm-emlprdomg-08.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756629AbbJ2GcQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Oct 2015 02:32:16 -0400
Received: from localhost.localdomain ([172.28.220.52])
	(authenticated bits=0)
	by vm-emlprdomg-08.its.yale.edu (8.15.0.59/8.14.7) with ESMTPSA id t9T5Zdse000818
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2015 01:35:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have lustre ext4 filesystem where I encountered issues when using 
"e2fsck -D" followed by enabling quota feature via "tune2fs -O quota".

Before I started, I unmounted the filesystem and verified e2fsck 
reported no errors. Then I ran this sequence of commands:
1. read-only fsck (e2fsck -nfv <BLKDEV>)
2. read-write fsck (e2fsck -yDfv <BLKDEV>)
3. clear quota bit in superblock (tune2fs -O^quota <BLKDEV>)
4. enable quota bit (tune2fs -O quota <BLKDEV>)
5. read-only fsck (e2fsck -nfv <BLKDEV>)

Steps 1-4 did not produce any errors. At #5 the read-only fsck reported 
directory entry errors eg)

> e2fsck 1.42.12.wc1 (15-Sep-2014)
> MMP interval is 7 seconds and total wait time is 30 seconds. Please wait...
> Pass 1: Checking inodes, blocks, and sizes
> Inode 79691783, end of extent exceeds allowed value
>         (logical block 1405, physical block 2550170101, len 714)
> Clear? no
>
> Inode 79691783, end of extent exceeds allowed value
>         (logical block 2119, physical block 2550376976, len 4294967141)
> Clear? no
>
> Inode 79691783, i_size is 8044544, should be 5754880.  Fix? no
>
> Inode 79691783, i_blocks is 15768, should be 11280.  Fix? no
...

> Pass 2: Checking directory structure
> Problem in HTREE directory inode 79691783 (/O/0/d3): bad block number 1960.
> Clear HTree index? no
>
> Problem in HTREE directory inode 79691783 (/O/0/d3): bad block number 1961.
> Clear HTree index? no
>
> Problem in HTREE directory inode 79691783 (/O/0/d3): bad block number 1962.
> Clear HTree index? no
 >
> Problem in HTREE directory inode 79691783 (/O/0/d3): bad block number 1963.
> Clear HTree index? no
....
> Problem in HTREE directory inode 79691783: block #1 has invalid depth (2)
> Problem in HTREE directory inode 79691783: block #1 has bad max hash
> Problem in HTREE directory inode 79691783: block #1 not referenced
> Problem in HTREE directory inode 79691783: block #2 has invalid depth (2)
> Problem in HTREE directory inode 79691783: block #2 has bad max hash
> Problem in HTREE directory inode 79691783: block #2 not referenced
> Problem in HTREE directory inode 79691783: block #3 has invalid depth (2)
> Problem in HTREE directory inode 79691783: block #3 has bad max hash
> Problem in HTREE directory inode 79691783: block #3 not referenced
...
> Problem in HTREE directory inode 79691783: block #1404 has invalid depth (2)
> Problem in HTREE directory inode 79691783: block #1404 has bad max hash
> Problem in HTREE directory inode 79691783: block #1404 not referenced
> Invalid HTREE directory inode 79691783 (/O/0/d3).  Clear HTree index? no
...

> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Unattached inode 129
> Connect to /lost+found? no
...
> Unattached zero-length inode 1049063.  Clear? no
>
> Unattached inode 1049063
> Connect to /lost+found? no

The filesystem was created using mkfs.lustre wrapper that ran command:
> mkfs_cmd = mke2fs -j -b 4096 -L scratch-OST0044 -m1 -i 131072 -J
> size=400 -I 256 -q -O
> extents,uninit_bg,mmp,dir_nlink,huge_file,flex_bg -G 256 -E
> resize=4290772992,lazy_journal_init -F /dev/mapper/ost_scratch_68
> 3823108096

Perhaps this is caused by a hardware problem; I ran this command 
sequence on 20 lustre ext-formatted block devices (using same storage 
backend) and only 12 had e2fsck errors.

Perhaps the combination of the e2fck -D option followed by enabling the 
quota feature corrupted the directory tree.

I think running "e2fsck -D" a 2nd time will clear some of the directory 
errors but won't resolve the "bad block number" errors.

chris hunter
chris.hunter@yale.edu

