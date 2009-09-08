From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Subject: [BUG] Badness at fs/ext4/inode.c:1121
Date: Tue, 08 Sep 2009 12:19:21 +0530
Message-ID: <4AA5FE71.7000006@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sachin p sant <sachinp@linux.vnet.ibm.com>,
	Ramon <rcvalle@linux.vnet.ibm.com>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:60554 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZIHGtc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 02:49:32 -0400
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp02.in.ibm.com (8.14.3/8.13.1) with ESMTP id n886nVoq009159
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 12:19:31 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n886nVt1598206
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 12:19:31 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n886nVwJ001091
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 16:49:31 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

While working with fsfuzz encountered the following kernel stack traces.

Environment: 2.6.31-rc9
Architecture: s390

------------[ cut here ]------------
Badness at fs/ext4/inode.c:1121
Modules linked in: cbc md5 aes_s390 aes_generic ecb ecryptfs ext4 jbd2 crc16
loop autofs4 lockd sunrpc ipv6 qeth_l2 vmur qeth qdio ccwgroup 
dm_round_robin
dm_multipath scsi_dh sd_mod scsi_mod multipath dm_snapshot dm_zero dm_mirror
dm_region_hash dm_log dm_mod dasd_fba_mod dasd_eckd_mod dasd_mod ext3 jbd
CPU: 1 Not tainted 2.6.31-rc9 #1
Process mount (pid: 3553, task: 0000000039e5f038, ksp: 000000002ef5f3a0)
Krnl PSW : 0704000180000000 000003e0035d9980 (check_block_validity+0x84/0x9c
[ext4])
            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
Krnl GPRS: 000000000001ff1c 000000003ca15000 0000000000000000 
0000000000000000
            000003e0035d997c 0000000000000000 000000000000006d 
0000000000000000
            0000000000000000 000000000000f2b2 0000000000000001 
000000002dcd70f0
            000003e0035d2000 000003e00360dc58 000003e0035d997c 
000000002ef5f6b8
Krnl Code: 000003e0035d9970: e320b1080004       lg      %r2,264(%r11)
            000003e0035d9976: c0e500007ec7       brasl   %r14,3e0035e9704
            000003e0035d997c: a7f40001           brc     15,3e0035d997e
           >000003e0035d9980: a728fffb           lhi     %r2,-5
            000003e0035d9984: b9140022           lgfr    %r2,%r2
            000003e0035d9988: e340f0f00004       lg      %r4,240(%r15)
            000003e0035d998e: eb6ff0b00004       lmg     %r6,%r15,176(%r15)
            000003e0035d9994: 07f4               bcr     15,%r4
Call Trace:
([<000003e0035d997c>] check_block_validity+0x80/0x9c [ext4])
  [<000003e0035dbe96>] ext4_get_blocks+0x10e/0x374 [ext4]
  [<000003e0035dd964>] ext4_get_block+0xcc/0x114 [ext4]
  [<000000000011847a>] generic_block_bmap+0x5a/0x70
  [<000003e002d0af80>] jbd2_journal_bmap+0x44/0xa8 [jbd2]
  [<000003e002d05114>] jread+0x128/0x27c [jbd2]
  [<000003e002d05330>] do_one_pass+0xc8/0x7f8 [jbd2]
  [<000003e002d05b3e>] jbd2_journal_recover+0x5a/0x104 [jbd2]
  [<000003e002d0b1ae>] jbd2_journal_load+0x76/0x1bc [jbd2]
  [<000003e0035f4272>] ext4_fill_super+0x1db6/0x2908 [ext4]
  [<00000000000f470e>] get_sb_bdev+0x13e/0x19c
  [<000003e0035e830e>] ext4_get_sb+0x2e/0x40 [ext4]
  [<00000000000f3fb4>] vfs_kern_mount+0xc0/0x168
  [<00000000000f40c8>] do_kern_mount+0x58/0x114
  [<000000000010e5c8>] do_mount+0x798/0x830
  [<000000000010e710>] SyS_mount+0xb0/0x100
  [<00000000000266fe>] sysc_noemu+0x10/0x16
  [<0000004e53f234e2>] 0x4e53f234e2
Last Breaking-Event-Address:
  [<000003e0035d997c>] check_block_validity+0x80/0x9c [ext4]


