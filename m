From: Andrey Sidorov <qrxd43@motorola.com>
Subject: [PATCH 0/5] mke2fs/e2fsck optimizations
Date: Tue, 19 Mar 2013 20:05:59 +0400
Message-ID: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:35592 "EHLO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3CSQG0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 12:06:26 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.22.94.168])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2JG9Hqs027456
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 12:09:17 -0400 (EDT)
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com [74.125.83.53])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2JG8w0X027270
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 12:09:16 -0400 (EDT)
Received: by mail-ee0-f53.google.com with SMTP id e53so337619eek.40
        for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 09:06:18 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Various optimizations for mke2fs / e2fsck.
First patch makes no big change for x86, but saves a
couple of seconds on embedded systems. Mostly effective
for large non-bigalloc volumes.
The rest of the series is to improve mke2fs time on
bigalloc volumes.

Times for mke2fs of 1TB volume
x86, plain: 7.5s -> 7.0s
x86, bigalloc256: 6.5s -> 1.9s
mips, plain: 9.9s -> 5.7s
mips, bigalloc256: 29.0s -> 1.9s

Testing done:
patched mke2fs, unpatched e2fsck, patched e2fsck,
mount, basic write operations, unmount,
unpatched e2fsck, patched e2fsck.
ffs/ffz were tested with tst_bitmaps commands which
cover all exit paths for rb_tree implementation.
Output of tst_bitmaps is same for ba and rb bitmaps.

Andrey Sidorov (5):
  libext2fs: Optimize ext2fs_allocate_group_table()
  libext2fs: find_first_set() for bitmaps.
  libext2fs: find_first_set() for bitarray bitmap
  libext2fs: ffz/ffs for rb_tree bitmap
  libext2fs: Optimize ext2fs_convert_subcluster_bitmap()

 lib/ext2fs/alloc_tables.c     |   31 +++++---
 lib/ext2fs/bitops.h           |   41 +++++++++++
 lib/ext2fs/blkmap64_ba.c      |   83 +++++++++++++++++++--
 lib/ext2fs/blkmap64_rb.c      |  164 +++++++++++++++++++++++++++++++++++++++--
 lib/ext2fs/bmap64.h           |    4 +-
 lib/ext2fs/ext2fs.h           |    3 +
 lib/ext2fs/gen_bitmap.c       |   23 ++++++
 lib/ext2fs/gen_bitmap64.c     |  118 +++++++++++++++++++++++------
 lib/ext2fs/tst_bitmaps.c      |   66 +++++++++++++++++
 lib/ext2fs/tst_bitmaps_cmd.ct |    6 ++
 10 files changed, 492 insertions(+), 47 deletions(-)

-- 
1.7.10.4

