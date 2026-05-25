Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2652D661C;
	Mon, 25 May 2026 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729585; cv=none; b=FNQoAq7rhW3HUkRf88Ym8iCWW1kD9jM9BtLc6uoNGZ0vw839kcQ9jPqxDZvSPf7LljzXdlLE/iFMiaGNyzR2/h7NJ9FjcP4Yk+ReXVr37lNCkt60peoGUpCtgFhzTf0ePa5KvAlsAlfdUA5XKSe3cGqzXZiytCjDt8PCYP1Zs1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729585; c=relaxed/simple;
	bh=jlNeI9iSF+t2IXwQvwKYZR2jXBcs9oO1/O7yErT4JEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJ4ICprN4rBJheQrATsU8CUVj+gw87iuj1Q5j9EZ8Q/IhhHo9SxRMwAem0WSL80ZzB2nG3hx4rfVDT6qvLdqXCuzsIuF+y54yWq+Bol+phW9piA3g1usEp32Yh/fxawOWdSvEoQKW6dCO8sPE3bk1mU4kENUWVcar5VjeVVKX2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eRtAm3Pp; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eRtAm3Pp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=UZvoKLSLU5GHpgt/KrnAWRP/eJnmEUt68fTrx7CzWik=; b=eRtAm3PpDNg0PY6hPANngQkCtO
	mUaZyktF8MY5S2fZ7O6ucO+NuiWZXa8lZRW1U8YSw5hL6a7+84ze0xoUDjNZQxE2pFLdukChOHoV8
	w3kD+wDLtkRlsaq/6Pp1Y1vQ7YkK0aDKFSN6zNEO92eA5Tarar90dZWI4e8GqhMqIULBDCCqUDZ31
	Oa6WHQpseJ14w2v4HlTLJlPNk3pxREmNPqzUtam5Wvw1D5DNU8xeOcrhUo4m4Q8nlZsnhm3RJQd0c
	FL0uxITuN/2TrDtkLTl7714Afwz28TmLwzCQT0m/qHZN5MdEwJJ6Nb809MCiNY/1/jQHgU9bQkJhC
	+xbBffWA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxp-0000000HOAu-2XCs;
	Mon, 25 May 2026 17:19:41 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 12/34] ext4; Convert __ext4_read_bh() to bh_submit()
Date: Mon, 25 May 2026 18:19:05 +0100
Message-ID: <20260525171931.4144395-13-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525171931.4144395-1-willy@infradead.org>
References: <20260525171931.4144395-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call by converting
ext4_end_bitmap_read() from bh_end_io_t to bio_end_io_t and
calling bh_submit().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/ext4.h   | 10 +++++-----
 fs/ext4/ialloc.c |  5 ++++-
 fs/ext4/super.c  | 11 ++++++-----
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..6af11f0ff1c5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2959,7 +2959,7 @@ extern unsigned long ext4_count_dirs(struct super_block *);
 extern void ext4_mark_bitmap_end(int start_bit, int end_bit, char *bitmap);
 extern int ext4_init_inode_table(struct super_block *sb,
 				 ext4_group_t group, int barrier);
-extern void ext4_end_bitmap_read(struct buffer_head *bh, int uptodate);
+void ext4_end_bitmap_read(struct bio *bio);
 
 /* fast_commit.c */
 int ext4_fc_info_show(struct seq_file *seq, void *v);
@@ -3184,10 +3184,10 @@ extern struct buffer_head *ext4_sb_bread_unmovable(struct super_block *sb,
 						   sector_t block);
 extern struct buffer_head *ext4_sb_bread_nofail(struct super_block *sb,
 						sector_t block);
-extern void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
-				bh_end_io_t *end_io, bool simu_fail);
-extern int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
-			bh_end_io_t *end_io, bool simu_fail);
+void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
+		bio_end_io_t end_io, bool simu_fail);
+int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
+		bio_end_io_t end_io, bool simu_fail);
 extern int ext4_read_bh_lock(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
 extern void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block);
 extern int ext4_seq_options_show(struct seq_file *seq, void *offset);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 3fd8f0099852..2db68b1bf855 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -66,8 +66,11 @@ void ext4_mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
 		memset(bitmap + (i >> 3), 0xff, (end_bit - i) >> 3);
 }
 
-void ext4_end_bitmap_read(struct buffer_head *bh, int uptodate)
+void ext4_end_bitmap_read(struct bio *bio)
 {
+	bool uptodate = bio->bi_status == BLK_STS_OK;
+	struct buffer_head *bh = bio_endio_bh(bio);
+
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 		set_bitmap_uptodate(bh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..fbe175951e01 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -161,7 +161,7 @@ MODULE_ALIAS("ext3");
 
 
 static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
-				  bh_end_io_t *end_io, bool simu_fail)
+				  bio_end_io_t end_io, bool simu_fail)
 {
 	if (simu_fail) {
 		clear_buffer_uptodate(bh);
@@ -176,13 +176,14 @@ static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
 	 */
 	clear_buffer_verified(bh);
 
-	bh->b_end_io = end_io ? end_io : end_buffer_read_sync;
+	if (!end_io)
+		end_io = bh_end_read;
 	get_bh(bh);
-	submit_bh(REQ_OP_READ | op_flags, bh);
+	bh_submit(bh, REQ_OP_READ | op_flags, end_io);
 }
 
 void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
-			 bh_end_io_t *end_io, bool simu_fail)
+			 bio_end_io_t end_io, bool simu_fail)
 {
 	BUG_ON(!buffer_locked(bh));
 
@@ -194,7 +195,7 @@ void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
 }
 
 int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
-		 bh_end_io_t *end_io, bool simu_fail)
+		 bio_end_io_t end_io, bool simu_fail)
 {
 	BUG_ON(!buffer_locked(bh));
 
-- 
2.47.3

