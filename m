Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FD930E0C0;
	Mon, 25 May 2026 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729586; cv=none; b=Ytg4qDX4zEpOs2c3dzPABL938pch8g9P/OCd1IsXpXybIpG0TwYQ92+v1qfddhR7EB1Ukss1sXdNDAVnxNlMGC2kTGZ9ZS+KnY33IOsJfaumr6MduKaJ5S0gg/ZomrFAMkjz5UzZzLeTaqWvZATeEEGD9+SLTahpvIb7qZiqqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729586; c=relaxed/simple;
	bh=Hi/LUjD/jrGSw7G9jrC8TVFrhoJ6qNggQo+/sEdnVvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srL/ay79EPD9mQd7IPvCPsZkGlCOI50PMR5FLZxJRRis98XfliuI5vxUkxbZtoPlqvo6PDYoeWQyB7hpJCTMzhxH8Z5mOVFqmblaGqMU6vULMV3yf4Qw1dxJ7RZ0WnIvVXLaC+W5nwkzp1jp2PIGglrxLIga6sHvprSYiosRzlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GSU9Ulm/; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GSU9Ulm/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=J7KPQtAtQ5hTGnjWTQE3bwtS/h46m2gWXuNz5P73NFQ=; b=GSU9Ulm/UjGhlEnZLRLU6fT1hI
	d0asz0tIsn3QGJgFTnoIIH6farh24nu61mvJrncHakq1j6kEiYyne5QvkTHm+RsoMPiTcrVbIn/aq
	xVCV1b4L5TAufcxgCoKGP/VqseUstaUgbphXOPaYmQoisSsRLIEM7LfAw3QAhGi8Nqjsm4ucm+fno
	ijF6UxAoSDHl8H8faifI1HQVIlrPmp6ebRK82QwqijVagJMAi2E/djAAHmpkq8kz0Yk/744dfNHaY
	RyGVknhRbBmJ94zKBgD4sQh+n4svmf62jRkDtTn1HjXgQgqpcpue9ofALPsTPQn7i/7tkGURaLsIt
	QuWA/cbg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxp-0000000HOB2-3Nhc;
	Mon, 25 May 2026 17:19:41 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 13/34] ext4: Convert ext4_fc_submit_bh() to bh_submit()
Date: Mon, 25 May 2026 18:19:06 +0100
Message-ID: <20260525171931.4144395-14-willy@infradead.org>
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
ext4_end_buffer_io_sync() from bh_end_io_t to bio_end_io_t and
calling bh_submit().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/fast_commit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index b3c22636251d..d52c64adf416 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -184,8 +184,11 @@
 #include <trace/events/ext4.h>
 static struct kmem_cache *ext4_fc_dentry_cachep;
 
-static void ext4_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
+static void ext4_end_buffer_io_sync(struct bio *bio)
 {
+	bool uptodate = bio->bi_status == BLK_STS_OK;
+	struct buffer_head *bh = bio_endio_bh(bio);
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

