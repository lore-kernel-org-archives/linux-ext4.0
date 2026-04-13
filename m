Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9672253FC
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 06:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776061551; cv=none; b=WhNf5FMn6fK/ueoOPG9iPjJ6eZVfVW2cMT6OLSOWddTCt19H19/t7iXENyLnbDR1U1BR0tNQWByV/7CEYABnMijN/kYFq/c5h1xPc71YxoTkhexvjEf2AZPj9XciUbXMPbG4hfkOH3XIR8Y/sueOgW5H5wPISEXUs+3Cn1IGdgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776061551; c=relaxed/simple;
	bh=kWUJURp+uF9u4Y1dNuO0maD9jAqb/5vkOI1EQA+2rsc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HG9oKDzttpeEwUzus8pnF0bg1XLUEZRTnjFYlUdO3lQ0jf+2/3UhSujKXr8nA3qTRvWUM1b4Kc/epcd2vWwTcronzk3UmIdkLit14fOCxQKpLRIt1s7UTXrTlxi5UzfThdQup1MwKKdIpMPQpC8TTdP8yBynSxTvQExQskWI1zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HlSS97Zn; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HlSS97Zn"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82d0b68837aso2143930b3a.2
        for <linux-ext4@vger.kernel.org>; Sun, 12 Apr 2026 23:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776061549; x=1776666349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00cP/T9QeuySw5AlaNH1mzjkrGnGheu4JmbuNHs7ieI=;
        b=HlSS97ZnKtj1356sK3AsmZzPJIfuhEzwD7PuLWedrJSgTzFvASVpTvAzuyK8W4qiex
         POHE4f8Np9cR0UlHM8ZcaaExhKS6wIHedA03dRIM/HaeYSmvweGARpkOKMHK9XfK6WUd
         k+uQvBhU3T9X1i1Ufb+L6Td4hHzFBdZ645f6Q5PdM10eyzi8dVmeQJKQirMnKeE4GNoB
         LLhEVpJ0u+VrcEx+PJ9U/XSFVhk5YrKbUEiPLDkpD719s/EnRULPOsno4hasKY65+scf
         sARU1aOMJlH4l9Xstj3PB/PG00ysgN3SMEzUkMUjkWwVilAQvJfhdvresAYS3xzOz2+8
         w9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776061549; x=1776666349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=00cP/T9QeuySw5AlaNH1mzjkrGnGheu4JmbuNHs7ieI=;
        b=TDkYWsNV/0hy7lSAYO4vm7Pg5dK6tizRQHC/qro4DmQFiLPgtZK39MnuIzBaQMDTSa
         lYQhcgIWsRptKL88ct47tGvIQXsrGcAS3/lKn3ErJ72irJUM583c2hSuR2qfAibROWtA
         UD1dVf85JEqd7vGRuXQfpO21+41tfKGI561a5WUs3AS00/d8Zlf6rpFYY7omL9qW4cbq
         sb1ZDaHlMtNYwZ5BzJrWDNLGZPRLB3X2B1JROU9mz4z7SZ+yELlxtpHA07XatBhPzF0F
         CVThQgs+ld+XqBX3idVvThDXkvwFYp3QHDBKsXwsu0P5KhjaET9m8twLyB9bN5OAoIkA
         7EzA==
X-Gm-Message-State: AOJu0YyGEOjRScLSIBRclXx9PGg9euxrfU3KwuvIz7dlMlRi+5xsNCqn
	mh+IA4K/6b9P1wyZtOTCo5vQrVIm/mTRkqpueD9giAhfTYfiPQ7mFjIj
