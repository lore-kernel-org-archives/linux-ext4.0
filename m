Received: from relay1-g-k.mailbaby.net (relay1-g-k.mailbaby.net [67.217.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC8D328B7F
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2026 20:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.217.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779307885; cv=none; b=Ai6WJ5REw3cXWs3ZwdkdKoiOIBvvjANwCC1GDl+hsewt0ZPQKaD+kh9ODQ7aKLzZh4aPeifdIPhe7o0Gq6k8766vQbFWDcNmXV39p6JO7e2VSO3eJcomv6htdZl3Vfc5qj+dEliDXCvspW82XqiHhKtcsuKzUIUQaklIGVQXymM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779307885; c=relaxed/simple;
	bh=UG4fMxcJprcmV8L1IVQKviv71mkF1wXGhMe1zEm49eY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=COeQK495Tnr7BPGE1fBWzp4vzCGPDsKI+p6CXdaldxAUxNVUjZ18zHKVqKsYDvrZDnGQwHYBUR/jc6KzworBRpPPg9U+OScFGINNAmhno/jDdoMdKykWpB/SKFhGZeyKBWOmaUdojSFIlawEyc4m6YVoSb/BtontUK7/GW1bgcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=agatha.dev; spf=pass smtp.mailfrom=agatha.dev; dkim=pass (1024-bit key) header.d=mailbaby.net header.i=@mailbaby.net header.b=E+YoXaJL; dkim=pass (2048-bit key) header.d=agatha.dev header.i=@agatha.dev header.b=si3jXy0b; arc=none smtp.client-ip=67.217.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=agatha.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agatha.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mailbaby.net header.i=@mailbaby.net header.b="E+YoXaJL";
	dkim=pass (2048-bit key) header.d=agatha.dev header.i=@agatha.dev header.b="si3jXy0b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbaby.net;
 q=dns/txt; s=key2; bh=IMgDpI0lU3RJ1xH2yJAbd7vfjY7nVe4F2t+I1+L1jQQ=;
 h=from:subject:date:message-id:to:mime-version:content-type:in-reply-to:feedback-id;
 b=E+YoXaJLSCpY4sBq2bvA2Wg6/d8hbi514KnHGTp61XbGI/I+20lh0h+GxBaiLXqjQnlVgKo0j
 TOZkkDT9Ilgbyq0nBOx1mB9urjkNzn/2IRzY5VYOa79GjtsevUEL3Uh5O3TNjQYtU2wc+cbe485
 Y9YezXPIbI9k4qR+1TdY9/8=
Received: from mb-nj-kvm1.internal (mb-nj-kvm1.internal [10.10.2.10])
 (Authenticated sender: mb6724)
 by relay1-g-k.mailbaby.net (MailBabyMTA) with ESMTPSA id 19e46fea7d2000babb.001
 for <linux-ext4@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Wed, 20 May 2026 20:05:54 +0000
X-Zone-Loop: b2ece2bd30cfdcbe2463e096b25fdf7565700baf34f2
X-MB-ID: mb6724|me@agatha.dev
X-SPF: pass
Feedback-ID: mb6724:19e46f:507c5a5c5e5d585f7d5a5951:mbaby
X-NS-SCAN: PASS
X-MAILBABY-ORIGIN: PASS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=agatha.dev;
	s=default; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:To:From
	:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IMgDpI0lU3RJ1xH2yJAbd7vfjY7nVe4F2t+I1+L1jQQ=; b=si3jXy0bT923QKsOGn/R38nWIA
	so+4WYin8UWU4XvULZHo6buUIgD0eltutC6BQamZBkQO9d5pLlSmlNzklVb+aA/su4SHskMEt6F5D
	WXFuMQnIPDp92ex6if1z2fxvKp4HFSsWTENoeHUebdYDrYm37L6v0DzWtezAqc8Ya3eCaiplresyW
	aqLmbCk3CEblhRnAb4EdYvoa9hYTatqrCndl/qxSfZAcEIuxkjqflWVOWRGWyFF7di+V+u1YVl5T0
	Mm2E0uXjR5mCc3h4mffVK3HQn1HkLRdrtK+VJp2kWfHRjUGxTGKJsLdPWuSmpOCmvrXp+rz4uSutJ
	FIn+SmyA==;
Received: from [170.254.153.136] (port=33942 helo=guidai)
	by nyc3000-r.dnsiaas.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.2)
	(envelope-from <code@agatha.dev>)
	id 1wPnAy-0000000FeZT-3Ups;
	Wed, 20 May 2026 16:05:54 -0400
Date: Wed, 20 May 2026 17:05:46 -0300
From: Agatha Isabelle Moreira <code@agatha.dev>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	shuo chen <1289151713@qq.com>, linux-kernel-mentees@lists.linux.dev, shuah@kernel.org, 
	patch-reply@agatha.dev
Subject: [PATCH 2/2] fs: jbd2: use clear_and_wake_up_bit() in
 journal_end_buffer_io_sync()
Message-ID: <ag4SrrOl7R2DcLLi@guidai>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag4PEP52c8rxrYPc@guidai>
X-AuthUser: me@agatha.dev

Use `clear_and_wake_up_bit()` in `journal_end_buffer_io_sync()`, since
the helper was introduced in 'commit 8236b0ae31c83 ("bdi: wake up
concurrent wb_shutdown() callers.")' as a generic way of doing the same
sequence of operations:
	clear_bit_unlock();
	smp_mb__after_atomic();
	wake_up_bit();

The helper was first implemented to avoid bugs caused by forgetting to
call `wake_up_bit()` after `clear_bit_unlock()`.

Since `journal_end_buffer_io_sync()` was first introduced by 'commit
470decc613ab2 ("jbd2: initial copy of files from jbd")' and last
modified in this operation by 'commit 4e857c58efeb9 ("arch: Mass
conversion of smp_mb__*()")', years before `clear_and_wake_up_bit()`, it
still uses the open-coded sequence.

Replace the open-coded sequence with the helper to avoid duplicate code
and reduce code paths to maintain.

Suggested-by: shuo chen <1289151713@qq.com>
Link: https://lore.kernel.org/kernelnewbies/agzoqV835-co4kAN@guidai/T/#t
Signed-off-by: Agatha Isabelle Moreira <code@agatha.dev>
---
 fs/jbd2/commit.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 8cf61e7185c4..b647fde76e49 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -39,9 +39,7 @@ static void journal_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
 	else
 		clear_buffer_uptodate(bh);
 	if (orig_bh) {
-		clear_bit_unlock(BH_Shadow, &orig_bh->b_state);
-		smp_mb__after_atomic();
-		wake_up_bit(&orig_bh->b_state, BH_Shadow);
+		clear_and_wake_up_bit(BH_Shadow, &orig_bh->b_state);
 	}
 	unlock_buffer(bh);
 }
-- 
2.53.0

