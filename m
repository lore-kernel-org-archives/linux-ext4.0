Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD8D3D25A6
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621697; cv=none; b=JOkIIZW9Vz1YcJy803iJ7sbShFJ0dt5B6aRX4kHaf/7oS+BpjSmGa7GT2iZHZpU628bWtIcPDR+SVCRzbLFaoOXjFlVoIn7Z1I7azNlEskeNC9Qm0NMrm3Gzh7PqxX1goztjTJW7QfEPSVdGyZ684xCWsvGA6SU1gHlkpRRNbZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621697; c=relaxed/simple;
	bh=11/QTy2yfnrD1wjLL3sT4kKYG83gGCLz7L/Upg/VVro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKD6P+9smg3co/9QZQfP34Q7LluFG1bRe/lKchIwYwRkc8z6TxcVEb3rM7uR3aZzaMr01te25APFfDRIop73ndcvycwg1WxIOKAhEFbKxmV7xrLfXuyPt1rCOQSm3nGKVjxh+A5d54+55ekgDK6gvJriDlswSrRSN5uv9Nuz548=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gJRresyN; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gJRresyN"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-81e69a2db34so31842267b3.0
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621692; x=1786226492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6crITnQf0AA10KnjmQzAxCPQHRm39qApxGuVVNfjYZs=;
        b=gJRresyNBALjoqKc/66TtEsPPXHMOZr6YmYOpBuzdFCjAAzBEgLs3U7EWB+I1s0Aa8
         n3XBmFe7mzhsx/uPeDyrsWnzV2JQyUTeGQVrk4GSqWSKZHUx1MUNAM/gUyQJN83T1p5V
         fj95wBPSdAkeCSPbUciqxTx3tC1quKD96Fkg16T6T9Mw0PhriBz5fc2VQPwNnsN5L283
         AoaDCNkyzB1dZOLbvFbX3uDQSe0jIhcDaCKlXP3+ETaPaA5eNiQWJCL9nQE56jaTiUNO
         Xt83RXZ3PzlNt9xepxiCf1dgsSKWwcEfNmUScdRApFFXNFRAA/+hMXxns2cu54quPikY
         AjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621692; x=1786226492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6crITnQf0AA10KnjmQzAxCPQHRm39qApxGuVVNfjYZs=;
        b=iysVW3oBf65eNNamznOK2e/r6I9zsRBwji3zlEx6Qbf9n8gYUW2BnCSc3H/nGE7/rH
         aHgoJghHjlmdw7xMcvZi5Q/5MuqnhEM4Ep4V3fHmompRmzQQsnqVIQhfYOE4KqI0W9GP
         kR9keO1Oxt9VHnszXRVC/ZMIs34JNSfFcdKvnVHeMYhwr2xZF/paNLB8tz5HgvWfAK3T
         k45J1y0AvGuNf0rnfDI0B8J9cTGKsohAmiDmV9nj5yz5SF2d7UrMJ9zsdrPvCvEPyHOL
         aGD4rAWj+h0ijr/ld6vQ6OZMDC3FFBzqc1NybzdNosaLqDmv69ekCBKsIIGCXxBYDufM
         9mcA==
X-Forwarded-Encrypted: i=1; AHgh+Rp4hLrky8NLf3vQA8wq9iyIOtWdO+IBY7GkZvK88nukfthovIWs8gGLvgi2Pe3gxiZDqhwg9zUzdOqs@vger.kernel.org
X-Gm-Message-State: AOJu0YxS2wQEyKoekR4WgKvOYqYfoUEVienXHUeNnGXT6PPEhHJFlMgp
	6FoSsIKOOfNsRdN6pMPky++VJqJRA0JasU0h5+g4UOP/BxIy+tua33WV