X-Gm-Gg: AeBDieuKYsbPlY59a6nGbLC3izNLzftletFJ2RzEhZtcqbClwZ70CJWNHGqu/MPV/L2
	LO7FY1EHpv1+K++YA3Xj/ArcPGn7Htv1gZACYeVI45XGDAUkT9GdO3LgdQaibP12kXnx13t6RuH
	gv3nqg16P1TBlr5lcjOCYI+7loNJWDhYItl+gsb/3JbqsU6U1fD3OmBW0GaZR8s9wOIYNl2WjTx
	OV/Xdf5Gjn3tfoC6XQFNfKPgE1IBGwaHrzMcUTn+teJUW8FpkbO3dzjXJF9GnYIY73zjdnCmMUw
	/xrfjNBlKHDPXhmQuKpf3n836E7Qrge/qavFFnkAWlfqlqCIqP41MArRB5G/0VEdwTcSc3JxCNy
	+Z5yu9RFJYRqypBnWxhh8X156+va9RgOWRfgdgfkMbQL5tULOwnNGnmD5jP3Sn/R8ghpbGf2iGE
	06QSOzQqyIOQDxX/Zs2tPZDLDH4Hi0+Y0RvI4+
X-Received: by 2002:a05:6a00:2e9d:b0:82f:48e:2421 with SMTP id d2e1a72fcca58-82f0c29c84amr12217294b3a.24.1776061549283;
        Sun, 12 Apr 2026 23:25:49 -0700 (PDT)
