From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 01/22] ext4: Create a new BH_Verified flag to avoid
	unnecessary metadata validation
Date: Mon, 28 Nov 2011 15:26:22 -0800
Message-ID: <20111128232622.19194.42676.stgit@elm3c44.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
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
In-Reply-To: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Create a new BH_Verified flag to indicate that we've verified all the data in a
buffer_head for correctness.  This allows us to bypass expensive verification
steps when they are not necessary without missing them when they are.

v2: The later jbd2 metadata checksumming patches need a BH_Verified flag for
journal metadata, so put the flag in jbd2.h so that both drivers can share the
same bit.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/extents.c          |   35 ++++++++++++++++++++++++++---------
 include/linux/jbd_common.h |    2 ++
 2 files changed, 28 insertions(+), 9 deletions(-)


diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..00f97f4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -396,6 +396,26 @@ int ext4_ext_check_inode(struct inode *inode)
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
@@ -652,8 +672,6 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 	i = depth;
 	/* walk through the tree */
 	while (i) {
-		int need_to_validate = 0;
-
 		ext_debug("depth %d: num %d, max %d\n",
 			  ppos, le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
 
@@ -672,8 +690,6 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 				put_bh(bh);
 				goto err;
 			}
-			/* validate the extent entries */
-			need_to_validate = 1;
 		}
 		eh = ext_block_hdr(bh);
 		ppos++;
@@ -687,7 +703,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 		path[ppos].p_hdr = eh;
 		i--;
 
-		if (need_to_validate && ext4_ext_check(inode, eh, i))
+		if (ext4_ext_check_block(inode, eh, i, bh))
 			goto err;
 	}
 
@@ -1328,7 +1344,8 @@ got_index:
 			return -EIO;
 		eh = ext_block_hdr(bh);
 		/* subtract from p_depth to get proper eh_depth */
-		if (ext4_ext_check(inode, eh, path->p_depth - depth)) {
+		if (ext4_ext_check_block(inode, eh,
+					 path->p_depth - depth, bh)) {
 			put_bh(bh);
 			return -EIO;
 		}
@@ -1341,7 +1358,7 @@ got_index:
 	if (bh == NULL)
 		return -EIO;
 	eh = ext_block_hdr(bh);
-	if (ext4_ext_check(inode, eh, path->p_depth - depth)) {
+	if (ext4_ext_check_block(inode, eh, path->p_depth - depth, bh)) {
 		put_bh(bh);
 		return -EIO;
 	}
@@ -2572,8 +2589,8 @@ again:
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
diff --git a/include/linux/jbd_common.h b/include/linux/jbd_common.h
index 6230f85..6133679 100644
--- a/include/linux/jbd_common.h
+++ b/include/linux/jbd_common.h
@@ -12,6 +12,7 @@ enum jbd_state_bits {
 	BH_State,		/* Pins most journal_head state */
 	BH_JournalHead,		/* Pins bh->b_private and jh->b_bh */
 	BH_Unshadow,		/* Dummy bit, for BJ_Shadow wakeup filtering */
+	BH_Verified,		/* Metadata block has been verified ok */
 	BH_JBDPrivateStart,	/* First bit available for private use by FS */
 };
 
@@ -24,6 +25,7 @@ TAS_BUFFER_FNS(Revoked, revoked)
 BUFFER_FNS(RevokeValid, revokevalid)
 TAS_BUFFER_FNS(RevokeValid, revokevalid)
 BUFFER_FNS(Freed, freed)
+BUFFER_FNS(Verified, verified)
 
 static inline struct buffer_head *jh2bh(struct journal_head *jh)
 {
