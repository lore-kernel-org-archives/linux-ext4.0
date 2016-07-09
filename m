From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: BUG: failure at fs/ext4/mballoc.c:3214/ext4_mb_normalize_request()!
Date: Sat, 9 Jul 2016 13:12:34 +0200
Message-ID: <5780DC22.7060405@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33207 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbcGILMl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Jul 2016 07:12:41 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u69BCdYc032333
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sat, 9 Jul 2016 11:12:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u69BCdGB031287
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sat, 9 Jul 2016 11:12:39 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u69BCc1n007048
	for <linux-ext4@vger.kernel.org>; Sat, 9 Jul 2016 11:12:39 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

While fuzzing ext4 with AFL I've run into this crash:

BUG: failure at fs/ext4/mballoc.c:3214/ext4_mb_normalize_request()!
Kernel panic - not syncing: BUG!
CPU: 0 PID: 50 Comm: ext4.exe Not tainted 4.7.0-rc5+ #577
Stack:
  604a8947 00000043 02400050 60078643
  601cbcf0 61e3c800 61e237b0 601bfb3c
  61e238d0 60077d0e 61e23af0 61e3c800
Call Trace:
  [<6001c2dc>] show_stack+0xdc/0x1a0
  [<601bfb3c>] dump_stack+0x2a/0x2e
  [<60077d0e>] panic+0x15c/0x310
  [<601492ba>] ext4_mb_normalize_request+0x55a/0x7c0
  [<601508d4>] ext4_mb_new_blocks+0x5f4/0x970
  [<6014375e>] ext4_ext_map_blocks+0x131e/0x1bb0
  [<6011b815>] ext4_map_blocks+0x135/0x780
  [<6011fc53>] ext4_writepages+0x6d3/0xdd0
  [<6008626c>] do_writepages+0x1c/0x40
  [<60078eec>] __filemap_fdatawrite_range+0x7c/0xb0
  [<6007968c>] filemap_write_and_wait_range+0x2c/0x80
  [<601150db>] ext4_sync_file+0x6b/0x330
  [<600e9dbc>] vfs_fsync_range+0x3c/0xd0
  [<600e9e96>] do_fsync+0x46/0x80
  [<600e9f25>] SyS_fdatasync+0x15/0x20

This is:

         BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));

The problem is that size == 64 and EXT_BLOCKS_PER_GROUP() == 6.

The size of 64 comes from the call to i_size_read() which returns
0x10000 -- the filesystem block size is 1024: 64 << 10 == 0x10000.

I'm wondering what the best way to fix this is. I'm tempted to just do
something like this, limiting the size to not cross a block group boundary:

@@ -3185,7 +3211,9 @@ ext4_mb_normalize_request(struct 
ext4_allocation_context *ac,
                          (unsigned long) ac->ac_o_ex.fe_logical);
                 BUG();
         }
-       BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+       BUG_ON(size <= 0);
+       if (start + size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb))
+               size = EXT4_BLOCKS_PER_GROUP(ac->ac_sb) - start;

         /* now prepare goal request */

That incidentally does seem to fix the problem, but I'm a bit scared
that I'm just papering over some underlying bug since I can't say I
fully understand whether any of the other code is supposed to prevent
this condition in the first place.

The problem is easy to reproduce so I can add debugging printks or test
patches or whatever.

If the hunk above seems reasonable I can submit a proper patch.


Vegard
