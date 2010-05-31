From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 44/53] ext4: Prevent creation of files larger than RLIMIT_FSIZE using fallocate
Date: Sun, 30 May 2010 22:49:57 -0400
Message-ID: <1275274206-3900-44-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Nikanth Karthikesan <knikanth@suse.de>,
	Amit Arora <aarora@in.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44613 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab0EaCuT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:19 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Nikanth Karthikesan <knikanth@suse.de>

commit 6d19c42b7cf81c39632b6d4dbc514e8449bcd346 upstream (as of v2.6.34-git13)

Currently using posix_fallocate one can bypass an RLIMIT_FSIZE limit
and create a file larger than the limit. Add a check for that.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Amit Arora <aarora@in.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cd4cccc..aca259f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3607,6 +3607,11 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	 */
 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
 	mutex_lock(&inode->i_mutex);
+	ret = inode_newsize_ok(inode, (len + offset));
+	if (ret) {
+		mutex_unlock(&inode->i_mutex);
+		return ret;
+	}
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		block = block + ret;
-- 
1.6.6.1.1.g974db.dirty

