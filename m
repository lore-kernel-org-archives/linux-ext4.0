Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8163C279336;
	Thu, 28 May 2026 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989519; cv=none; b=f38h8czqP+XKmKC3BErhG8jS2JJC1f/nWtSt/EDUBF9bWUC2CxALqkTzrabZ7oAvcWXqP03Wj3KBgIsL7p3eIE0hgLYjqVw7Lvoz1QcisWgdRkMGnNYr7v1AX3Y7YswEFkE2ZQVXAIcBB9Okf6Hfvdg3UIiZ1DIslKZpc4RLCpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989519; c=relaxed/simple;
	bh=0BnoYl7wVlDTi20krnGbnFtBCTFQ85NE4wYjx2LGoyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ua8lQIth87C3yuhdjjKVr1uSLve82UdUDFt2B7keSlbMWLYkphgim05WSUU+ym6KPXlIR9Zt8wlfymCeJcyuAi7/ZloCU2SMHocYtfN7BjlDxuYJiMpiiEtZBYHPaj6MtFqH3bX/aKoYFPsDFAEqoq7dT0J3Gwfi3lf7KZ6k9FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WGBjKgpt; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WGBjKgpt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=t747gnx/7KLHL5+//ucmWgSj0VbHT81OdbU+FJZ+4og=; b=WGBjKgptD/+eECPuH8qxZA5V/y
	cWGiQo0epYw+ksuVuNU/X/lOqME0eZyjpDf/wvlCdJEonmy9Qk2tCqBKPeiuwpDMKnm4JApcc4Dis
	33xqKISkCfAtZj8EmYi/yURXjjuqV7MXDFa70txCPXYA+vtu1EE98JHHCba/tXhno9iNi9KN+SQkV
	ZyZG6SWOd+5PIRQw5EZsNAdGZfzmMnRr7SkcXO0QGtf7Qaca2x0tUa8FVFWzmnxRh7IBY7krfRaVg
	SIe3lvnsW5v/62DVIoW/39vSU5tPc8efBuedLQazgAMzqq6ROIVRTNpw2imUyIq8PSy5Q+/SQolip
	FYHsEQ0g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaI-00000004aZY-2HKR;
	Thu, 28 May 2026 17:31:54 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH v2 13/34] ext4: Convert ext4_fc_submit_bh() to bh_submit()
Date: Thu, 28 May 2026 18:31:26 +0100
Message-ID: <20260528173150.1093780-14-willy@infradead.org>
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

Avoid an extra indirect function call by converting
ext4_end_buffer_io_sync() from bh_end_io_t to bio_end_io_t and
calling bh_submit().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/fast_commit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index b3c22636251d..5773b85e43cb 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -184,8 +184,11 @@
 #include <trace/events/ext4.h>
 static struct kmem_cache *ext4_fc_dentry_cachep;
 
-static void ext4_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
+static void ext4_end_buffer_io_sync(struct bio *bio)
 {
+	struct buffer_head *bh;
+	bool uptodate = bio_endio_bh(bio, &bh);
+
 	BUFFER_TRACE(bh, "");
 	if (uptodate) {
 		ext4_debug("%s: Block %lld up-to-date",
@@ -659,8 +662,7 @@ static void ext4_fc_submit_bh(struct super_block *sb, bool is_tail)
 	lock_buffer(bh);
 	set_buffer_dirty(bh);
 	set_buffer_uptodate(bh);
-	bh->b_end_io = ext4_end_buffer_io_sync;
-	submit_bh(REQ_OP_WRITE | write_flags, bh);
+	bh_submit(bh, REQ_OP_WRITE | write_flags, ext4_end_buffer_io_sync);
 	EXT4_SB(sb)->s_fc_bh = NULL;
 }
 
-- 
2.47.3

