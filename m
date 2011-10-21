From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/5] ext4: ext4_dx_add_entry should dirty directory metadata
	with the directory inode
Date: Fri, 21 Oct 2011 14:17:59 -0700
Message-ID: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Tao Ma <tm@tao.ma>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55120 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1JUVSD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Oct 2011 17:18:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_dx_add_entry manipulates bh2 and frames[0].bh, which are two buffer_heads
that point to directory blocks assigned to the directory inode.  However, the
function calls ext4_handle_dirty_metadata with the inode of the file that's
being added to the directory, not the directory inode itself.  Therefore,
correct the code to dirty the directory buffers with the directory inode, not
the file inode.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1c924fa..310b356 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1586,7 +1586,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			dxtrace(dx_show_index("node", frames[1].entries));
 			dxtrace(dx_show_index("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
-			err = ext4_handle_dirty_metadata(handle, inode, bh2);
+			err = ext4_handle_dirty_metadata(handle, dir, bh2);
 			if (err)
 				goto journal_error;
 			brelse (bh2);
@@ -1612,7 +1612,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			if (err)
 				goto journal_error;
 		}
-		err = ext4_handle_dirty_metadata(handle, inode, frames[0].bh);
+		err = ext4_handle_dirty_metadata(handle, dir, frames[0].bh);
 		if (err) {
 			ext4_std_error(inode->i_sb, err);
 			goto cleanup;

