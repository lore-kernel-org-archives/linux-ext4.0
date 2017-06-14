From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 31/31] ext4: strong binding of xattr inode references
Date: Wed, 14 Jun 2017 10:23:50 -0700
Message-ID: <20170614172351.18992-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

To verify that a xattr entry is not pointing to the wrong xattr inode,
we currently check that the target inode has EXT4_EA_INODE_FL flag set and
also the entry size matches the target inode size.

For stronger validation, also incorporate crc32c hash of the value into
the e_hash field. This is done regardless of whether the entry lives in
the inode body or external attribute block.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 106 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 6c6dce2f874e..7e9134fb4bb8 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -77,8 +77,8 @@ static void ext4_xattr_block_cache_insert(struct mb_cache *,
 static struct buffer_head *
 ext4_xattr_block_cache_find(struct inode *, struct ext4_xattr_header *,
 			    struct mb_cache_entry **);
-static void ext4_xattr_hash_entry(struct ext4_xattr_entry *entry,
-				  void *value_base);
+static __le32 ext4_xattr_hash_entry(char *name, size_t name_len, __le32 *value,
+				    size_t value_count);
 static void ext4_xattr_rehash(struct ext4_xattr_header *);
 
 static const struct xattr_handler * const ext4_xattr_handler_map[] = {
@@ -389,18 +389,20 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 }
 
 /*
- * Read the value from the EA inode.
+ * Read xattr value from the EA inode.
  */
 static int
-ext4_xattr_inode_get(struct inode *inode, unsigned long ea_ino, void *buffer,
-		     size_t size)
+ext4_xattr_inode_get(struct inode *inode, struct ext4_xattr_entry *entry,
+		     void *buffer, size_t size)
 {
 	struct mb_cache *ea_inode_cache = EA_INODE_CACHE(inode);
 	struct inode *ea_inode;
+	__le32 calc_e_hash, tmp_data;
 	u32 hash;
 	int err;
 
-	err = ext4_xattr_inode_iget(inode, ea_ino, &ea_inode);
+	err = ext4_xattr_inode_iget(inode, le32_to_cpu(entry->e_value_inum),
+				    &ea_inode);
 	if (err) {
 		ea_inode = NULL;
 		goto out;
@@ -415,11 +417,25 @@ ext4_xattr_inode_get(struct inode *inode, unsigned long ea_ino, void *buffer,
 	}
 
 	err = ext4_xattr_inode_read(ea_inode, buffer, size);
-	if (!err) {
-		hash = ext4_xattr_inode_get_hash(ea_inode);
-		mb_cache_entry_create(ea_inode_cache, GFP_NOFS, hash,
-				      ea_inode->i_ino, true /* reusable */);
+	if (err)
+		goto out;
+
+	hash = ext4_xattr_inode_get_hash(ea_inode);
+
+	/* Verify e_hash. */
+	tmp_data = cpu_to_le32(hash);
+	calc_e_hash = ext4_xattr_hash_entry(entry->e_name, entry->e_name_len,
+					    &tmp_data, 1);
+	if (calc_e_hash != entry->e_hash) {
+		ext4_warning_inode(inode,
+			"Entry calc_e_hash=%#x does not match e_hash=%#x",
+			le32_to_cpu(calc_e_hash), le32_to_cpu(entry->e_hash));
+		err = -EFSCORRUPTED;
+		goto out;
 	}
+
+	mb_cache_entry_create(ea_inode_cache, GFP_NOFS, hash, ea_inode->i_ino,
+			      true /* reusable */);
 out:
 	iput(ea_inode);
 	return err;
@@ -465,9 +481,8 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 		if (size > buffer_size)
 			goto cleanup;
 		if (entry->e_value_inum) {
-			error = ext4_xattr_inode_get(inode,
-					     le32_to_cpu(entry->e_value_inum),
-					     buffer, size);
+			error = ext4_xattr_inode_get(inode, entry, buffer,
+						     size);
 			if (error)
 				goto cleanup;
 		} else {
@@ -515,9 +530,8 @@ ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 		if (size > buffer_size)
 			goto cleanup;
 		if (entry->e_value_inum) {
-			error = ext4_xattr_inode_get(inode,
-					     le32_to_cpu(entry->e_value_inum),
-					     buffer, size);
+			error = ext4_xattr_inode_get(inode, entry, buffer,
+						     size);
 			if (error)
 				goto cleanup;
 		} else {
@@ -1634,12 +1648,36 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 		here->e_value_size = cpu_to_le32(i->value_len);
 	}
 
-	if (is_block) {
-		if (s->not_found || i->value)
-			ext4_xattr_hash_entry(here, s->base);
-		ext4_xattr_rehash((struct ext4_xattr_header *)s->base);
+	if (i->value) {
+		__le32 hash = 0;
+
+		/* Entry hash calculation. */
+		if (in_inode) {
+			__le32 crc32c_hash;
+
+			/*
+			 * Feed crc32c hash instead of the raw value for entry
+			 * hash calculation. This is to avoid walking
+			 * potentially long value buffer again.
+			 */
+			crc32c_hash = cpu_to_le32(
+				       ext4_xattr_inode_get_hash(new_ea_inode));
+			hash = ext4_xattr_hash_entry(here->e_name,
+						     here->e_name_len,
+						     &crc32c_hash, 1);
+		} else if (is_block) {
+			__le32 *value = s->base + min_offs - new_size;
+
+			hash = ext4_xattr_hash_entry(here->e_name,
+						     here->e_name_len, value,
+						     new_size >> 2);
+		}
+		here->e_hash = hash;
 	}
 
+	if (is_block)
+		ext4_xattr_rehash((struct ext4_xattr_header *)s->base);
+
 	ret = 0;
 out:
 	iput(old_ea_inode);
@@ -2421,9 +2459,7 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
 	/* Save the entry name and the entry value */
 	if (entry->e_value_inum) {
-		error = ext4_xattr_inode_get(inode,
-					     le32_to_cpu(entry->e_value_inum),
-					     buffer, value_size);
+		error = ext4_xattr_inode_get(inode, entry, buffer, value_size);
 		if (error)
 			goto out;
 	} else {
@@ -2913,30 +2949,22 @@ ext4_xattr_block_cache_find(struct inode *inode,
  *
  * Compute the hash of an extended attribute.
  */
-static void ext4_xattr_hash_entry(struct ext4_xattr_entry *entry,
-				  void *value_base)
+static __le32 ext4_xattr_hash_entry(char *name, size_t name_len, __le32 *value,
+				    size_t value_count)
 {
 	__u32 hash = 0;
-	char *name = entry->e_name;
-	int n;
 
-	for (n = 0; n < entry->e_name_len; n++) {
+	while (name_len--) {
 		hash = (hash << NAME_HASH_SHIFT) ^
 		       (hash >> (8*sizeof(hash) - NAME_HASH_SHIFT)) ^
 		       *name++;
 	}
-
-	if (!entry->e_value_inum && entry->e_value_size) {
-		__le32 *value = (__le32 *)((char *)value_base +
-			le16_to_cpu(entry->e_value_offs));
-		for (n = (le32_to_cpu(entry->e_value_size) +
-		     EXT4_XATTR_ROUND) >> EXT4_XATTR_PAD_BITS; n; n--) {
-			hash = (hash << VALUE_HASH_SHIFT) ^
-			       (hash >> (8*sizeof(hash) - VALUE_HASH_SHIFT)) ^
-			       le32_to_cpu(*value++);
-		}
+	while (value_count--) {
+		hash = (hash << VALUE_HASH_SHIFT) ^
+		       (hash >> (8*sizeof(hash) - VALUE_HASH_SHIFT)) ^
+		       le32_to_cpu(*value++);
 	}
-	entry->e_hash = cpu_to_le32(hash);
+	return cpu_to_le32(hash);
 }
 
 #undef NAME_HASH_SHIFT
-- 
2.13.1.508.gb3defc5cc-goog
