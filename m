Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416E3314B9D;
	Mon, 25 May 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729586; cv=none; b=dtmQ3TesNej1TOH885rkdajR6NKGWHG6d7svndrGYf2iHk0Vjhy1/VoVjyxMHtbRaoXj7fNj30nS1CR4WetuY2GS+xnK1ccbDkkfnIW39mnFCZKlAmsWt0/4NYSj6QoKaYEnZ4NSOWbCxjvSXv9MdzaSk0JfvPz6LD8CuGvcoh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729586; c=relaxed/simple;
	bh=TjViJG1xMSQ2RL931Zyzt8jqEWf6HNJI1Y0ECMjwR4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F54OBDogT39EoOUfXDgfZ1MXQf6rlN8rxM1EOGhE6XrRB2+WsjsYa8UO2vAz9nL7U+RRLeawOhGz1qLctb0AXDtl2v25SbQh3FKux2Ai0V+lOxym2dJgWbMCeo+IL1VPNmhxELyGMfw3ClENzAqjp3IiiVJAAQhyyel67LEsQBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hMFiPnq/; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hMFiPnq/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=LGlIoRknXmWGwguSDp/ILB4/vG73Bql6iI0Hkc82ofk=; b=hMFiPnq/m1t7HvXdUOSJeJX848
	j0DE9sXjr7mguOo4pQ1JEjANo94fNepfclR1NJTdborQBhEUq4mKJNZlhNSSUy7mvZNF+Sz14MvY9
	RAWNbdBr/xXIsmNETWpD44kgV23K9/nKxH5c6BWiQdhQkgYdOSurUDkXsVRrsAlGStc5dtZezxPo1
	J9IeQBDeyaoUnPMCbab3JSqYgQWbAKDGm19X3dVjkV0NLeweourKvM9su+Wj1Yi3mlLPdA5QHIERk
	c6C3uf8KBFjYxeTV71nB8Ey3nJPjijOAOfgwxuW20pkMQcs2eMSuv47nTQ1dqzKt2NSM/p7VplO2H
	yVsFQxbQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxq-0000000HOBQ-278f;
	Mon, 25 May 2026 17:19:42 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 16/34] jbd2: Convert journal commit to bh_submit()
Date: Mon, 25 May 2026 18:19:09 +0100
Message-ID: <20260525171931.4144395-17-willy@infradead.org>
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

Avoid an extra indirect function call by using bh_submit()
instead of submit_bh() in journal_submit_commit_record()
and jbd2_journal_commit_transaction().  These both use
journal_end_buffer_io_sync(), so it's more straightforward to do them
both at once.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-ext4@vger.kernel.org
---
 fs/jbd2/commit.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 8cf61e7185c4..38f318bb4279 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -29,8 +29,10 @@
 /*
  * IO end handler for temporary buffer_heads handling writes to the journal.
  */
-static void journal_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
+static void journal_end_buffer_io_sync(struct bio *bio)
 {
+	bool uptodate = bio->bi_status == BLK_STS_OK;
+	struct buffer_head *bh = bio_endio_bh(bio);
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

