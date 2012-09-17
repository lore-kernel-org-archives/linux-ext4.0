From: Andrey Sidorov <qrxd43@motorola.com>
Subject: [PATCH RFC 1/2] ext4: speed-up truncate/unlink
Date: Tue, 18 Sep 2012 01:00:30 +0400
Message-ID: <CAA0+VHzw55=4X43GK9RkRK_q4qmzR8KyqrrFidQMCPb6r4nPeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:38284 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab2IQWEu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2012 18:04:50 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.176.130.20])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id q8HL2l9S002402
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 17:02:47 -0400 (EDT)
Received: from mail-qc0-f174.google.com (mail-qc0-f174.google.com [209.85.216.174])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id q8HL2klB002386
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 17:02:47 -0400 (EDT)
Received: by qcro28 with SMTP id o28so4854039qcr.19
        for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 14:00:31 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Do not iterate over data blocks scanning for bh's to forget as they're
never exist. This improves time taken by unlink / truncate syscall.
Tested by continuously truncating file that is being written by dd.
Another test is rm -rf of linux tree while tar unpacks it. With
ordered data mode condition unlikely(!tbh) was always met in
ext4_free_blocks. With journal data mode tbh was found only few times,
so optimisation is also possible.

Unlinking fallocated 60G file after doing sync && echo 3 >
/proc/sys/vm/drop_caches && time rm --help

X86 before (linux 3.6-rc4):
# time rm -f test1
real    0m2.710s
user    0m0.000s
sys     0m1.530s

X86 after:
# time rm -f test1
real    0m0.644s
user    0m0.003s
sys     0m0.060s

MIPS before (linux 2.6.37):
# time rm -f test1
real    0m 4.93s
user    0m 0.00s
sys     0m 4.61s

MIPS after:
# time rm -f test1
real    0m 0.16s
user    0m 0.00s
sys     0m 0.06s

---
 fs/ext4/extents.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-3.6-rc6/fs/ext4/extents.c
===================================================================
--- linux-3.6-rc6.orig/fs/ext4/extents.c	2012-09-17 12:08:48.842901966 -0400
+++ linux-3.6-rc6/fs/ext4/extents.c	2012-09-17 12:09:43.403630792 -0400
@@ -2274,10 +2274,13 @@ static int ext4_remove_blocks(handle_t *
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	unsigned short ee_len =  ext4_ext_get_actual_len(ex);
 	ext4_fsblk_t pblk;
-	int flags = EXT4_FREE_BLOCKS_FORGET;
+	int flags = 0;

 	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
-		flags |= EXT4_FREE_BLOCKS_METADATA;
+		flags |= EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET;
+	else if (ext4_should_journal_data(inode))
+		flags |= EXT4_FREE_BLOCKS_FORGET;
+
 	/*
 	 * For bigalloc file systems, we never free a partial cluster
 	 * at the beginning of the extent.  Instead, we make a note
