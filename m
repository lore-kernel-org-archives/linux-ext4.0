Return-Path: <SRS0=5bfQ=YL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC34ECA9EA0
	for <linux-ext4@archiver.kernel.org>; Fri, 18 Oct 2019 12:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF7E20854
	for <linux-ext4@archiver.kernel.org>; Fri, 18 Oct 2019 12:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfJRMvF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 18 Oct 2019 08:51:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:40366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726875AbfJRMvE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 18 Oct 2019 08:51:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5AE07B3B6;
        Fri, 18 Oct 2019 12:51:03 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id ED5CA1E4851; Fri, 18 Oct 2019 14:51:02 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] resize2fs: Make minimum size estimates more reliable for mounted fs
Date:   Fri, 18 Oct 2019 14:50:59 +0200
Message-Id: <20191018125059.2446-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Currently, the estimate of minimum filesystem size is using free blocks
counter in the superblock. The counter generally doesn't get updated
while the filesystem is mounted and thus the estimate is very unreliable
for a mounted filesystem. For some usecases such as automated
partitioning proposal to the user it is desirable that the estimate of
minimum filesystem size is reasonably accurate even for a mounted
filesystem. So use group descriptor counters of free blocks for the
estimate of minimum filesystem size. These get updated together with
block being allocated and so the resulting estimate is more accurate.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 resize/resize2fs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index c2e10471bfd1..8a3d08db19f3 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2926,11 +2926,11 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 			fs->super->s_reserved_gdt_blocks;
 
 	/* calculate how many blocks are needed for data */
-	data_needed = ext2fs_blocks_count(fs->super) -
-		ext2fs_free_blocks_count(fs->super);
-
-	for (grp = 0; grp < fs->group_desc_count; grp++)
+	data_needed = ext2fs_blocks_count(fs->super);
+	for (grp = 0; grp < fs->group_desc_count; grp++) {
 		data_needed -= calc_group_overhead(fs, grp, old_desc_blocks);
+		data_needed -= ext2fs_bg_free_blocks_count(fs, grp);
+	}
 #ifdef RESIZE2FS_DEBUG
 	if (flags & RESIZE_DEBUG_MIN_CALC)
 		printf("fs requires %llu data blocks.\n", data_needed);
-- 
2.16.4

