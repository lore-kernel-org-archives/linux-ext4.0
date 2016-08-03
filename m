From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/11] ext4: Replace bogus assertion in ext4_xattr_shift_entries()
Date: Wed,  3 Aug 2016 12:39:52 +0200
Message-ID: <1470220795-17045-9-git-send-email-jack@suse.cz>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbcHCKkd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2016 06:40:33 -0400
In-Reply-To: <1470220795-17045-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We were checking whether computed offsets do not exceed end of block in
ext4_xattr_shift_entries(). However this does not make sense since we
always only decrease offsets. So replace that assertion with a check
whether we really decrease xattrs value offsets.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1447860b61ec..82b025c977fc 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1319,18 +1319,19 @@ retry:
  */
 static void ext4_xattr_shift_entries(struct ext4_xattr_entry *entry,
 				     int value_offs_shift, void *to,
-				     void *from, size_t n, int blocksize)
+				     void *from, size_t n)
 {
 	struct ext4_xattr_entry *last = entry;
 	int new_offs;
 
+	/* We always shift xattr headers further thus offsets get lower */
+	BUG_ON(value_offs_shift > 0);
+
 	/* Adjust the value offsets of the entries */
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
 		if (last->e_value_size) {
 			new_offs = le16_to_cpu(last->e_value_offs) +
 							value_offs_shift;
-			BUG_ON(new_offs + le32_to_cpu(last->e_value_size)
-				 > blocksize);
 			last->e_value_offs = cpu_to_le16(new_offs);
 		}
 	}
@@ -1542,7 +1543,7 @@ shift:
 	ext4_xattr_shift_entries(entry,	EXT4_I(inode)->i_extra_isize
 			- new_extra_isize, (void *)raw_inode +
 			EXT4_GOOD_OLD_INODE_SIZE + new_extra_isize,
-			(void *)header, total_ino, inode->i_sb->s_blocksize);
+			(void *)header, total_ino);
 	EXT4_I(inode)->i_extra_isize = new_extra_isize;
 	brelse(bh);
 out:
-- 
2.6.6

