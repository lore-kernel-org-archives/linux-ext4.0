From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v2 2/2] fs/ext4: ext4_mb_init(): silence UBSAN
Date: Sat, 19 Mar 2016 22:12:05 +0100
Message-ID: <1458421925-5481-3-git-send-email-nicstange@gmail.com>
References: <1458421925-5481-1-git-send-email-nicstange@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicolai Stange <nicstange@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33381 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbcCSVMX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Mar 2016 17:12:23 -0400
In-Reply-To: <1458421925-5481-1-git-send-email-nicstange@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, in ext4_mb_init(), there's a loop like the following:

  do {
    ...
    offset += 1 << (sb->s_blocksize_bits - i);
    i++;
  } while (i <= sb->s_blocksize_bits + 1);

Note that the updated offset is used in the loop's next iteration only.

However, at the last iteration, that is at i == sb->s_blocksize_bits + 1,
the shift count becomes equal to (unsigned)-1 > 31 (c.f. C99 6.5.7(3))
and UBSAN reports

  UBSAN: Undefined behaviour in fs/ext4/mballoc.c:2621:15
  shift exponent 4294967295 is too large for 32-bit type 'int'
  [...]
  Call Trace:
   [<ffffffff818c4d25>] dump_stack+0xbc/0x117
   [<ffffffff818c4c69>] ? _atomic_dec_and_lock+0x169/0x169
   [<ffffffff819411ab>] ubsan_epilogue+0xd/0x4e
   [<ffffffff81941cac>] __ubsan_handle_shift_out_of_bounds+0x1fb/0x254
   [<ffffffff81941ab1>] ? __ubsan_handle_load_invalid_value+0x158/0x158
   [<ffffffff814b6dc1>] ? kmem_cache_alloc+0x101/0x390
   [<ffffffff816fc13b>] ? ext4_mb_init+0x13b/0xfd0
   [<ffffffff814293c7>] ? create_cache+0x57/0x1f0
   [<ffffffff8142948a>] ? create_cache+0x11a/0x1f0
   [<ffffffff821c2168>] ? mutex_lock+0x38/0x60
   [<ffffffff821c23ab>] ? mutex_unlock+0x1b/0x50
   [<ffffffff814c26ab>] ? put_online_mems+0x5b/0xc0
   [<ffffffff81429677>] ? kmem_cache_create+0x117/0x2c0
   [<ffffffff816fcc49>] ext4_mb_init+0xc49/0xfd0
   [...]

Observe that the mentioned shift exponent, 4294967295, equals (unsigned)-1.

Unless compilers start to do some fancy transformations (which at least
GCC 6.0.0 doesn't currently do), the issue is of cosmetic nature only: the
such calculated value of offset is never used again.

Silence UBSAN by introducing another variable, offset_incr, holding the
next increment to apply to offset and adjust that one by right shifting it
by one position per loop iteration.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 fs/ext4/mballoc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4bc89fe..8dc0d9b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2585,7 +2585,7 @@ int ext4_mb_init(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned i, j;
-	unsigned offset;
+	unsigned offset, offset_incr;
 	unsigned max;
 	int ret;
 
@@ -2614,11 +2614,13 @@ int ext4_mb_init(struct super_block *sb)
 
 	i = 1;
 	offset = 0;
+	offset_incr = 1 << (sb->s_blocksize_bits - 1);
 	max = sb->s_blocksize << 2;
 	do {
 		sbi->s_mb_offsets[i] = offset;
 		sbi->s_mb_maxs[i] = max;
-		offset += 1 << (sb->s_blocksize_bits - i);
+		offset += offset_incr;
+		offset_incr = offset_incr >> 1;
 		max = max >> 1;
 		i++;
 	} while (i <= sb->s_blocksize_bits + 1);
-- 
2.7.3

