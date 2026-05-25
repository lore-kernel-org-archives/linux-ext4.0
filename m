Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9ED311592;
	Mon, 25 May 2026 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729585; cv=none; b=Zf7CLCgtscwTS8pWGY7d5mfJ2YbZZzjE1poq1HjMavIcVUrLBTjTN5/tit9EehPHbN+XbddDuS1TalzR4EHOL8MsWhl9jlSapDhM2COBOkG7dxgDU2eX4FcJC96FmcMkQJZ6x8iUFM8Gqu5fNnPM7TZaWxJYuT+gbzytpMjUB24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729585; c=relaxed/simple;
	bh=kgERRc2Frppb7YlpKdAP56ePYHn3XnohjHTU/DXCKIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hY3qrwhyjPllvmMAcLo68JC6mVuIIW2MJnmxynilb0/4AVBrQNpEaMEoqJiLni/ybORdKHrwOn7dRBl3O88/8RYcAojGU3dgnhJtBYU/oFYM/VqRWBvepneHAV+ZqqxVOTmw1R08TwunrKnB2rMIS9pOUrXLq2NQKDCO5fDupPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Zyk3G0mq; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zyk3G0mq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ImjhwEvbIU55R/pwJil76Dwl1KxH8CdcLmVWedadQns=; b=Zyk3G0mqk0PDg+oCSS42/spYT3
	FJLrt2zFZEMaWTt35JqjCRd4btU6/zIzV57z9lBLDsZPkqAJFkUTt1uGjLUR1ydx8JS2wGenOuELI
	7vzkHGTI24410mVB3M0OFHOPg6C2zQY5ix1X5M0wqDMJo5lhGjAnFXrWnIRsjkN6H1bOTZHzF9brK
	UWo590W+fpR7WBDaXITFw3ac+Wy38gvJI9dmmrpwTBJZjrULh3yXX40PjpSvs/Qgfi8iUDZfOws4K
	MglSRATFPCYDCfme8lrVQ2I3kJS4zyqux0yNWfgB2bDqvZ+vAy1sd3HZKd6IgLO4ecwDJaZiQYzs7
	fCLOYqUw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxq-0000000HOBI-1ER7;
	Mon, 25 May 2026 17:19:42 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 15/34] ext4: Convert ext4_commit_super() to bh_submit()
Date: Mon, 25 May 2026 18:19:08 +0100
Message-ID: <20260525171931.4144395-16-willy@infradead.org>
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

Avoid an extra indirect function call by using bh_submit() instead of
submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fbe175951e01..905d66cbe3f2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6320,9 +6320,8 @@ static int ext4_commit_super(struct super_block *sb)
 	get_bh(sbh);
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

