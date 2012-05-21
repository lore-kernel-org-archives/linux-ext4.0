From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: enable the 64-bit jbd2 feature based on the 64-bit ext4 feature
Date: Mon, 21 May 2012 11:42:50 -0400
Message-ID: <1337614970-29025-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55994 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab2EUPmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 May 2012 11:42:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously we were only enabling the 64-bit jbd2 feature if the number
of blocks in the file system was greater 2**32-1.  The problem with
this is that it makes it harder to test the 64-bit journal code paths
with small file systems, since a small test file system would with the
64-bit ext4 feature enable would use a 64-bit file system on-disk data
structures, but use a 32-bit journal.

This would also cause problems when trying to do an online resize to
grow the filesystem above the 2**32-1 boundary.  Fortunately the patch
to support online resize for 64-bit file systems hasn't been merged
yet, so this problem hasn't arisen in practice.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c18c596..88c2054 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3603,7 +3603,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto no_journal;
 	}
 
-	if (ext4_blocks_count(es) > 0xffffffffULL &&
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT) &&
 	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
 				       JBD2_FEATURE_INCOMPAT_64BIT)) {
 		ext4_msg(sb, KERN_ERR, "Failed to set 64-bit journal feature");
-- 
1.7.10.rc3

