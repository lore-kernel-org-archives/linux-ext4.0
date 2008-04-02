From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix hang on umount with quotas when journal is
	aborted
Date: Wed, 2 Apr 2008 11:10:07 +0200
Message-ID: <20080402091006.GD2716@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Payphone LIOU <lioupayphone@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58584 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752394AbYDBJKI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2008 05:10:08 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Call dquot_drop() from ext4_dquot_drop() even if we fail to start a
transaction. Otherwise we never get to dropping references to quota structures
from the inode and umount will hang indefinitely.  Thanks to Payphone LIOU for
spotting the problem.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: Payphone LIOU <lioupayphone@gmail.com>

---
  I'm not sure if this should go through ext4 patch queue or through Andrew.
It should not collide with anything so it probably does not matter much...

 fs/ext4/super.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 13383ba..286acec 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3039,8 +3039,14 @@ static int ext4_dquot_drop(struct inode *inode)
 
 	/* We may delete quota structure so we need to reserve enough blocks */
 	handle = ext4_journal_start(inode, 2*EXT4_QUOTA_DEL_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		/*
+		 * We call dquot_drop() anyway to at least release references
+		 * to quota structures so that umount does not hang.
+		 */
+		dquot_drop(inode);
 		return PTR_ERR(handle);
+	}
 	ret = dquot_drop(inode);
 	err = ext4_journal_stop(handle);
 	if (!ret)
-- 
1.5.2.4

