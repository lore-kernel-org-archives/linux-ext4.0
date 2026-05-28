Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331BA3FD973;
	Thu, 28 May 2026 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989522; cv=none; b=mNifENUv+fv6PvX51OztrcJxkMPFbTiOVxglfX9icVXotCfeCy+WeQIHX9+IH8Qrd/Ab3KmlU0uIKsRZajDpWfopnaFNY/nh9yPLCshImjz2yP9ibsk6/6BUT2g3OXnfdPn/788fTr/4l27ro7yJbwOPQwgmfvVurVF7i5vWi+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989522; c=relaxed/simple;
	bh=k2yPX/T10Y7NIB4sIiS7NNTm2tCkY3cQwAYmvVQ87Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSqbs46aP/QdupqdPzqwqz/J0SF9DwL3kctiBDKGPjvARA4ZUAxbEN651AbCdSoXYSQcau78j3Rg+wRdIYPai4QUWtnkQ/xJmSy1JOqGHAFPEIZO/KXptEcCe5GoQVBS6zknazERB6uyuVS6GY/BFlM0Oyopge9fbDWJJdo/UDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XljQgIx6; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XljQgIx6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=62tTeO7LuteECL7Gx4q/6yV2TLjmH43o71UVBscv4hY=; b=XljQgIx66gDPA+wE4bDBhViUzK
	xDqSlolvpN5KLyh0YmqETiFyQWG4fA8TmC2RUMaVWO1mQBD0A6LTW3p+W7JL9bRyC+QYpn/5w13tP
	uKhW9B2R7Jz9QfxJWHGVuGuCraO6Lh+J8h8KUzOVw2eSwWgg1noEiw1CkQN2GL8HN7nOVrjeD0Z61
	np0XmIwdKRtySg5QR6VpG+lF4GMJ50EiBI0odN+FDX361LGWWY1+i+cCyRQBnXR31CSzZi+ZrRYfM
	rrxg7zeapR3wXySFMQDKTEk45wX6LvEY+fimaqAGjfPctri9CiUT7Z61b+cqAVlsRbx7UD9/LlYmi
	1DC5l1iQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaJ-00000004aZy-1a2I;
	Thu, 28 May 2026 17:31:55 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: [PATCH v2 17/34] jbd2: Convert jbd2_write_superblock() to bh_submit()
Date: Thu, 28 May 2026 18:31:30 +0100
Message-ID: <20260528173150.1093780-18-willy@infradead.org>
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
 fs/jbd2/journal.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4f397fcdb13c..2040af8c84cb 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1820,9 +1820,7 @@ static int jbd2_write_superblock(journal_t *journal, blk_opf_t write_flags)
 	}
 	if (jbd2_journal_has_csum_v2or3(journal))
 		sb->s_checksum = jbd2_superblock_csum(sb);
-	get_bh(bh);
-	bh->b_end_io = end_buffer_write_sync;
-	submit_bh(REQ_OP_WRITE | write_flags, bh);
+	bh_submit(bh, REQ_OP_WRITE | write_flags, bh_end_write);
 	wait_on_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		clear_buffer_write_io_error(bh);
-- 
2.47.3

