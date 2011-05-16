From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix oops in ext4_quota_off()
Date: Mon, 16 May 2011 11:46:23 +0200
Message-ID: <1305539183-7181-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44635 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab1EPJqr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 05:46:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When quota is not enabled when ext4_quota_off() is called, we must not
dereference quota file inode since it is NULL. Check properly for this.  This
is a regression caused by commit 21f976975cbecbdaf23ceeacc1cab2b1c05a028e.

Debugged-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a86e693..2a4a9b2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4652,6 +4652,8 @@ static int ext4_quota_off(struct super_block *sb, int type)
 	if (test_opt(sb, DELALLOC))
 		sync_filesystem(sb);
 
+	if (!inode)
+		goto out;
 	/* Update modification times of quota files when userspace can
 	 * start looking at them */
 	handle = ext4_journal_start(inode, 1);
-- 
1.7.1

