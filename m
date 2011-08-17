From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] ext4: ext4_mkdir should dirty dir_block with the parent
	inode
Date: Tue, 16 Aug 2011 20:39:54 -0700
Message-ID: <20110817033954.GP20655@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49882 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1HQDj4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Aug 2011 23:39:56 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_mkdir calls ext4_handle_dirty_metadata with dir_block and the inode "dir".
Unfortunately, dir_block belongs to the newly created directory (which is
"inode"), not the parent directory (which is "dir").  Fix the incorrect
association.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2b5c34b..a2c2855 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1866,7 +1866,7 @@ retry:
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
 	inode->i_nlink = 2;
 	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
+	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
 	if (err)
 		goto out_clear_inode;
 	err = ext4_mark_inode_dirty(handle, inode);
