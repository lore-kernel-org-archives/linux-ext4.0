From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix reading new encrypted symlinks on no-journal file systems
Date: Fri,  2 Dec 2016 12:14:22 -0500
Message-ID: <20161202171422.20724-1-tytso@mit.edu>
References: <20161201195731.GA131121@google.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: ebiggers@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47000 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750781AbcLBROZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 2 Dec 2016 12:14:25 -0500
In-Reply-To: <20161201195731.GA131121@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On a filesystem with no journal, a symlink longer than about 32
characters (exact length depending on padding for encryption) could not
be followed or read immediately after being created in an encrypted
directory.  This happened because when the symlink data went through the
delayed allocation path instead of the journaling path, the symlink was
incorrectly detected as a "fast" symlink rather than a "slow" symlink
until its data was written out.

To fix this, disable delayed allocation for symlinks, since there is
no benefit for delayed allocation anyway.

Reported-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 59a518ad6bb2..a1eac0054203 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2902,7 +2902,8 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 
 	index = pos >> PAGE_SHIFT;
 
-	if (ext4_nonda_switch(inode->i_sb)) {
+	if (ext4_nonda_switch(inode->i_sb) ||
+	    S_ISLNK(inode->i_mode)) {
 		*fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
 		return ext4_write_begin(file, mapping, pos,
 					len, flags, pagep, fsdata);
-- 
2.11.0.rc0.7.gbe5a750

