Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003633FCB29;
	Thu, 28 May 2026 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989523; cv=none; b=HSgb3j91Kt2vCTR4cb7fjHbcyg7sRYf/HWx4yHWEHp3joyOfT1Ugd/2smO2GdvqATO7eGMjdg21FPVjeBobKR1Aclp4xWUXp8uUZPIrV776QCjtIHGRWajr7KWqj6Gjq53ZKXjtkIImcnWiPJL/u1ikrKTxOOT7kU3B7KvjjKNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989523; c=relaxed/simple;
	bh=j9+vFYg9PdAgbU5p5ffMv598uTTnKLkcJhmwZXojk/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+7r4IxTBcFVIzqv8PJ08QnCVBV2njmWxIkzNZKVF/YbOqK86a2vxm0I2b/kTp17hisj4aZMPituvhzfDVukj3FybVIR6mbEKN9jIYbePoLXB13xa19mrH77cz141PlfSgwigZEUkIqXh6qwEjMmH1ju1z+8gC9O4Zytzsjb1Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wZJI6juq; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wZJI6juq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=O6qAz4hkXUPkm9NWV18w0UK3rMyy77K9n6kR3jEnO1o=; b=wZJI6juqoWvOHm17waNk1lUsHF
	5QPN4oKPrfSRkwOt8JZBcD8GnkRk6I4kQ26HxFKTCWRBo2KnCzFm9qiYlK+JDK/Z1+ztBmxssqKMT
	kOgXOcmGJu+cyl95l46iTlrizUwlC3d+NN89an2Uh82ABDIq4PSq5hvtxQ0zzjrP94phtEd6Wm4Vq
	DXQyFncq1uxJoGAO0KLB+64J1eU9ry73QPsaPYggaqpJzpFcjTxK8eygL3aivEbgwDzme4GUyAfyD
	tHk6enxMJ6gmbMMoSZwFpv7PUJV4YAh/1hSVHQeeo1TjGE7xaloMAMlGfbopLhPndSW0FPwLdQ5ut
	hEZdONTw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaJ-00000004aZo-03j5;
	Thu, 28 May 2026 17:31:55 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: [PATCH v2 15/34] ext4: Convert ext4_commit_super() to bh_submit()
Date: Thu, 28 May 2026 18:31:28 +0100
Message-ID: <20260528173150.1093780-16-willy@infradead.org>
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
by using bh_submit() instead of submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/super.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bc7faedcb8e4..7283108d7609 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6316,12 +6316,10 @@ static int ext4_commit_super(struct super_block *sb)
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
-	get_bh(sbh);
 	/* Clear potential dirty bit if it was journalled update */
 	clear_buffer_dirty(sbh);
-	sbh->b_end_io = end_buffer_write_sync;
-	submit_bh(REQ_OP_WRITE | REQ_SYNC |
-		  (test_opt(sb, BARRIER) ? REQ_FUA : 0), sbh);
+	bh_submit(sbh, REQ_OP_WRITE | REQ_SYNC |
+		  (test_opt(sb, BARRIER) ? REQ_FUA : 0), bh_end_write);
 	wait_on_buffer(sbh);
 	if (buffer_write_io_error(sbh)) {
 		ext4_msg(sb, KERN_ERR, "I/O error while writing "
-- 
2.47.3

