From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.28 24/24] ext4: Initialize the new group descriptor when resizing the filesystem
Date: Tue, 17 Feb 2009 10:32:42 -0500
Message-ID: <1234884762-13580-25-git-send-email-tytso@mit.edu>
References: <1234884762-13580-1-git-send-email-tytso@mit.edu>
 <1234884762-13580-2-git-send-email-tytso@mit.edu>
 <1234884762-13580-3-git-send-email-tytso@mit.edu>
 <1234884762-13580-4-git-send-email-tytso@mit.edu>
 <1234884762-13580-5-git-send-email-tytso@mit.edu>
 <1234884762-13580-6-git-send-email-tytso@mit.edu>
 <1234884762-13580-7-git-send-email-tytso@mit.edu>
 <1234884762-13580-8-git-send-email-tytso@mit.edu>
 <1234884762-13580-9-git-send-email-tytso@mit.edu>
 <1234884762-13580-10-git-send-email-tytso@mit.edu>
 <1234884762-13580-11-git-send-email-tytso@mit.edu>
 <1234884762-13580-12-git-send-email-tytso@mit.edu>
 <1234884762-13580-13-git-send-email-tytso@mit.edu>
 <1234884762-13580-14-git-send-email-tytso@mit.edu>
 <1234884762-13580-15-git-send-email-tytso@mit.edu>
 <1234884762-13580-16-git-send-email-tytso@mit.edu>
 <1234884762-13580-17-git-send-email-tytso@mit.edu>
 <1234884762-13580-18-git-send-email-tytso@mit.edu>
 <1234884762-13580-19-git-send-email-tytso@mit.edu>
 <1234884762-13580-20-git-send-email-tytso@mit.edu>
 <1234884762-13580-21-git-send-email-tytso@mit.edu>
 <1234884762-13580-22-git-send-email-tytso@mit.edu>
 <1234884762-13580-23-git-send-email-tytso@mit.edu>
 <1234884762-13580-24-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33288 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbZBQQM6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:12:58 -0500
In-Reply-To: <1234884762-13580-24-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make sure all of the fields of the group descriptor are properly
initialized.  Previously, we allowed bg_flags field to be contain
random garbage, which could trigger non-deterministic behavior,
including a kernel OOPS.

http://bugzilla.kernel.org/show_bug.cgi?id=12433

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
(cherry picked from commit fdff73f094e7220602cc3f8959c7230517976412)
---
 fs/ext4/resize.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index d1585dd..a027691 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -860,11 +860,13 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	gdp = (struct ext4_group_desc *)((char *)primary->b_data +
 					 gdb_off * EXT4_DESC_SIZE(sb));
 
+	memset(gdp, 0, EXT4_DESC_SIZE(sb));
 	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
 	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */
 	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */
 	gdp->bg_free_blocks_count = cpu_to_le16(input->free_blocks_count);
 	gdp->bg_free_inodes_count = cpu_to_le16(EXT4_INODES_PER_GROUP(sb));
+	gdp->bg_flags = cpu_to_le16(EXT4_BG_INODE_ZEROED);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
 
 	/*
-- 
1.5.6.3

