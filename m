From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: allow the mount options nodelalloc and data=journal
Date: Thu,  8 Aug 2013 23:04:57 -0400
Message-ID: <1376017497-10773-1-git-send-email-tytso@mit.edu>
Cc: b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41327 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967185Ab3HIDFB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Aug 2013 23:05:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 26092bf ("ext4: use a table-driven handler for mount options")
wrongly disallows the specifying the mount options nodelalloc and
data=journal simultaneously.  This is incorrect; it should have only
disallowed the combination of delalloc and data=journal
simultaneously.

Reported-by: Piotr Sarna <p.sarna@partner.samsung.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 36b141e..75b3708 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1359,7 +1359,7 @@ static const struct mount_opts {
 	{Opt_delalloc, EXT4_MOUNT_DELALLOC,
 	 MOPT_EXT4_ONLY | MOPT_SET | MOPT_EXPLICIT},
 	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC,
-	 MOPT_EXT4_ONLY | MOPT_CLEAR | MOPT_EXPLICIT},
+	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
 	 MOPT_EXT4_ONLY | MOPT_SET},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
-- 
1.7.12.rc0.22.gcdd159b

