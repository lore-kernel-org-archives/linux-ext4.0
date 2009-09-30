From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Subject: [BUG] kernel BUG at fs/ext4/extents.c:2863
Date: Wed, 30 Sep 2009 12:42:46 +0530
Message-ID: <4AC304EE.5080009@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: rnsastry@linux.vnet.ibm.com,
	sachin p sant <sachinp@linux.vnet.ibm.com>,
	Ramon <rcvalle@linux.vnet.ibm.com>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	aneesh.kumar@in.ibm.com
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:48583 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZI3HMo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 03:12:44 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp04.au.ibm.com (8.14.3/8.13.1) with ESMTP id n8U79pdE010917
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 17:09:51 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8U7Ck4u1183830
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 17:12:46 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n8U7Cjk4020950
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 17:12:46 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

While working with fsfuzz encountered the following kernel stack traces.

Environment: 2.6.32-rc1 and 2.6.31 (kernel BUG at fs/ext4/extents.c:2833)
Architecture: s390


------------[ cut here ]------------
kernel BUG at fs/ext4/extents.c:2863!
illegal operation: 0001 [#1] SMP
Modules linked in: cbc md5 aes_s390 aes_generic ecb ecryptfs ext4 jbd2 
crc16 autofs4 lockd sunrpc ipv6 loop qeth_l2 qeth qdio vmur ccwgroup 
dm_round_robin dm_multipath scsi_dh sd_mod scsi_mod multipath 
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod dasd_fba_mod 
dasd_eckd_mod dasd_mod ext3 jbd
CPU: 0 Not tainted 2.6.32-rc2 #1
Process fstest (pid: 5755, task: 0000000024a48038, ksp: 0000000011afbe20)
Krnl PSW : 0704000180000000 000003e00200f3f4 
(ext4_ext_get_blocks+0x240/0x10cc [ext4])
            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
Krnl GPRS: 0000000000000000 0000000000000000 0000000000002400 
0000000000000000
            000000001416c000 000000000c8da000 000000002b539370 
0000000000000000
            000000002b5390f0 000000002b5390f0 0000000011afba90 
000000002b539040
            000003e001fe3000 000003e002023198 000003e00200f388 
0000000011afb6c8
Krnl Code: 000003e00200f3e8: a71100ff           tmll    %r1,255
            000003e00200f3ec: a7740006           brc     7,3e00200f3f8
            000003e00200f3f0: a7f40001           brc     15,3e00200f3f2
           >000003e00200f3f4: a7f40000           brc     15,3e00200f3f4
            000003e00200f3f8: e3b040100004       lg      %r11,16(%r4)
            000003e00200f3fe: b90200bb           ltgr    %r11,%r11
            000003e00200f402: a78404ea           brc     8,3e00200fdd6
            000003e00200f406: 5810b000           l       %r1,0(%r11)
Call Trace:
([<000003e00200f388>] ext4_ext_get_blocks+0x1d4/0x10cc [ext4])
  [<000003e001fed31e>] ext4_get_blocks+0xba/0x3c0 [ext4]
  [<000003e001fee9d8>] ext4_get_block+0xcc/0x114 [ext4]
  [<00000000001449ba>] do_mpage_readpage+0x1fa/0x688
  [<0000000000144f7a>] mpage_readpages+0xae/0x100
  [<00000000000d49f8>] __do_page_cache_readahead+0x160/0x1f4
  [<00000000000d4acc>] ra_submit+0x40/0x54
  [<00000000000d4f94>] page_cache_sync_readahead+0x40/0x50
  [<00000000000cc334>] generic_file_aio_read+0x284/0x6a4
  [<000000000010ed34>] do_sync_read+0xd0/0x118
  [<000000000010fad0>] vfs_read+0xa8/0x174
  [<000000000010fc92>] SyS_read+0x56/0x84
  [<0000000000027f5a>] sysc_tracego+0xe/0x14
  [<0000004e53f12cc4>] 0x4e53f12cc4
Last Breaking-Event-Address:
  [<000003e00200f3f0>] ext4_ext_get_blocks+0x23c/0x10cc [ext4]

---[ end trace 7a3a53bbf5dda9be ]---


    2858         /*
    2859          * consistent leaf must not be empty;
    2860          * this situation is possible, though, _during_ tree 
modification;
    2861          * this is why assert can't be put in 
ext4_ext_find_extent()
    2862          */
    2863         BUG_ON(path[depth].p_ext == NULL && depth != 0);
    2864         eh = path[depth].p_hdr;
    2865

Thank you
Regards
R.Nageswara Sastry