Same bug with different call trace:

------------[ cut here ]------------
Badness at fs/ext4/inode.c:1121
Modules linked in: md5 cbc aes_s390 aes_generic ecb ecryptfs ext4 jbd2 crc16
loop autofs4 lockd sunrpc ipv6 qeth_l2 vmur qeth qdio ccwgroup 
dm_round_robin
dm_multipath scsi
_dh sd_mod scsi_mod multipath dm_snapshot dm_zero dm_mirror dm_region_hash
dm_log dm_mod dasd_fba_mod dasd_eckd_mod dasd_mod ext3 jbd
CPU: 0 Tainted: G        W  2.6.31-rc9 #1
Process fstest (pid: 4219, task: 000000003e8ac038, ksp: 000000003dca2f28)
Krnl PSW : 0704000180000000 000003e0035f0980 (check_block_validity+0x84/0x9c
[ext4])
            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
Krnl GPRS: 0000000000007acd 000000003efe2400 0000000000000000 
0000000000000000
            000003e0035f097c 0000000000000000 000000000000002c 
0000000000000000
            0000000000000000 0000000000fb051c 0000000000000001 
000000003167e478
            000003e0035e9000 000003e003624c58 000003e0035f097c 
000000003dca3240
Krnl Code: 000003e0035f0970: e320b1080004       lg      %r2,264(%r11)
            000003e0035f0976: c0e500007ec7       brasl   %r14,3e003600704
            000003e0035f097c: a7f40001           brc     15,3e0035f097e
           >000003e0035f0980: a728fffb           lhi     %r2,-5
            000003e0035f0984: b9140022           lgfr    %r2,%r2
            000003e0035f0988: e340f0f00004       lg      %r4,240(%r15)
            000003e0035f098e: eb6ff0b00004       lmg     %r6,%r15,176(%r15)
            000003e0035f0994: 07f4               bcr     15,%r4
Call Trace:
([<000003e0035f097c>] check_block_validity+0x80/0x9c [ext4])
  [<000003e0035f2e96>] ext4_get_blocks+0x10e/0x374 [ext4]
  [<000003e0035f4964>] ext4_get_block+0xcc/0x114 [ext4]
  [<0000000000124452>] do_mpage_readpage+0x1fa/0x688
  [<0000000000124a12>] mpage_readpages+0xae/0x100
  [<00000000000bede8>] __do_page_cache_readahead+0x160/0x1f4
  [<00000000000beebc>] ra_submit+0x40/0x54
  [<00000000000bf384>] page_cache_sync_readahead+0x40/0x50
  [<00000000000b6b68>] generic_file_aio_read+0x284/0x6a4
  [<00000000000f13cc>] do_sync_read+0xd0/0x118
  [<00000000000f2178>] vfs_read+0xa8/0x174
  [<000003e003ab2310>] ecryptfs_read_lower+0xb4/0x138 [ecryptfs]
  [<000003e003ab3f62>] ecryptfs_decrypt_page+0x136/0x460 [ecryptfs]
  [<000003e003ab1a6e>] ecryptfs_readpage+0xce/0x1c8 [ecryptfs]
  [<00000000000bee42>] __do_page_cache_readahead+0x1ba/0x1f4
  [<00000000000beebc>] ra_submit+0x40/0x54
  [<00000000000bf384>] page_cache_sync_readahead+0x40/0x50
  [<00000000000b6b68>] generic_file_aio_read+0x284/0x6a4
  [<000003e003aae3cc>] ecryptfs_read_update_atime+0x2c/0x78 [ecryptfs]
  [<00000000000f13cc>] do_sync_read+0xd0/0x118
  [<00000000000f2178>] vfs_read+0xa8/0x174
  [<00000000000f233a>] SyS_read+0x56/0x84
  [<00000000000266fe>] sysc_noemu+0x10/0x16
  [<0000004e53f12cc4>] 0x4e53f12cc4
Last Breaking-Event-Address:
  [<000003e0035f097c>] check_block_validity+0x80/0x9c [ext4]
EXT4-fs error (device loop0): check_block_validity: inode #21 logical 
block 44
mapped to 16450844 (size 1)


*P.S. If you need any information please let me know. Please cc me as I 
am not subscribed to the list.

Thanks and Regards
R.Nageswara Sastry

