Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59E340244F;
	Thu, 28 May 2026 17:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989524; cv=none; b=Azns+oKSoKFPeIVG2CTFHdjFr+q5ClwQrhOPv1LIu/1MqXc0mReX2+lB2Fh/i4JNy1DxYivjh+/t1omRlv1zDd7i6luJnwKtxGRaFOzeqiReHH4lscIe62ZfGSb7yGcH2n8Pz50n0b2dh0dan4x5wS0uZm/HviQtaDDRjDX0GHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989524; c=relaxed/simple;
	bh=JLR+FUCw7vXTsog0rvTQmaTcm9qASTMW9ZTtzz7U82M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAFChRS2Dvt6kV9bnfjhwGTGJjfsuTXFA9AETNwQOAiZMHjoLntPpDK3zLM3JKOqdYznJy+lNk0OJv5iTwGmCCumIRZkEOxKtZEDKyep8/wnWP+t8lP3agaKIuw2TqISEDBecVzm+9ZKz80uS/uk4hOGpf7OqhtXyy7jcbL/i1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YSC5RXAU; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YSC5RXAU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=EMb/MTlPG3R46Em2RFCIJE/HJ5giGndyfth5gxeWobY=; b=YSC5RXAUfWfQUrZStPRyIwT/Jy
	QcrBT7G+g1ihbsQtV9LV+orHCFh9tRta1WGTgIbg7lhUWOpm6MryrP23SqxDqMUkUPKWQJADelIaU
	xLWBHxtQfclC/4CGm+cC0ayfIgDIXo2tc0Ft4lZQ1Nh9vT9UrImWd6/nzhe0+PU+4Z9W0kiX0uPD6
	PqVfRIbqtFIficAJOMgzsciWFMAAEDZ/wlzyOit0gdSVDuX4ftr1OSl5pStvSjDsFFpIPfex8OZWW
	Ocn1kXmMs93KOBTYOkGzpAljlPxIDd5U/DS4riJUdGUXnD61arrQjXXVfWH6KpACRs6KJAkBBkoAR
	miqQ/KEA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaJ-00000004aZw-0mEt;
	Thu, 28 May 2026 17:31:55 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: [PATCH v2 16/34] jbd2: Convert journal commit to bh_submit()
Date: Thu, 28 May 2026 18:31:29 +0100
Message-ID: <20260528173150.1093780-17-willy@infradead.org>
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

Avoid an extra indirect function call by using bh_submit()
instead of submit_bh() in journal_submit_commit_record()
and jbd2_journal_commit_transaction().  These both use
journal_end_buffer_io_sync(), so it's more straightforward to do them
both at once.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/jbd2/commit.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 8cf61e7185c4..4e91593d27e5 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -29,8 +29,10 @@
 /*
  * IO end handler for temporary buffer_heads handling writes to the journal.
  */
-static void journal_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
+static void journal_end_buffer_io_sync(struct bio *bio)
 {
+	struct buffer_head *bh;
+	bool uptodate = bio_endio_bh(bio, &bh);
 	struct buffer_head *orig_bh = bh->b_private;
 
 	BUFFER_TRACE(bh, "");
@@ -147,13 +149,12 @@ static int journal_submit_commit_record(journal_t *journal,
 	lock_buffer(bh);
 	clear_buffer_dirty(bh);
 	set_buffer_uptodate(bh);
-	bh->b_end_io = journal_end_buffer_io_sync;
 
 	if (journal->j_flags & JBD2_BARRIER &&
 	    !jbd2_has_feature_async_commit(journal))
 		write_flags |= REQ_PREFLUSH | REQ_FUA;
 
-	submit_bh(write_flags, bh);
+	bh_submit(bh, write_flags, journal_end_buffer_io_sync);
 	*cbh = bh;
 	return 0;
 }
@@ -751,9 +752,9 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 				lock_buffer(bh);
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
-				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(REQ_OP_WRITE | JBD2_JOURNAL_REQ_FLAGS,
-					  bh);
+				bh_submit(bh,
+					REQ_OP_WRITE | JBD2_JOURNAL_REQ_FLAGS,
+					journal_end_buffer_io_sync);
 			}
 			cond_resched();
 
-- 
2.47.3