Received: from n37-098-250.byted.org ([115.190.40.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c20aed6sm10035640b3a.0.2026.04.12.23.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 23:25:48 -0700 (PDT)
From: Diangang Li <diangangli@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	changfengnan@bytedance.com,
	yizhang089@gmail.com,
	willy@infradead.org,
	Diangang Li <lidiangang@bytedance.com>
Subject: [RFC v2 1/1] ext4: fail fast on repeated buffer_head reads after IO failure
Date: Mon, 13 Apr 2026 14:25:00 +0800
Message-Id: <20260413062500.1380307-2-diangangli@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260413062500.1380307-1-diangangli@gmail.com>
References: <20260325093349.630193-1-diangangli@gmail.com>
 <20260413062500.1380307-1-diangangli@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Diangang Li <lidiangang@bytedance.com>

ext4 buffer_head reads serialize on BH_Lock. If a read fails, the buffer
remains !Uptodate. With concurrent callers, each waiter may resubmit the
same failing read after the previous holder drops BH_Lock. This can turn
a single read error into long stalls and hung tasks.

The block layer already retries reads. After it gives up, re-submitting
the same buffer_head read from ext4 makes no forward progress and just
keeps waiters serialized on BH_Lock.

Record read failures on buffer_head (BH_Read_EIO + b_err_timestamp) and,
when a retry window is configured (sysfs: err_retry_sec), fail fast for
repeated ext4 buffer_head reads within the window. Clear the state on
successful completion so the buffer can recover.

err_retry_sec defaults to 0, which keeps the current behavior (subsequent
callers may retry the same read). Set it to a non-zero value to throttle
repeated reads within the window.

Example hung stacks:

  INFO: task toutiao.infra.t:3760933 blocked for more than 327 seconds.
  Call Trace:
   __schedule
   io_schedule
   __wait_on_bit_lock
   bh_uptodate_or_lock
   __read_extent_tree_block
   ext4_find_extent
   ext4_ext_map_blocks
   ext4_map_blocks
   ext4_getblk
   ext4_bread
   __ext4_read_dirblock
   dx_probe
   ext4_htree_fill_tree
   ext4_readdir
   iterate_dir
   ksys_getdents64

  INFO: task toutiao.infra.t:2724456 blocked for more than 327 seconds.
  Call Trace:
   __schedule
   io_schedule
   __wait_on_bit_lock
   ext4_read_bh_lock
   ext4_bread
   __ext4_read_dirblock
   htree_dirblock_to_tree
   ext4_htree_fill_tree
   ext4_readdir
   iterate_dir
   ksys_getdents64

Signed-off-by: Diangang Li <lidiangang@bytedance.com>
---
 fs/buffer.c                 |  2 ++
 fs/ext4/balloc.c            |  2 +-
 fs/ext4/ext4.h              | 13 ++++++----
 fs/ext4/extents.c           |  2 +-
 fs/ext4/ialloc.c            |  3 ++-
 fs/ext4/indirect.c          |  2 +-
 fs/ext4/inode.c             | 10 ++++----
 fs/ext4/mmp.c               |  2 +-
 fs/ext4/move_extent.c       |  2 +-
 fs/ext4/resize.c            |  2 +-
 fs/ext4/super.c             | 51 +++++++++++++++++++++++++++----------
 fs/ext4/sysfs.c             |  2 ++
 include/linux/buffer_head.h | 16 ++++++++++++
 13 files changed, 79 insertions(+), 30 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 22b43642ba574..10b1f60368db4 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -159,6 +159,7 @@ static void __end_buffer_read_notouch(struct buffer_head *bh, int uptodate)
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
 {
 	put_bh(bh);
+	bh_update_read_io_error(bh, uptodate, jiffies);
 	__end_buffer_read_notouch(bh, uptodate);
 }
 EXPORT_SYMBOL(end_buffer_read_sync);
@@ -167,6 +168,7 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 {
 	if (uptodate) {
 		set_buffer_uptodate(bh);
+		bh_update_read_io_error(bh, 1, jiffies);
 	} else {
 		buffer_io_error(bh, ", lost sync page write");
 		mark_buffer_write_io_error(bh);
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 8040c731b3e45..8d7797adbb63e 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -548,7 +548,7 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group,
 	 */
 	set_buffer_new(bh);
 	trace_ext4_read_block_bitmap_load(sb, block_group, ignore_locked);
-	ext4_read_bh_nowait(bh, REQ_META | REQ_PRIO |
+	ext4_read_bh_nowait(sb, bh, REQ_META | REQ_PRIO |
 			    (ignore_locked ? REQ_RAHEAD : 0),
 			    ext4_end_bitmap_read,
 			    ext4_simulate_fail(sb, EXT4_SIM_BBITMAP_EIO));
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7617e2d454ea5..4b6ff26201933 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1682,6 +1682,8 @@ struct ext4_sb_info {
 	struct timer_list s_err_report;
 	/* timeout in seconds for s_err_report; 0 disables the timer. */
 	unsigned long s_err_report_sec;
+	/* timeout in seconds for read error retry window; 0 disables. */
+	unsigned long s_err_retry_sec;
 
 	/* Lazy inode table initialization info */
 	struct ext4_li_request *s_li_request;
@@ -3185,11 +3187,12 @@ extern struct buffer_head *ext4_sb_bread_unmovable(struct super_block *sb,
 						   sector_t block);
 extern struct buffer_head *ext4_sb_bread_nofail(struct super_block *sb,
 						sector_t block);
-extern void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
-				bh_end_io_t *end_io, bool simu_fail);
-extern int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
-			bh_end_io_t *end_io, bool simu_fail);
-extern int ext4_read_bh_lock(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
+extern void ext4_read_bh_nowait(struct super_block *sb, struct buffer_head *bh,
+				blk_opf_t op_flags, bh_end_io_t *end_io, bool simu_fail);
+extern int ext4_read_bh(struct super_block *sb, struct buffer_head *bh,
+			blk_opf_t op_flags, bh_end_io_t *end_io, bool simu_fail);
+extern int ext4_read_bh_lock(struct super_block *sb, struct buffer_head *bh,
+			blk_opf_t op_flags, bool wait);
 extern void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block);
 extern int ext4_seq_options_show(struct seq_file *seq, void *offset);
 extern int ext4_calculate_overhead(struct super_block *sb);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8cce1479be6d1..b7fb195ded3e3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -567,7 +567,7 @@ __read_extent_tree_block(const char *function, unsigned int line,
 
 	if (!bh_uptodate_or_lock(bh)) {
 		trace_ext4_ext_load_extent(inode, pblk, _RET_IP_);
-		err = ext4_read_bh(bh, 0, NULL, false);
+		err = ext4_read_bh(inode->i_sb, bh, 0, NULL, false);
 		if (err < 0)
 			goto errout;
 	}
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index b1bc1950c9f03..25a177eb89bf1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -72,6 +72,7 @@ void ext4_end_bitmap_read(struct buffer_head *bh, int uptodate)
 		set_buffer_uptodate(bh);
 		set_bitmap_uptodate(bh);
 	}
+	bh_update_read_io_error(bh, uptodate, jiffies);
 	unlock_buffer(bh);
 	put_bh(bh);
 }
@@ -193,7 +194,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 	 * submit the buffer_head for reading
 	 */
 	trace_ext4_load_inode_bitmap(sb, block_group);
-	ext4_read_bh(bh, REQ_META | REQ_PRIO,
+	ext4_read_bh(sb, bh, REQ_META | REQ_PRIO,
 		     ext4_end_bitmap_read,
 		     ext4_simulate_fail(sb, EXT4_SIM_IBITMAP_EIO));
 	if (!buffer_uptodate(bh)) {
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index da76353b3a575..1ff2b5872e8b0 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -170,7 +170,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 		}
 
 		if (!bh_uptodate_or_lock(bh)) {
-			if (ext4_read_bh(bh, 0, NULL, false) < 0) {
+			if (ext4_read_bh(sb, bh, 0, NULL, false) < 0) {
 				put_bh(bh);
 				goto failure;
 			}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1123d995494b5..49c03c485a8d5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1053,7 +1053,7 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 	if (!bh || ext4_buffer_uptodate(bh))
 		return bh;
 
-	ret = ext4_read_bh_lock(bh, REQ_META | REQ_PRIO, true);
+	ret = ext4_read_bh_lock(inode->i_sb, bh, REQ_META | REQ_PRIO, true);
 	if (ret) {
 		put_bh(bh);
 		return ERR_PTR(ret);
@@ -1079,7 +1079,7 @@ int ext4_bread_batch(struct inode *inode, ext4_lblk_t block, int bh_count,
 	for (i = 0; i < bh_count; i++)
 		/* Note that NULL bhs[i] is valid because of holes. */
 		if (bhs[i] && !ext4_buffer_uptodate(bhs[i]))
-			ext4_read_bh_lock(bhs[i], REQ_META | REQ_PRIO, false);
+			ext4_read_bh_lock(inode->i_sb, bhs[i], REQ_META | REQ_PRIO, false);
 
 	if (!wait)
 		return 0;
@@ -1239,7 +1239,7 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 		    !buffer_unwritten(bh) &&
 		    (block_start < from || block_end > to)) {
-			ext4_read_bh_lock(bh, 0, false);
+			ext4_read_bh_lock(inode->i_sb, bh, 0, false);
 			wait[nr_wait++] = bh;
 		}
 	}
@@ -4063,7 +4063,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		set_buffer_uptodate(bh);
 
 	if (!buffer_uptodate(bh)) {
-		err = ext4_read_bh_lock(bh, 0, true);
+		err = ext4_read_bh_lock(inode->i_sb, bh, 0, true);
 		if (err)
 			goto unlock;
 		if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
@@ -4891,7 +4891,7 @@ static int __ext4_get_inode_loc(struct super_block *sb, unsigned long ino,
 	 * Read the block from disk.
 	 */
 	trace_ext4_load_inode(sb, ino);
-	ext4_read_bh_nowait(bh, REQ_META | REQ_PRIO, NULL,
+	ext4_read_bh_nowait(sb, bh, REQ_META | REQ_PRIO, NULL,
 			    ext4_simulate_fail(sb, EXT4_SIM_INODE_EIO));
 	blk_finish_plug(&plug);
 	wait_on_buffer(bh);
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 6f57c181ff778..6407b7fbdd3e8 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -90,7 +90,7 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 	}
 
 	lock_buffer(*bh);
-	ret = ext4_read_bh(*bh, REQ_META | REQ_PRIO, NULL, false);
+	ret = ext4_read_bh(sb, *bh, REQ_META | REQ_PRIO, NULL, false);
 	if (ret)
 		goto warn_exit;
 
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index ce1f738dff938..a304352a0741f 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -162,7 +162,7 @@ static int mext_folio_mkuptodate(struct folio *folio, size_t from, size_t to)
 			unlock_buffer(bh);
 			continue;
 		}
-		ext4_read_bh_nowait(bh, 0, NULL, false);
+		ext4_read_bh_nowait(inode->i_sb, bh, 0, NULL, false);
 		nr++;
 	} while (block++, (bh = bh->b_this_page) != head);
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 2c5b851c552a6..0350e85cc58fb 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1299,7 +1299,7 @@ static struct buffer_head *ext4_get_bitmap(struct super_block *sb, __u64 block)
 	if (unlikely(!bh))
 		return NULL;
 	if (!bh_uptodate_or_lock(bh)) {
-		if (ext4_read_bh(bh, 0, NULL, false) < 0) {
+		if (ext4_read_bh(sb, bh, 0, NULL, false) < 0) {
 			brelse(bh);
 			return NULL;
 		}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a34efb44e73d7..c0e4d8106e4f3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -160,8 +160,26 @@ MODULE_ALIAS("ext3");
 #define IS_EXT3_SB(sb) ((sb)->s_type == &ext3_fs_type)
 
 
-static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
-				  bh_end_io_t *end_io, bool simu_fail)
+static bool ext4_bh_throttle_read(struct super_block *sb, struct buffer_head *bh)
+{
+	unsigned long retry_sec = EXT4_SB(sb)->s_err_retry_sec;
+
+	if (!retry_sec || !buffer_read_io_error(bh))
+		return false;
+
+	if (bh->b_err_timestamp &&
+	    time_before(jiffies, bh->b_err_timestamp +
+			secs_to_jiffies(retry_sec)))
+		return true;
+
+	clear_buffer_read_io_error(bh);
+	bh->b_err_timestamp = 0;
+	return false;
+}
+
+static inline void __ext4_read_bh(struct super_block *sb, struct buffer_head *bh,
+				  blk_opf_t op_flags, bh_end_io_t *end_io,
+				  bool simu_fail)
 {
 	if (simu_fail) {
 		clear_buffer_uptodate(bh);
@@ -169,6 +187,12 @@ static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
 		return;
 	}
 
+	if (ext4_bh_throttle_read(sb, bh)) {
+		clear_buffer_uptodate(bh);
+		unlock_buffer(bh);
+		return;
+	}
+
 	/*
 	 * buffer's verified bit is no longer valid after reading from
 	 * disk again due to write out error, clear it to make sure we
@@ -181,8 +205,8 @@ static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
 	submit_bh(REQ_OP_READ | op_flags, bh);
 }
 
-void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
-			 bh_end_io_t *end_io, bool simu_fail)
+void ext4_read_bh_nowait(struct super_block *sb, struct buffer_head *bh,
+			 blk_opf_t op_flags, bh_end_io_t *end_io, bool simu_fail)
 {
 	BUG_ON(!buffer_locked(bh));
 
@@ -190,11 +214,11 @@ void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
 		unlock_buffer(bh);
 		return;
 	}
-	__ext4_read_bh(bh, op_flags, end_io, simu_fail);
+	__ext4_read_bh(sb, bh, op_flags, end_io, simu_fail);
 }
 
-int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
-		 bh_end_io_t *end_io, bool simu_fail)
+int ext4_read_bh(struct super_block *sb, struct buffer_head *bh,
+		 blk_opf_t op_flags, bh_end_io_t *end_io, bool simu_fail)
 {
 	BUG_ON(!buffer_locked(bh));
 
@@ -203,7 +227,7 @@ int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
 		return 0;
 	}
 
-	__ext4_read_bh(bh, op_flags, end_io, simu_fail);
+	__ext4_read_bh(sb, bh, op_flags, end_io, simu_fail);
 
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
@@ -211,14 +235,15 @@ int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
 	return -EIO;
 }
 
-int ext4_read_bh_lock(struct buffer_head *bh, blk_opf_t op_flags, bool wait)
+int ext4_read_bh_lock(struct super_block *sb, struct buffer_head *bh,
+		      blk_opf_t op_flags, bool wait)
 {
 	lock_buffer(bh);
 	if (!wait) {
-		ext4_read_bh_nowait(bh, op_flags, NULL, false);
+		ext4_read_bh_nowait(sb, bh, op_flags, NULL, false);
 		return 0;
 	}
-	return ext4_read_bh(bh, op_flags, NULL, false);
+	return ext4_read_bh(sb, bh, op_flags, NULL, false);
 }
 
 /*
@@ -240,7 +265,7 @@ static struct buffer_head *__ext4_sb_bread_gfp(struct super_block *sb,
 	if (ext4_buffer_uptodate(bh))
 		return bh;
 
-	ret = ext4_read_bh_lock(bh, REQ_META | op_flags, true);
+	ret = ext4_read_bh_lock(sb, bh, REQ_META | op_flags, true);
 	if (ret) {
 		put_bh(bh);
 		return ERR_PTR(ret);
@@ -282,7 +307,7 @@ void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block)
 
 	if (likely(bh)) {
 		if (trylock_buffer(bh))
-			ext4_read_bh_nowait(bh, REQ_RAHEAD, NULL, false);
+			ext4_read_bh_nowait(sb, bh, REQ_RAHEAD, NULL, false);
 		brelse(bh);
 	}
 }
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 923b375e017fa..21fed223c9e86 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -249,6 +249,7 @@ EXT4_ATTR_OFFSET(mb_group_prealloc, 0644, clusters_in_group,
 EXT4_ATTR_OFFSET(mb_best_avail_max_trim_order, 0644, mb_order,
 		 ext4_sb_info, s_mb_best_avail_max_trim_order);
 EXT4_ATTR_OFFSET(err_report_sec, 0644, err_report_sec, ext4_sb_info, s_err_report_sec);
+EXT4_RW_ATTR_SBI_UL(err_retry_sec, s_err_retry_sec);
 EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
 EXT4_RW_ATTR_SBI_UI(mb_stats, s_mb_stats);
 EXT4_RW_ATTR_SBI_UI(mb_max_to_scan, s_mb_max_to_scan);
@@ -342,6 +343,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(sb_update_sec),
 	ATTR_LIST(sb_update_kb),
 	ATTR_LIST(err_report_sec),
+	ATTR_LIST(err_retry_sec),
 	NULL,
 };
 ATTRIBUTE_GROUPS(ext4);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index b16b88bfbc3e7..77e42e706d1e5 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -29,6 +29,7 @@ enum bh_state_bits {
 	BH_Delay,	/* Buffer is not yet allocated on disk */
 	BH_Boundary,	/* Block is followed by a discontiguity */
 	BH_Write_EIO,	/* I/O error on write */
+	BH_Read_EIO,	/* I/O error on read */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */
 	BH_Meta,	/* Buffer contains metadata */
@@ -79,6 +80,7 @@ struct buffer_head {
 	spinlock_t b_uptodate_lock;	/* Used by the first bh in a page, to
 					 * serialise IO completion of other
 					 * buffers in the page */
+	unsigned long b_err_timestamp;	/* timestamp of last IO error (jiffies) */
 };
 
 /*
@@ -132,11 +134,25 @@ BUFFER_FNS(Async_Write, async_write)
 BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
+BUFFER_FNS(Read_EIO, read_io_error)
 BUFFER_FNS(Unwritten, unwritten)
 BUFFER_FNS(Meta, meta)
 BUFFER_FNS(Prio, prio)
 BUFFER_FNS(Defer_Completion, defer_completion)
 
+static __always_inline void bh_update_read_io_error(struct buffer_head *bh,
+						    int uptodate,
+						    unsigned long now)
+{
+	if (uptodate) {
+		clear_buffer_read_io_error(bh);
+		bh->b_err_timestamp = 0;
+	} else if (!buffer_read_io_error(bh)) {
+		set_buffer_read_io_error(bh);
+		bh->b_err_timestamp = now;
+	}
+}
+
 static __always_inline void set_buffer_uptodate(struct buffer_head *bh)
 {
 	/*
-- 
2.39.5

