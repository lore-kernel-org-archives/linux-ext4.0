From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] ext4: ext4_dx_add_entry should dirty directory metadata
	with the directory inode
Date: Thu, 11 Aug 2011 14:15:13 -0700
Message-ID: <20110811211513.GL20655@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52836 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab1HKVPY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 17:15:24 -0400
Content-Disposition: inline
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
index b754b77..79ddc43 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1589,7 +1589,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			dxtrace(dx_show_index("node", frames[1].entries));
 			dxtrace(dx_show_index("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
-			err = ext4_handle_dirty_metadata(handle, inode, bh2);
+			err = ext4_handle_dirty_metadata(handle, dir, bh2);
 			if (err)
 				goto journal_error;
 			brelse (bh2);
@@ -1615,7 +1615,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			if (err)
 				goto journal_error;
 		}
-		err = ext4_handle_dirty_metadata(handle, inode, frames[0].bh);
+		err = ext4_handle_dirty_metadata(handle, dir, frames[0].bh);
 		if (err) {
 			ext4_std_error(inode->i_sb, err);
 			goto cleanup;
