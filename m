From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix deadlock with quota feature
Date: Fri,  5 Apr 2013 12:06:22 +0200
Message-ID: <1365156382-16703-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab3DEKGd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Apr 2013 06:06:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We didn't mark hidden quota files with S_NOQUOTA flag and thus quota was
accounted even for quota files. Thus we could recurse back to quota code
when adding new blocks to quota file which can easily deadlock. Mark
hidden quota files properly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5d6d535..fc203b3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4945,6 +4945,8 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 		return PTR_ERR(qf_inode);
 	}
 
+	/* Don't account quota for quota files to avoid recursion */
+	qf_inode->i_flags |= S_NOQUOTA;
 	err = dquot_enable(qf_inode, type, format_id, flags);
 	iput(qf_inode);
 
-- 
1.7.1

