From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Add missing unlock to an error path in ext4_quota_write()
Date: Thu, 26 Jun 2008 13:19:03 +0200
Message-ID: <12144791441146-git-send-email-jack@suse.cz>
References: n
 <12144791432214-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54115 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753818AbYFZLTF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jun 2008 07:19:05 -0400
In-Reply-To: <12144791432214-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When write in ext4_quota_write() fails, we have to properly release
i_mutex. One error path has been missing the unlock...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb96f12..02bf243 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3337,8 +3337,10 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 		blk++;
 	}
 out:
-	if (len == towrite)
+	if (len == towrite) {
+		mutex_unlock(&inode->i_mutex);
 		return err;
+	}
 	if (inode->i_size < off+len-towrite) {
 		i_size_write(inode, off+len-towrite);
 		EXT4_I(inode)->i_disksize = inode->i_size;
-- 
1.5.2.4

