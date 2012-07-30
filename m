From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/7] libext2fs: remove debugging printf from ext2fs_group_desc_csum
Date: Mon, 30 Jul 2012 17:47:41 -0400
Message-ID: <1343684862-13181-6-git-send-email-tytso@mit.edu>
References: <20120628024356.GB17989@thor.bakeyournoodle.com>
 <1343684862-13181-1-git-send-email-tytso@mit.edu>
Cc: tony@bakeyournoodle.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42154 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab2G3Vzw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 17:55:52 -0400
In-Reply-To: <1343684862-13181-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This reduces the number of C library symbols needed by boot loader
systems such as yaboot.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/csum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 9fa3f24..aefa762 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -40,7 +40,7 @@ __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 	if (size < EXT2_MIN_DESC_SIZE)
 		size = EXT2_MIN_DESC_SIZE;
 	if (size > sizeof(struct ext4_group_desc)) {
-		printf("%s: illegal s_desc_size(%zd)\n", __func__, size);
+		/* This should never happen, but cap it for safety's sake */
 		size = sizeof(struct ext4_group_desc);
 	}
 
-- 
1.7.12.rc0.22.gcdd159b

