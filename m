From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] ext4: add sanity check to ext4_get_group_info()
Date: Thu,  6 Jun 2013 11:41:14 -0400
Message-ID: <1370533275-22381-2-git-send-email-tytso@mit.edu>
References: <1370533275-22381-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55524 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab3FFPlV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jun 2013 11:41:21 -0400
In-Reply-To: <1370533275-22381-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The group number passed to ext4_get_group_info() should be valid, but
let's add an assert to check this before we start creating a pointer
based on that group number and dereferencing it.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bd9890f..f85f1fb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2313,6 +2313,7 @@ struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
 {
 	 struct ext4_group_info ***grp_info;
 	 long indexv, indexh;
+	 BUG_ON(group >= EXT4_SB(sb)->s_groups_count);
 	 grp_info = EXT4_SB(sb)->s_group_info;
 	 indexv = group >> (EXT4_DESC_PER_BLOCK_BITS(sb));
 	 indexh = group & ((EXT4_DESC_PER_BLOCK(sb)) - 1);
-- 
1.7.12.rc0.22.gcdd159b

