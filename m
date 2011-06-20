From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 2/3] ext4 directory index: read-ahead blocks v2
Date: Mon, 20 Jun 2011 22:28:54 +0200
Message-ID: <20110620202854.2473133.32514.stgit@localhost.localdomain>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: adilger@whamcloud.com, colyli@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:39440 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab1FTU24 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jun 2011 16:28:56 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p5KKStCU028617
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jun 2011 22:28:55 +0200
In-Reply-To: <20110620202631.2473133.4166.stgit@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Bernd Schubert <bernd.schubert@fastmail.fm>

changes from v1 -> v2:
Limit the number of read-ahead blocks as suggested by Andreas.

While creating files in large directories we noticed an endless number
of 4K reads. And those reads very much reduced file creation numbers
as shown by bonnie. While we would expect about 2000 creates/s, we
only got about 25 creates/s. Running the benchmarks for a long time
improved the numbers, but not above 200 creates/s.
It turned out those reads came from directory index block reads
and probably the bh cache never cached all dx blocks. Given by
the high number of directories we have (8192) and number of files required
to trigger the issue (16 million), rather probably bh cached dx blocks
got lost in favour of other less important blocks.
The patch below implements a read-ahead for *all* dx blocks of a directory
if a single dx block is missing in the cache. That also helps the LRU
to cache important dx blocks.

Unfortunately, it also has a performance trade-off for the first access to
a directory, although the READA flag is set already.
Therefore at least for now, this option is disabled by default, but may
be enabled using 'mount -o dx_read_ahead' or 'mount -odx_read_ahead=1'

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 Documentation/filesystems/ext4.txt |    6 +++
 fs/ext4/ext4.h                     |    3 +
 fs/ext4/inode.c                    |   28 ++++++++++++++
 fs/ext4/namei.c                    |   73 ++++++++++++++++++++++++++++++++++--
 fs/ext4/super.c                    |   17 ++++++++
 5 files changed, 123 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 3ae9bc9..fad70ea 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -404,6 +404,12 @@ dioread_nolock		locking. If the dioread_nolock option is specified
 i_version		Enable 64-bit inode version support. This option is
 			off by default.
 
+dx_read_ahead		Enables read-ahead of directory index blocks.
+			This option should be enabled if the filesystem several
+			directories with a high number of files. Disadvantage
+			is that on first access to a directory additional reads
+			come up, which might slow down other operations.
+
 Data Mode
 =========
 There are 3 different data modes:
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1921392..997323a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -916,6 +916,8 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
 #define EXT4_MOUNT_INIT_INODE_TABLE	0x80000000 /* Initialize uninitialized itables */
 
+#define EXT4_MOUNT2_DX_READ_AHEAD	0x00002 /* Read ahead directory index blocks */
+
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
 #define set_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt |= \
