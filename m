From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] fs: take i_mutex in __page_symlink()
Date: Mon,  1 Apr 2013 11:23:42 -0400
Message-ID: <1364829822-18989-1-git-send-email-tytso@mit.edu>
References: <20130328140635.GA32635@thunk.org>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57814 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463Ab3DAPXp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 11:23:45 -0400
In-Reply-To: <20130328140635.GA32635@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In Documentation/filesystems/Locking, it's documented that
write_begin() is guaranteed to be called with i_mutex locked.  The
function __page_symlink() was not taking i_mutex before calling
pagecache_write_begin(), which will eventually result in the file
system's write_begin()'s function getting called.

Other callers of pagecache_write_begin such as in fs/splice.c, call
pagecache_write_begin() with i_mutex locked, so fix __page_symlink()
to be consistent.

This was discovered by the addition of a new ext4 debugging assertion
which checked to make sure i_mutex was locked before calling
ext4_truncate().

Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---

Note: I plan to carry the following patch in the ext4 tree, unless
someone objects or Al insists on carrying this in the vfs git tree.

 fs/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 57ae9c8..548e57b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4035,8 +4035,10 @@ int __page_symlink(struct inode *inode, const char *symname, int len, int nofs)
 		flags |= AOP_FLAG_NOFS;
 
 retry:
+	mutex_lock(&inode->i_mutex);
 	err = pagecache_write_begin(NULL, mapping, 0, len-1,
 				flags, &page, &fsdata);
+	mutex_unlock(&inode->i_mutex);
 	if (err)
 		goto fail;
 
-- 
1.7.12.rc0.22.gcdd159b