X-Gm-Gg: AR+sD127qiNhOfgKAg7qpekH7PTyEK4amSdS7hEM5WRcZWN0sBfKcwsHir9YLYhDaIA
	MJJ5c9u1iZwpo9njHIIWYZ03fVK5Z8JFUT+ql0pPNQxP+50jEGMKb7FwKCnF5k5xRtqO6psFA5k
	42TPVSZr+PZfrEc1S15K2o1Lo2Wj2sLn5XsE5SkmsRM+eZXloPS9Nl+EOkYXVTePGCjC6a2V27+
	B7Kk/mYlOOIfpzaGkN4z6N71TP+jGXF67Ecru2HQ0ehnmWIzenv6e7pnx0hXBLV9++51R+pOlRv
	QGr8kp0wRt8gGCQWwtuvzTXiuwFzGPbGgODBwjY/XjR7P6/ePAMrSapWy43sGlRyzn92ZUsu9OT
	KT5QZEmIR5jTWoIwZtT/QiT2RnKqL3zpdGpLLwzJDUMMke04kDqLoxNVxSwpx8Eyk/IJ+J4urat
	moFAaeUQdCzcnNVc20MPTgtEcHL9PIx0LCWqY9qk4bfO+40iqBXGE3KbrQeJipiFXHlWnFGzWu0
	qf4qI0=
X-Received: by 2002:a05:690c:450a:b0:809:9422:8c47 with SMTP id 00721157ae682-81fd4b5a2e1mr70880997b3.22.1785621692499;
        Sat, 01 Aug 2026 15:01:32 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:31 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 16/19] jbd2: report journal write errors with BH_Write_EIO
Date: Sat,  1 Aug 2026 18:01:00 -0400
Message-ID: <f0e0fd8516487b774d8cf1384949a0c616921fbd.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The journal's own write completion handler,
journal_end_buffer_io_sync(), reports a failed write by clearing
BH_Uptodate, and the three places that wait for journal writes look for
that.  This series is removing that convention: a buffer whose write failed
still holds the data that was supposed to reach the disk, and saying it is
not up to date makes callers rewrite, re-read or WARN over data that was
never wrong.

Set BH_Write_EIO instead, with mark_buffer_write_io_error(), and test it in
journal_wait_on_commit_record() and in the two commit-phase waits.

The two changes have to go together, because commit phase 4 waits on a
mixed list: descriptor blocks are submitted with
journal_end_buffer_io_sync(), while revoke blocks go through
write_dirty_buffer() and land in bh_end_write().  bh_end_write() already
sets BH_Write_EIO, so converting the consumer alone would keep working for
revoke blocks and silently stop detecting failed descriptor writes.  With
the handler converted, both halves of the list report the same way.

mark_buffer_write_io_error() is safe on all of these buffers.  The shadow
buffers from jbd2_journal_write_metadata_buffer() have no folio and no
associated mapping, so it does nothing beyond setting the flag.  Descriptor
and commit blocks are ordinary buffers on the journal device, and marking
the journal's mapping with the error is what write_dirty_buffer() already
does for revoke blocks on the same device.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/jbd2/commit.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 60273cddf434..8912786ebebb 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -39,7 +39,7 @@ static void journal_end_buffer_io_sync(struct bio *bio)
 	if (uptodate)
 		set_buffer_uptodate(bh);
 	else
-		clear_buffer_uptodate(bh);
+		mark_buffer_write_io_error(bh);
 	if (orig_bh) {
 		clear_and_wake_up_bit(BH_Shadow, &orig_bh->b_state);
 	}
@@ -169,7 +169,7 @@ static int journal_wait_on_commit_record(journal_t *journal,
 	clear_buffer_dirty(bh);
 	wait_on_buffer(bh);
 
-	if (unlikely(!buffer_uptodate(bh)))
+	if (unlikely(buffer_write_io_error(bh)))
 		ret = -EIO;
 	put_bh(bh);            /* One for getblk() */
 
@@ -840,7 +840,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		wait_on_buffer(bh);
 		cond_resched();
 
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			err = -EIO;
 		jbd2_unfile_log_bh(bh);
 		stats.run.rs_blocks_logged++;
@@ -883,7 +883,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		wait_on_buffer(bh);
 		cond_resched();
 
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			err = -EIO;
 
 		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
-- 
2.43.0

