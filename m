From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] libext2fs: fix bad cast which causes problems for file systems > 512EB
Date: Tue,  4 Oct 2011 00:27:00 -0400
Message-ID: <1317702420-31085-2-git-send-email-tytso@mit.edu>
References: <20111004040033.GM6684@thunk.org>
 <1317702420-31085-1-git-send-email-tytso@mit.edu>
Cc: sandeen@sandeen.net, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47294 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab1JDE1H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 00:27:07 -0400
In-Reply-To: <1317702420-31085-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the number of block groups exceeds 2**32, a bad cast would lead to
a bogus "Not enough space to build proposed filesystem while setting
up superblock" failure.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/initialize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 2875f97..b050a0a 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -248,7 +248,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	}
 
 retry:
-	fs->group_desc_count = (blk_t) ext2fs_div64_ceil(
+	fs->group_desc_count = (dgrp_t) ext2fs_div64_ceil(
 		ext2fs_blocks_count(super) - super->s_first_data_block,
 		EXT2_BLOCKS_PER_GROUP(super));
 	if (fs->group_desc_count == 0) {
-- 
1.7.4.1.22.gec8e1.dirty

