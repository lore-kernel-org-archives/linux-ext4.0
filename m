From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] ext4: don't dereference null pointer when make_indexed_dir() fails
Date: Mon,  9 May 2011 10:27:08 -0400
Message-ID: <1304951228-24962-1-git-send-email-tytso@mit.edu>
References: <20110509142237.GA19811@thunk.org>
Cc: Allison Henderson <achender@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49559 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1EIO1K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 10:27:10 -0400
In-Reply-To: <20110509142237.GA19811@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Allison Henderson <achender@linux.vnet.ibm.com>

Fix for a null pointer bug found while running punch hole tests

Signed-off-by: Allison Henderson <achender@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3c7a06e..cc97feb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1422,7 +1422,9 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		 */
 		ext4_mark_inode_dirty(handle, dir);
 		ext4_handle_dirty_metadata(handle, dir, frame->bh);
-		ext4_handle_dirty_metadata(handle, dir, bh);
+		ext4_handle_dirty_metadata(handle, dir, bh2);
+		if (bh)
+			ext4_handle_dirty_metadata(handle, dir, bh);
 		dx_release(frames);
 		return retval;
 	}
-- 
1.7.3.1