@@ -1802,6 +1804,7 @@ struct buffer_head *ext4_getblk(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
 struct buffer_head *ext4_bread(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
+int ext4_bread_ra(struct inode *inode, ext4_lblk_t block);
 int ext4_get_block(struct inode *inode, sector_t iblock,
 				struct buffer_head *bh_result, int create);
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a5763e3..938fb6c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1490,6 +1490,9 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 	return bh;
 }
 
+/*
+  * Synchronous read of blocks
+  */
 struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 			       ext4_lblk_t block, int create, int *err)
 {
@@ -1500,6 +1503,7 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 		return bh;
 	if (buffer_uptodate(bh))
 		return bh;
+
 	ll_rw_block(READ_META, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
@@ -1509,6 +1513,30 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 	return NULL;
 }
 
+/*
+ * Read-ahead blocks
+ */
+int ext4_bread_ra(struct inode *inode, ext4_lblk_t block)
+{
+	struct buffer_head *bh;
+	int err;
+
+	bh = ext4_getblk(NULL, inode, block, 0, &err);
+	if (!bh)
+		return -1;
+
+	if (buffer_uptodate(bh)) {
+		brelse(bh);
+		return 0;
+	}
+
+	ll_rw_block(READA, 1, &bh);
+
+	brelse(bh);
+	return 0;
+}
+
+
 static int walk_page_buffers(handle_t *handle,
 			     struct buffer_head *head,
 			     unsigned from,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index bfb749f..9643722 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -49,6 +49,8 @@
 #define NAMEI_RA_SIZE	     (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
 #define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
+#define NAMEI_RA_DX_BLOCKS  32 /* Better use BH_LRU_SIZE? */
+
 static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
 					ext4_lblk_t *block, int *err)
@@ -334,6 +336,50 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 #endif /* DX_DEBUG */
 
 /*
+ * Read ahead directory index blocks
+ */
+static void dx_ra_blocks(struct inode *dir, struct dx_entry *entries,
+			 struct dx_entry *at)
+{
+	int i, err = 0;
+	struct dx_entry *first_ra_entry = entries + 1;
+	unsigned num_entries = dx_get_count(entries) - 1;
+
+	if (num_entries < 2 || num_entries > dx_get_limit(entries)) {
+		dxtrace(printk("dx read-ahead: invalid number of entries:%d\n",
+			       num_entries));
+		return;
+	}
+
+	/* limit read ahead blocks */
+	if (num_entries > NAMEI_RA_DX_BLOCKS) {
+		int min = at - first_ra_entry; /* first_ra_entry + min = at */
+		int max = num_entries - min - 1; /* at + max = last_ra_entry */
+		int half_limit = NAMEI_RA_DX_BLOCKS >> 1;
+
+		min = min(min, half_limit);
+		max = min(max, half_limit);
+
+		first_ra_entry = at - min;
+
+		/* We do not use exactly NAMEI_RA_DX_BLOCKS here, as the logic
+		 * for min and max would be unnecessarily complex */
+		num_entries = min + max;
+	}
+
+	dxtrace(printk("dx read-ahead: %d entries in dir-ino %lu \n",
+			num_entries, dir->i_ino));
+
+	i = 0;
+	do {
+		struct dx_entry *entry = first_ra_entry + i;
+
+		err = ext4_bread_ra(dir, dx_get_block(entry));
+		i++;
+	 } while (i < num_entries && !err);
+}
+
+/*
  * Probe for a directory leaf block to search.
  *
  * dx_probe can return ERR_BAD_DX_DIR, which means there was a format
@@ -347,11 +393,12 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 	 struct dx_hash_info *hinfo, struct dx_frame *frame_in, int *err)
 {
 	unsigned count, indirect;
-	struct dx_entry *at, *entries, *p, *q, *m;
+	struct dx_entry *at, *entries, *ra_entries, *p, *q, *m;
 	struct dx_root *root;
 	struct buffer_head *bh;
 	struct dx_frame *frame = frame_in;
 	u32 hash;
+	bool did_ra = false;
 
 	frame->bh = NULL;
 	if (!(bh = ext4_bread (NULL,dir, 0, 0, err)))
@@ -390,7 +437,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		goto fail;
 	}
 
-	entries = (struct dx_entry *) (((char *)&root->info) +
+	ra_entries = entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
 
 	if (dx_get_limit(entries) != dx_root_limit(dir,
@@ -446,9 +493,27 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		frame->bh = bh;
 		frame->entries = entries;
 		frame->at = at;
-		if (!indirect--) return frame;
-		if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err)))
+
+		if (!did_ra && test_opt2(dir->i_sb, DX_READ_AHEAD)) {
+			/* read-ahead of dx blocks */
+			struct buffer_head *test_bh;
+			ext4_lblk_t block = dx_get_block(at);
+
+			test_bh = ext4_getblk(NULL, dir, block, 0, err);
+			if (test_bh && !buffer_uptodate(test_bh)) {
+				dx_ra_blocks(dir, ra_entries, at);
+				did_ra = true;
+			}
+			brelse(test_bh);
+		}
+
+		if (!indirect--)
+			return frame;
+
+		bh = ext4_bread(NULL, dir, dx_get_block(at), 0, err);
+		if (!bh)
 			goto fail2;
+
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
 		if (dx_get_limit(entries) != dx_node_limit (dir)) {
 			ext4_warning(dir->i_sb,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cc5c157..9dd7c05 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1119,6 +1119,9 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_printf(seq, ",init_inode_table=%u",
 			   (unsigned) sbi->s_li_wait_mult);
 
+	if (test_opt2(sb, DX_READ_AHEAD))
+		seq_puts(seq, ",dx_read_ahead");
+
 	ext4_show_quota_options(seq, sb);
 
 	return 0;
@@ -1294,6 +1297,7 @@ enum {
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard,
 	Opt_init_inode_table, Opt_noinit_inode_table,
+	Opt_dx_read_ahead,
 };
 
 static const match_table_t tokens = {
@@ -1369,6 +1373,8 @@ static const match_table_t tokens = {
 	{Opt_init_inode_table, "init_itable=%u"},
 	{Opt_init_inode_table, "init_itable"},
 	{Opt_noinit_inode_table, "noinit_itable"},
+	{Opt_dx_read_ahead, "dx_read_ahead=%u"},
+	{Opt_dx_read_ahead, "dx_read_ahead"},
 	{Opt_err, NULL},
 };
 
@@ -1859,6 +1865,17 @@ set_qf_format:
 		case Opt_noinit_inode_table:
 			clear_opt(sb, INIT_INODE_TABLE);
 			break;
+		case Opt_dx_read_ahead:
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				option = 1;	/* No argument, default to 1 */
+			if (option)
+				set_opt2(sb, DX_READ_AHEAD);
+			else
+				clear_opt2(sb, DX_READ_AHEAD);
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "

