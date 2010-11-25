From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: ext4 errors not going away after fsck
Date: Thu, 25 Nov 2010 15:57:57 +0100
Message-ID: <4CEE7975.10809@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:50787 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0KYO6B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Nov 2010 09:58:01 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 9386735A31A
	for <linux-ext4@vger.kernel.org>; Thu, 25 Nov 2010 15:57:58 +0100 (CET)
Received: from [192.168.10.145] (e183095092.adsl.alicedsl.de [85.183.95.92])
	by mail.virtall.com (Postfix) with ESMTPSA id 689C535A319
	for <linux-ext4@vger.kernel.org>; Thu, 25 Nov 2010 15:57:58 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have a system which had bad memory.

Bad memory was replaced, but filesystem corruption caused by it (and related crashes) is still there:

[104472.909769] EXT4-fs (vdb1): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[104773.600088] EXT4-fs (vdb1): error count: 2
[104773.600093] EXT4-fs (vdb1): initial error at 1290468286: htree_dirblock_to_tree:586: inode 30204507: block 120625971
[104773.600097] EXT4-fs (vdb1): last error at 1290468334: ext4_put_super:726: inode 30204507: block 120625971


Unfortunately, repeated fsck checks do not make the error go away (using 2.6.37-rc3 and e2fsprogs 1.41.12):

# e2fsck -f -v -y /dev/vdb1
e2fsck 1.41.12 (17-May-2010)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

16281559 inodes used (35.49%)
    4484 non-contiguous files (0.0%)
   29082 non-contiguous directories (0.2%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 16273127/8421
152806601 blocks used (83.27%)
       0 bad blocks
      27 large files

 7931312 regular files
 8350237 directories
       0 character device files
       0 block device files
       0 fifos
95162835 links
       0 symbolic links (0 fast symbolic links)
       1 socket
--------
111444385 files

# mount -a

# dmesg -c
[108692.626550] EXT4-fs (vdb1): mounted filesystem with ordered data mode. Opts: errors=remount-ro

# ls -lR /mount/point
(...)
# dmesg -c
[108993.760041] EXT4-fs (vdb1): error count: 2
[108993.760051] EXT4-fs (vdb1): initial error at 1290468286: htree_dirblock_to_tree:586: inode 30204507: block 120625971
[108993.760058] EXT4-fs (vdb1): last error at 1290468334: ext4_put_super:726: inode 30204507: block 120625971


The error is exactly the same as the first one I pasted (multiple umount, fsck, mount runs without reboot).


Is this all something to be worry about?


-- 
Tomasz Chmielewski
http://wpkg.org
