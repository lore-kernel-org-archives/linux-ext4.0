From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] ext4: Prevent race while waling extent tree
Date: Fri,  9 Nov 2012 11:38:53 +0100
Message-ID: <1352457533-11642-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, zab@redhat.com, dmonakhov@openvz.org,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab2KIKjM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Nov 2012 05:39:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently ext4_ext_walk_space() only takes i_data_sem for read when
searching for the extent at given block with ext4_ext_find_extent().
Then it drops the lock and the extent tree can be changed at will.
However later on we're searching for the 'next' extent, but the extent
tree might already have changed, so the information might not be
accurate.

In fact we can hit BUG_ON(end <= start) if the extent got inserted into
the tree after the one we found and before the block we were searching
for. This has been reproduced by running xfstests 225 in loop on s390x
architecture, but theoretically we could hit this on any other
architecture as well, but probably not as often.

ext4_ext_walk_space() is currently only used from ext4_fiemap().

Fix this by extending the critical section to include
ext4_ext_next_allocated_block() as well. It means that if there are any
operation going on on the particular inode, the fiemap will return
inaccurate data. However this will also fix the concerns about starving
writers to the extent tree, because we will put and reacquire the
semaphore with every iteration. This will not be particularly fast, but
fiemap is not critical operation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: Extend the critical section rather than put the whole function under
    the lock.

 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7011ac9..d444281 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1978,7 +1978,6 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 		/* find extent for this block */
 		down_read(&EXT4_I(inode)->i_data_sem);
 		path = ext4_ext_find_extent(inode, block, path);
-		up_read(&EXT4_I(inode)->i_data_sem);
 		if (IS_ERR(path)) {
 			err = PTR_ERR(path);
 			path = NULL;
@@ -1993,6 +1992,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 		}
 		ex = path[depth].p_ext;
 		next = ext4_ext_next_allocated_block(path);
+		up_read(&EXT4_I(inode)->i_data_sem);
 
 		exists = 0;
 		if (!ex) {
-- 
1.7.7.6

