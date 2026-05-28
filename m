Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A563FBEBB;
	Thu, 28 May 2026 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989519; cv=none; b=YGx7OP51pD3D+0EtYj2lA7/lnZGmnc0wLUYyjDjeVWJoAAhiLYWA7bGM65Zj60Yl4hBQrSfbipqAcxxS+sD0cx5N379UHi1KU4Gil6IGfN5Vt5J5pufW+1nvtTfSArsnenykoZZSfQQcwo7sR1xxmWJB8l+YvwaeDMIeDVrX35o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989519; c=relaxed/simple;
	bh=Gm91jWduOfnhI8+/6UTxD8cm02esYu6qHeh+WuYzLDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suC39S5DIs67rabCryyIO7DJuSK74VVHFcZ5slbOdVgKx6DOkSb5ThHBRibuNy4De9NtAkoalG4jMwpm88ur542Ac8c/qyrdsB6VWW6v8ASGJxvtnQsoRnYWMrz06T5V+9/4Nq4z7YAH2JWDmv19mtSbX5rf4oeadGOJ0OPolak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=esifh6yJ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="esifh6yJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=WlWdaxDVooGfoYOtKdwpRRHCqbJVkX7nRVZIvsJi1f4=; b=esifh6yJmTVvqgTDEi+A4uWVRb
	s/YJg5WIJifAeorGYNJi54wzNQ2dMM2Ys7L7W8Y4WfteT8hjkCq6vSjn3b1Kmii1vwbdv6U+smdOo
	8skr8OmAlan7PyxqT7W4faRZYfY3G8Gl+QsVeun8LMfQTtvMRZ+d92uLahVYIvg/WtLer3r0NXRaC
	pnzj+jjKj7QBUckMVX9HWVfTXjs/ZvVqYtj6Fjw3ngLO4Q39qbsAGdGzAnesPljxO805E1Ifxp89e
	pexYm3M6j3U39/rJWUJsRm4xCty6m7fMzQT7SYUVKG0vedWYScmMJm7pT8Z6wcxcNTV9PeaZuxFni
	JEAe6mvw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaI-00000004aZQ-1O1k;
	Thu, 28 May 2026 17:31:54 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH v2 12/34] ext4; Convert __ext4_read_bh() to bh_submit()
Date: Thu, 28 May 2026 18:31:25 +0100
Message-ID: <20260528173150.1093780-13-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528173150.1093780-1-willy@infradead.org>
References: <20260528173150.1093780-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call and changing the buffer refcount
by converting ext4_end_bitmap_read() from bh_end_io_t to bio_end_io_t
and calling bh_submit().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/ext4.h   | 10 +++++-----
 fs/ext4/ialloc.c |  6 ++++--
 fs/ext4/super.c  | 12 ++++++------
 3 files changed, 15 insertions(+), 13 deletions(-)

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
index 3fd8f0099852..9aacd629a683 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -66,14 +66,16 @@ void ext4_mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
 		memset(bitmap + (i >> 3), 0xff, (end_bit - i) >> 3);
 }
 
-void ext4_end_bitmap_read(struct buffer_head *bh, int uptodate)
+void ext4_end_bitmap_read(struct bio *bio)
 {
+	struct buffer_head *bh;
+	bool uptodate = bio_endio_bh(bio, &bh);
+
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 		set_bitmap_uptodate(bh);
 	}
 	unlock_buffer(bh);
-	put_bh(bh);
 }
 
 static int ext4_validate_inode_bitmap(struct super_block *sb,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..bc7faedcb8e4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -161,7 +161,7 @@ MODULE_ALIAS("ext3");
 
 
 static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
-				  bh_end_io_t *end_io, bool simu_fail)
+				  bio_end_io_t end_io, bool simu_fail)
 {
 	if (simu_fail) {
 		clear_buffer_uptodate(bh);
@@ -176,13 +176,13 @@ static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
 	 */
 	clear_buffer_verified(bh);
 
-	bh->b_end_io = end_io ? end_io : end_buffer_read_sync;
-	get_bh(bh);
-	submit_bh(REQ_OP_READ | op_flags, bh);
+	if (!end_io)
+		end_io = bh_end_read;
+	bh_submit(bh, REQ_OP_READ | op_flags, end_io);
 }
 
 void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
-			 bh_end_io_t *end_io, bool simu_fail)
+			 bio_end_io_t end_io, bool simu_fail)
 {
 	BUG_ON(!buffer_locked(bh));
 
@@ -194,7 +194,7 @@ void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
 }
 
 int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
-		 bh_end_io_t *end_io, bool simu_fail)
+		 bio_end_io_t end_io, bool simu_fail)
 {
 	BUG_ON(!buffer_locked(bh));
 
-- 
2.47.3

