Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E0E3176E0;
	Mon, 25 May 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729586; cv=none; b=iwZqk1IzE6ZNn55+mMjlJFg1YvxD5wpLRXwrt7lENZzeKqsOwnYkWNoZ7GLVnHOt1uTb3CvSTB7wl6aXVGP5aPB+FV4cDpI8pZfTYNP2eavZcHqTCHWrsBb4cK0Ng8sSuwx789jPp43L6mc6cDNrlwtRBgQ7oTlBzEbhtlCPJoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729586; c=relaxed/simple;
	bh=tFh9U4X9GUnHJdQQ3EhkdYf7X350VY+BafIkT5qH+TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yky27eUbghgnbUk0OVRbS6eNhE1z/ZuJZX9Cp0PCpdMKHejjHO7RiMpQRR60eOd2hgI7OKp5rH8MF/wVmSyxVz2B7AeC3+e3jy/4ZdDruuteTosa5+TY1vNkugrYx0AoAJIJ8YXsa8BHumaw5j7OSXXqEFmMKkB2Jvm0PWm0sSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dGYvlqg7; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dGYvlqg7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=zGr8JDF2p0LzFNi+009pP2oF1VdbyuviGIBOk7zwqPQ=; b=dGYvlqg7j+rFaCN2Ic6thD4pFz
	QuNqNopJ3h8QSNCcyx4J8pffy5dk94IhjLqyMUgP/eRTVCtznX3SpWIuR+K4HPOvLvqofaX/WH0LM
	XEEpJwfVbk0B+wSRQGSPevDsUrxOWE0e0WIAnzp8wfRNz37gvDKHr6fAuAjNAIVNgrpGXm7QHuve0
	TV8CWAO5nu5sJXQHG0uITTsl3t2gB4ASWVD2TmZsigtULghMCexhqmn0F7oBB/OPUbQz+R7Eem2bj
	72nvOiGmfD9o42oVLvnbv6dlDOsAbR+BWgQVd2SOlTUorMI7K50R+SMKgNTuqucBPorzWNWlnJxb6
	YccsNhxQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxq-0000000HOBY-2sRs;
	Mon, 25 May 2026 17:19:42 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 17/34] jbd2: Convert jbd2_write_superblock() to bh_submit()
Date: Mon, 25 May 2026 18:19:10 +0100
Message-ID: <20260525171931.4144395-18-willy@infradead.org>
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
 fs/jbd2/journal.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4f397fcdb13c..a6616380ce38 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1821,8 +1821,7 @@ static int jbd2_write_superblock(journal_t *journal, blk_opf_t write_flags)
 	if (jbd2_journal_has_csum_v2or3(journal))
 		sb->s_checksum = jbd2_superblock_csum(sb);
 	get_bh(bh);
-	bh->b_end_io = end_buffer_write_sync;
-	submit_bh(REQ_OP_WRITE | write_flags, bh);
+	bh_submit(bh, REQ_OP_WRITE | write_flags, bh_end_write);
 	wait_on_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		clear_buffer_write_io_error(bh);
-- 
2.47.3

