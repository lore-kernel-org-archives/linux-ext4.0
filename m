From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 27/53] ext4: Fix possible lost inode write in no journal mode
Date: Sun, 30 May 2010 22:49:40 -0400
Message-ID: <1275274206-3900-27-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44647 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab0EaCuW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:22 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Curt Wohlgemuth <curtw@google.com>

commit 8b472d739b2ddd8ab7fb278874f696cd95b25a5e upstream (as of v2.6.34-rc6)

In the no-journal case, ext4_write_inode() will fetch the bh and call
sync_dirty_buffer() on it.  However, if the bh has already been
written and the bh reclaimed for some other purpose, AND if the inode
is the only one in the inode table block in use, then
ext4_get_inode_loc() will not read the inode table block from disk,
but as an optimization, fill the block with zero's assuming that its
caller will copy in the on-disk version of the inode.  This is not
done by ext4_write_inode(), so the contents of the inode can simply
get lost.  The fix is to use __ext4_get_inode_loc() with in_mem set to
0, instead of ext4_get_inode_loc().  Long term the API needs to be
fixed so it's obvious why latter is not safe.

Addresses-Google-Bug: #2526446

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4bee50f..f81025f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5260,7 +5260,7 @@ int ext4_write_inode(struct inode *inode, int wait)
 	} else {
 		struct ext4_iloc iloc;
 
-		err = ext4_get_inode_loc(inode, &iloc);
+		err = __ext4_get_inode_loc(inode, &iloc, 0);
 		if (err)
 			return err;
 		if (wait)
-- 
1.6.6.1.1.g974db.dirty

