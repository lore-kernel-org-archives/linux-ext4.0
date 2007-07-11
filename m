From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: Ext3 onlie resize failure due to small journal size
Date: Thu, 12 Jul 2007 01:17:49 +0530
Message-ID: <1184183271.3931.13.camel@garfield>
References: <4694E279.1060107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: adilger@clusterfs.com, aneesh.kumar@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org, Amit K Arora <amitarora@in.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>
To: Suzuki <suzuki@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:48177 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbXGKTrX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 15:47:23 -0400
In-Reply-To: <4694E279.1060107@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-07-11 at 19:30 +0530, Suzuki wrote:
> Hi Andreas,
> 
> Trying to resize a mounted ext3 filesystem fails due to small journal size.

A similar problem was discussed in an earlier thread "JBD: ext2online
wants too many credits (744 > 256)". The problem here is that the
maximum allowed transaction size is 4MB while a bigger transaction is
required to resize the filesystem.

In your case, you can delete the journal using "tune2fs -O ^has_journal
<dev>" and add a bigger journal "tune2fs -J size=16M <dev>". I think
this will solve your problem.

Thanks,
Kalpak.

> 
> Background :
> 
> The filesystem was created with default values, except blocksize = 4K on 
> a LV partition. Later we tried extended the partition to +16M and tried 
> to resize the fs using resize2fs, while it was mounted.
> 
> [root@llm47 ~]# resize2fs  /dev/mapper/testvg-tmp
> resize2fs 1.39 (29-May-2006)
> Filesystem at /dev/mapper/testvg-tmp is mounted on /tmp; on-line 
> resizing required
> Performing an on-line resize of /dev/mapper/testvg-tmp to 186368 (4k) 
> blocks.
> resize2fs: No space left on device While trying to add group #4
> 
> Analysis :
> 
> While adding the new blockgroup, inside setup_new_group_blocks() we hit 
> the limit because we are requesting for a a credit value of 2 + 
> sbi->s_itb_per_group which in the case of the file system below is 1026 
> while the max_transaction credits possible is 1024 for the fs.
> 
> journal->j_maxlen = inode->i_size / blocksize = 16M/4K = 4K
> 
> journal->j_max_transaction_buffers = journal->j_maxlen / 4 = 1K
> 
> journal->j_max_transaction_buffers = 1024.
> 
> 
> 
> 
> # dumpe2fs  /dev/mapper/testvg-tmp
> dumpe2fs 1.39 (29-May-2006)
> Filesystem volume name:   <none>
> Last mounted on:          <not available>
> Filesystem UUID:          7d82f07b-cb22-4c7d-b290-a35749121bbb
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal resize_inode dir_index filetype 
> needs_recovery sparse_super large_file
> Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              131072
> Block count:              131072
> Reserved block count:     6553
> Free blocks:              122753
> Free inodes:              131056
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      31
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         32768
> Inode blocks per group:   1024
> Filesystem created:       Mon Jul  9 00:09:23 2007
> Last mount time:          Tue Jul 10 02:44:44 2007
> Last write time:          Tue Jul 10 02:44:44 2007
> Mount count:              7
> Maximum mount count:      33
> Last checked:             Mon Jul  9 00:09:23 2007
> Check interval:           15552000 (6 months)
> Next check after:         Sat Jan  5 00:09:23 2008
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               128
> Journal inode:            8
> Default directory hash:   tea
> Directory Hash Seed:      0a57077d-9778-4f3a-8605-7f0c86f18d8a
> Journal backup:           inode blocks
> Journal size:             16M
> 
> 
> Group 0: (Blocks 0-32767)
> 	Primary superblock at 0, Group descriptors at 1-1
> 	Reserved GDT blocks at 2-32
> 	Block bitmap at 33 (+33), Inode bitmap at 34 (+34)
> 	Inode table at 35-1058 (+35)
> 	27600 free blocks, 32755 free inodes, 2 directories
> 	Free blocks: 5168-32767
> 	Free inodes: 14-32768
> Group 1: (Blocks 32768-65535)
> 	Backup superblock at 32768, Group descriptors at 32769-32769
> 	Reserved GDT blocks at 32770-32800
> 	Block bitmap at 32801 (+33), Inode bitmap at 32802 (+34)
> 	Inode table at 32803-33826 (+35)
> 	31708 free blocks, 32767 free inodes, 1 directories
> 	Free blocks: 33828-65535
> 	Free inodes: 32770-65536
> Group 2: (Blocks 65536-98303)
> 	Block bitmap at 65536 (+0), Inode bitmap at 65537 (+1)
> 	Inode table at 65538-66561 (+2)
> 	31740 free blocks, 32764 free inodes, 2 directories
> 	Free blocks: 66562-83967, 83969-94207, 94209-98303
> 	Free inodes: 65541-98304
> Group 3: (Blocks 98304-131071)
> 	Backup superblock at 98304, Group descriptors at 98305-98305
> 	Reserved GDT blocks at 98306-98336
> 	Block bitmap at 98337 (+33), Inode bitmap at 98338 (+34)
> 	Inode table at 98339-99362 (+35)
> 	31704 free blocks, 32766 free inodes, 1 directories
> 	Free blocks: 99363-126976, 126982-131071
> 	Free inodes: 98305, 98308-131072
> 
> 
> 
> Is this a supported operation ? If yes, what could be the best way to 
> fix it ?
> 
> Resizing the journal is not supported at the moment :(.
> 
> Thoughts ?
> 
> Thanks
> 
> Suzuki
> IBM Linux Technology Centre
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
