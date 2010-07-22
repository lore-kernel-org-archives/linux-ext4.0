From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: [PATCH 1/3] ext3/ext4: Factor out disk addressability
	check
Date: Thu, 22 Jul 2010 15:03:41 -0700
Message-ID: <874ofr2myq.fsf@patl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: ocfs2-devel@oss.oracle.com
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

As part of adding support for OCFS2 to mount huge volumes, we need to
check that the sector_t and page cache of the system are capable of
addressing the entire volume.

An identical check already appears in ext3 and ext4.  This patch moves
the addressability check into its own function in fs/libfs.c and
modifies ext3 and ext4 to invoke it.

Signed-off-by: Patrick LoPresti <lopresti@gmail.com>

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..6aff3f5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2399,6 +2399,8 @@ extern ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 
 extern int generic_file_fsync(struct file *, int);
 
+extern int generic_check_addressable(unsigned, u64);
+
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
 				struct page *, struct page *);
diff --git a/fs/libfs.c b/fs/libfs.c
index dcaf972..b969648 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -955,6 +955,38 @@ int generic_file_fsync(struct file *file, int datasync)
 }
 EXPORT_SYMBOL(generic_file_fsync);
 
+/**
+ * generic_check_addressable - Check addressability of file system
+ * @blocksize_bits:	log of file system block size
+ * @num_blocks:		number of blocks in file system
+ *
+ * Determine whether a file system with @num_blocks blocks (and a
+ * block size of 2**@blocksize_bits) is addressable by the sector_t
+ * and page cache of the system.  Return 0 if so and -EFBIG otherwise.
+ */
+int generic_check_addressable(unsigned blocksize_bits, u64 num_blocks)
+{
+	u64 last_fs_block = num_blocks - 1;
+
+	BUG_ON(blocksize_bits < 9);
+	BUG_ON(blocksize_bits > PAGE_CACHE_SHIFT);
+
+	if (unlikely(num_blocks == 0))
+		return 0;
+
+	printk(KERN_INFO "HERE %u %lu %u %u", blocksize_bits, last_fs_block,
+	       sizeof(sector_t), sizeof(pgoff_t));
+
+	if ((last_fs_block >
+	     (sector_t)(~0ULL) >> (blocksize_bits - 9)) ||
+	    (last_fs_block >
+	     (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - blocksize_bits))) {
+		return -EFBIG;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(generic_check_addressable);
+
 /*
  * No-op implementation of ->fsync for in-memory filesystems.
  */
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 6c953bb..d0643db 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1862,8 +1862,8 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	if (le32_to_cpu(es->s_blocks_count) >
-		    (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) {
+	if (generic_check_addressable(sb->s_blocksize_bits,
+				      le32_to_cpu(es->s_blocks_count))) {
 		ext3_msg(sb, KERN_ERR,
 			"error: filesystem is too large to mount safely");
 		if (sizeof(sector_t) < 8)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e8983a..979cc57 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2706,15 +2706,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * Test whether we have more sectors than will fit in sector_t,
 	 * and whether the max offset is addressable by the page cache.
 	 */
-	if ((ext4_blocks_count(es) >
-	     (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) ||
-	    (ext4_blocks_count(es) >
-	     (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - sb->s_blocksize_bits))) {
+	ret = generic_check_addressable(sb->s_blocksize_bits,
+					ext4_blocks_count(es));
+	if (ret) {
 		ext4_msg(sb, KERN_ERR, "filesystem"
 			 " too large to mount safely on this system");
 		if (sizeof(sector_t) < 8)
 			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
-		ret = -EFBIG;
 		goto failed_mount;
 	}
