From: Chris Hunter <chris.hunter@yale.edu>
Subject: errors following ext3 to ext4 conversion
Date: Wed, 26 Aug 2015 20:53:13 -0400
Message-ID: <55DE5F79.4010004@yale.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vm-emlprdomg-08.its.yale.edu ([130.132.50.187]:34798 "EHLO
	vm-emlprdomg-08.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbbH0B3E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 21:29:04 -0400
Received: from localhost.localdomain ([172.24.52.142])
	(authenticated bits=0)
	by vm-emlprdomg-08.its.yale.edu (8.15.0.59/8.14.7) with ESMTPSA id t7R0rDDj029141
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2015 20:53:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I attempted to convert ext3 to  ext4 filesystem. I am using e2fsprogs 
(1.42.12.wc1 (15-Sep-2014)). I ran command tune2fs tune2fs -O 
extents,uninit_bg,dir_index /dev/DEV -o acl,user_xattr /dev/DEV.
I then encountered errors (below) when running read-only e2fsck. I have 
not mounted the filesystem.
Is it possible to backout the ext3/ext4 changes ?
Do tune2fs changes take effect immediately or next time filesystem is 
mounted?


e2fsck shows a variety of errors:
Pass 1: Checking inodes, blocks, and sizes
Inode 118843400, end of extent exceeds allowed value
         (logical block 1409, physical block 3803034390, len 976)
Inode 118843400, end of extent exceeds allowed value
         (logical block 2385, physical block 3803056554, len 4294966945)
Inode 118843400, i_size is 8331264, should be 5771264.  Fix? no
Inode 118843400, i_blocks is 16328, should be 11312.  Fix? no
(...)

Pass 2: Checking directory structure
Problem in HTREE directory inode 118843400 (/O/0/d0): bad block number 2030.
Problem in HTREE directory inode 118843400 (/O/0/d0): bad block number 2031.
Problem in HTREE directory inode 118843400 (/O/0/d0): bad block number 2032.
Problem in HTREE directory inode 118843400 (/O/0/d0): bad block number 2033.

Pass 4: Checking reference counts
Unattached inode 26
Unattached inode 27
Unattached inode 28

regards,
chris hunter
chris.hunter@yale.edu
