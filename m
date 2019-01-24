Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B04C41518
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 16:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5289E218AE
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 16:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfAXQ0N (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:26:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:37328 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727649AbfAXQ0N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Jan 2019 11:26:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 66266ABCB;
        Thu, 24 Jan 2019 16:26:12 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id C66D91E0880; Thu, 24 Jan 2019 17:26:11 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] ext4: Fix crash during online resizing
Date:   Thu, 24 Jan 2019 17:26:06 +0100
Message-Id: <20190124162606.9686-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When computing maximum size of filesystem possible with given number of
group descriptor blocks, we forget to include s_first_data_block into
the number of blocks. Thus for filesystems with non-zero
s_first_data_block it can happen that computed maximum filesystem size
is actually lower than current filesystem size which confuses the code
and eventually leads to a BUG_ON in ext4_alloc_group_tables() hitting on
flex_gd->count == 0. The problem can be reproduced like:

truncate -s 100g /tmp/image
mkfs.ext4 -b 1024 -E resize=262144 /tmp/image 32768
mount -t ext4 -o loop /tmp/image /mnt
resize2fs /dev/loop0 262145
resize2fs /dev/loop0 300000

Fix the problem by properly including s_first_data_block into the
computed number of filesystem blocks.

CC: stable@vger.kernel.org
Fixes: 1c6bd7173d66 "ext4: convert file system to meta_bg if needed..."
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/resize.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 48421de803b7..3d9b18505c0c 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1960,7 +1960,8 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 				le16_to_cpu(es->s_reserved_gdt_blocks);
 			n_group = n_desc_blocks * EXT4_DESC_PER_BLOCK(sb);
 			n_blocks_count = (ext4_fsblk_t)n_group *
-				EXT4_BLOCKS_PER_GROUP(sb);
+				EXT4_BLOCKS_PER_GROUP(sb) +
+				le32_to_cpu(es->s_first_data_block);
 			n_group--; /* set to last group number */
 		}
 
-- 
2.16.4

