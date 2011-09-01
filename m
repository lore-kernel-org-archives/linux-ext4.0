From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/16] ext4: Create a new BH_Verified flag to avoid
	unnecessary metadata validation
Date: Wed, 31 Aug 2011 17:30:57 -0700
Message-ID: <20110901003057.31048.51269.stgit@elm3c44.beaverton.ibm.com>
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

Create a new BH_Verified flag to indicate that we've verified all the data in a
buffer_head for correctness.  This allows us to bypass expensive verification
steps when they are not necessary without missing them when they are.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/extents.c |   35 ++++++++++++++++++++++++++---------
 2 files changed, 28 insertions(+), 9 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e717dfd..ecb86c2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2242,10 +2242,12 @@ extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
 enum ext4_state_bits {
 	BH_Uninit	/* blocks are allocated but uninitialized on disk */
 	  = BH_JBDPrivateStart,
+	BH_Verified,	/* metadata block has been verified ok */
 };
 
 BUFFER_FNS(Uninit, uninit)
 TAS_BUFFER_FNS(Uninit, uninit)
+BUFFER_FNS(Verified, verified)
 
 /*
  * Add new method to test wether block and inode bitmaps are properly
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..4ac4303 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -403,6 +403,26 @@ int ext4_ext_check_inode(struct inode *inode)
 	return ext4_ext_check(inode, ext_inode_hdr(inode), ext_depth(inode));
 }
 
+static int __ext4_ext_check_block(const char *function, unsigned int line,
+				  struct inode *inode,
+				  struct ext4_extent_header *eh,
+				  int depth,
+				  struct buffer_head *bh)
+{
+	int ret;
+
+	if (buffer_verified(bh))
+		return 0;
+	ret = ext4_ext_check(inode, eh, depth);
+	if (ret)
+		return ret;
+	set_buffer_verified(bh);
+	return ret;
+}
+
+#define ext4_ext_check_block(inode, eh, depth, bh)	\
+	__ext4_ext_check_block(__func__, __LINE__, inode, eh, depth, bh)
+
 #ifdef EXT_DEBUG
 static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
 {
@@ -659,8 +679,6 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 	i = depth;
 	/* walk through the tree */
 	while (i) {
-		int need_to_validate = 0;
-
 		ext_debug("depth %d: num %d, max %d\n",
 			  ppos, le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
 
@@ -679,8 +697,6 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 				put_bh(bh);
 				goto err;
 			}
-			/* validate the extent entries */
-			need_to_validate = 1;
 		}
 		eh = ext_block_hdr(bh);
 		ppos++;
@@ -694,7 +710,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 		path[ppos].p_hdr = eh;
 		i--;
 
-		if (need_to_validate && ext4_ext_check(inode, eh, i))
+		if (ext4_ext_check_block(inode, eh, i, bh))
 			goto err;
 	}
 
@@ -1350,7 +1366,8 @@ got_index:
 			return -EIO;
 		eh = ext_block_hdr(bh);
 		/* subtract from p_depth to get proper eh_depth */
-		if (ext4_ext_check(inode, eh, path->p_depth - depth)) {
+		if (ext4_ext_check_block(inode, eh,
+					 path->p_depth - depth, bh)) {
 			put_bh(bh);
 			return -EIO;
 		}
@@ -1363,7 +1380,7 @@ got_index:
 	if (bh == NULL)
 		return -EIO;
 	eh = ext_block_hdr(bh);
-	if (ext4_ext_check(inode, eh, path->p_depth - depth)) {
+	if (ext4_ext_check_block(inode, eh, path->p_depth - depth, bh)) {
 		put_bh(bh);
 		return -EIO;
 	}
@@ -2591,8 +2608,8 @@ again:
 				err = -EIO;
 				break;
 			}
-			if (ext4_ext_check(inode, ext_block_hdr(bh),
-							depth - i - 1)) {
+			if (ext4_ext_check_block(inode, ext_block_hdr(bh),
+							depth - i - 1, bh)) {
 				err = -EIO;
 				break;
 			}
