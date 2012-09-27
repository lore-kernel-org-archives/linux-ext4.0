From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] ext4: convert to use leXX_add_cpu()
Date: Thu, 27 Sep 2012 16:00:15 +0800
Message-ID: <CAPgLHd-2+KkFZAHjU01Muuyqf_xkA4R6E9RF=c0Z1OMROmieGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32948 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2I0IAQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2012 04:00:16 -0400
Received: by vcbfo13 with SMTP id fo13so1727331vcb.19
        for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2012 01:00:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Convert cpu_to_leXX(leXX_to_cpu(E1) + E2) to use leXX_add_cpu().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ext4/super.c       | 2 +-
 fs/ext4/move_extent.c | 5 ++---
 fs/ext4/extents.c     | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c6e0cb3..f7041c8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -420,7 +420,7 @@ static void __save_error_info(struct super_block *sb, const char *func,
 	 */
 	if (!es->s_error_count)
 		mod_timer(&EXT4_SB(sb)->s_err_report, jiffies + 24*60*60*HZ);
-	es->s_error_count = cpu_to_le32(le32_to_cpu(es->s_error_count) + 1);
+	le32_add_cpu(&es->s_error_count, 1);
 }
 
 static void save_error_info(struct super_block *sb, const char *func,

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c5826c6..3a0fb98 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -604,9 +604,8 @@ mext_calc_swap_extents(struct ext4_extent *tmp_dext,
 	diff = donor_off - le32_to_cpu(tmp_dext->ee_block);
 
 	ext4_ext_store_pblock(tmp_dext, ext4_ext_pblock(tmp_dext) + diff);
-	tmp_dext->ee_block =
-			cpu_to_le32(le32_to_cpu(tmp_dext->ee_block) + diff);
-	tmp_dext->ee_len = cpu_to_le16(le16_to_cpu(tmp_dext->ee_len) - diff);
+	le32_add_cpu(&tmp_dext->ee_block, diff);
+	le16_add_cpu(&tmp_dext->ee_len, -diff);
 
 	if (max_count < ext4_ext_get_actual_len(tmp_dext))
 		tmp_dext->ee_len = cpu_to_le16(max_count);

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index aabbb3f..1744407 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1177,7 +1177,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 		  le32_to_cpu(EXT_FIRST_INDEX(neh)->ei_block),
 		  ext4_idx_pblock(EXT_FIRST_INDEX(neh)));
 
-	neh->eh_depth = cpu_to_le16(le16_to_cpu(neh->eh_depth) + 1);
+	le16_add_cpu(&neh->eh_depth, 1);
 	ext4_mark_inode_dirty(handle, inode);
 out:
 	brelse(bh);


