From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] ext4: Update s_free_{inodes,blocks}_count during online
	resize
Date: Tue, 6 Mar 2012 11:40:20 -0800
Message-ID: <20120306194020.GI15164@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56028 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab2CFTkq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 14:40:46 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 14:40:45 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're doing an online resize of an ext4 filesystem, we need to update the
free inode and block counts in the superblock so that fsck doesn't complain.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/resize.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f9d948f..a97ede4 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1163,8 +1163,11 @@ static void ext4_update_super(struct super_block *sb,
 	do_div(reserved_blocks, 100);
 
 	ext4_blocks_count_set(es, ext4_blocks_count(es) + blocks_count);
+	ext4_free_blocks_count_set(es, ext4_free_blocks_count(es) + free_blocks);
 	le32_add_cpu(&es->s_inodes_count, EXT4_INODES_PER_GROUP(sb) *
 		     flex_gd->count);
+	le32_add_cpu(&es->s_free_inodes_count, EXT4_INODES_PER_GROUP(sb) *
+		     flex_gd->count);
 
 	/*
 	 * We need to protect s_groups_count against other CPUs seeing
@@ -1465,6 +1468,7 @@ static int ext4_group_extend_no_check(struct super_block *sb,
 	}
 
 	ext4_blocks_count_set(es, o_blocks_count + add);
+	ext4_free_blocks_count_set(es, ext4_free_blocks_count(es) + add);
 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
 	/* We add the blocks to the bitmap and set the group need init bit */

