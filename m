From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 01/16] ext4: ext4_dx_add_entry should dirty directory metadata
	with the directory inode
Date: Wed, 31 Aug 2011 17:30:37 -0700
Message-ID: <20110901003037.31048.28121.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
index f8068c7..815c31a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1585,7 +1585,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			dxtrace(dx_show_index("node", frames[1].entries));
 			dxtrace(dx_show_index("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
-			err = ext4_handle_dirty_metadata(handle, inode, bh2);
+			err = ext4_handle_dirty_metadata(handle, dir, bh2);
 			if (err)
 				goto journal_error;
 			brelse (bh2);
@@ -1611,7 +1611,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			if (err)
 				goto journal_error;
 		}
-		err = ext4_handle_dirty_metadata(handle, inode, frames[0].bh);
+		err = ext4_handle_dirty_metadata(handle, dir, frames[0].bh);
 		if (err) {
 			ext4_std_error(inode->i_sb, err);
 			goto cleanup;
