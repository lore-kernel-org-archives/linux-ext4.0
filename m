From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 11/28] ext4: clean up ext4_xattr_inode_get()
Date: Wed, 31 May 2017 01:15:00 -0700
Message-ID: <20170531081517.11438-11-tahsin@google.com>
References: <20170531081517.11438-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531081517.11438-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The input and output values of *size parameter are equal on successful
return from ext4_xattr_inode_get(). On error return, the callers ignore
the output value so there is no need to update it.

Also check for NULL return from ext4_bread(). If the actual xattr inode
size happens to be smaller than the expected size, ext4_bread() may
return NULL which would indicate data corruption.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index d9477d01be9b..8e855fc2eb03 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -278,37 +278,28 @@ ext4_xattr_find_entry(struct ext4_xattr_entry **pentry, int name_index,
 /*
  * Read the EA value from an inode.
  */
-static int
-ext4_xattr_inode_read(struct inode *ea_inode, void *buf, size_t *size)
+static int ext4_xattr_inode_read(struct inode *ea_inode, void *buf, size_t size)
 {
 	unsigned long block = 0;
 	struct buffer_head *bh = NULL;
-	int blocksize;
-	size_t csize, ret_size = 0;
-
-	if (*size == 0)
-		return 0;
+	int blocksize = ea_inode->i_sb->s_blocksize;
+	size_t csize, copied = 0;
 
-	blocksize = ea_inode->i_sb->s_blocksize;
-
-	while (ret_size < *size) {
-		csize = (*size - ret_size) > blocksize ? blocksize :
-							*size - ret_size;
+	while (copied < size) {
+		csize = (size - copied) > blocksize ? blocksize : size - copied;
 		bh = ext4_bread(NULL, ea_inode, block, 0);
-		if (IS_ERR(bh)) {
-			*size = ret_size;
+		if (IS_ERR(bh))
 			return PTR_ERR(bh);
-		}
+		if (!bh)
+			return -EFSCORRUPTED;
+
 		memcpy(buf, bh->b_data, csize);
 		brelse(bh);
 
 		buf += csize;
 		block += 1;
-		ret_size += csize;
+		copied += csize;
 	}
-
-	*size = ret_size;
-
 	return 0;
 }
 
@@ -360,7 +351,7 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
  */
 static int
 ext4_xattr_inode_get(struct inode *inode, unsigned long ea_ino, void *buffer,
-		     size_t *size)
+		     size_t size)
 {
 	struct inode *ea_inode;
 	int ret;
@@ -417,7 +408,7 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 		if (entry->e_value_inum) {
 			error = ext4_xattr_inode_get(inode,
 					     le32_to_cpu(entry->e_value_inum),
-					     buffer, &size);
+					     buffer, size);
 			if (error)
 				goto cleanup;
 		} else {
@@ -467,7 +458,7 @@ ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 		if (entry->e_value_inum) {
 			error = ext4_xattr_inode_get(inode,
 					     le32_to_cpu(entry->e_value_inum),
-					     buffer, &size);
+					     buffer, size);
 			if (error)
 				goto cleanup;
 		} else {
-- 
2.13.0.219.gdb65acc882-goog
