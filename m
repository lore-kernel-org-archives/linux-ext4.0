Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B993491EB
	for <linux-ext4@vger.kernel.org>; Mon,  9 Mar 2026 23:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773097727; cv=none; b=Wu1B76WUdcSSTZfWuWOGiRo9xKPi+fbXLE47+vi9seekOVj90nX/CEKznQgIVXsCg3HZ5vfMQ2B9aTx/oArxUC4N1FoxHG312L2lDFzioKrvlPrsBAN0b5j5aB8KtVNmCbvaY6aOV5NGnu+Uvo+7qyJPiWAo6JELR7sudztHF6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773097727; c=relaxed/simple;
	bh=346Gvm9J1V16ckbmpxQAG0BjgBK8MVjVX4mLtT7RvQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fj2vomrCn4kQ8EQkl2YdbpBfvwy22qroKy6Zyr4j9ZpHsf090vJyxXKsHWuvx6fpmIKoJWWfmwcLWNJ83h85aK48FsAY7H69uc7IdosBlKCTt3rhxKCrtq4xW8LTXyC9Gar8nuFTvaCOypNgGAXlNxa2ZPW1RhceO5LcgOe8cq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5R54Qv1; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5R54Qv1"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2ba895adfeaso10281877eec.0
        for <linux-ext4@vger.kernel.org>; Mon, 09 Mar 2026 16:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773097725; x=1773702525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NT60/qqiArXvkGxozfzhAVQf7Na3NTonflzMTGv8cyU=;
        b=b5R54Qv1TCqjMa01R95IhTLoBwaWR/Pvck56s7lAmuGhPxBD3bClzSXJvqE9t8jPI2
         iwipstpKtjiAxG+SBU77bzlDPsaT2QbJgnFKfcNLrvrFpqxmmlYmTu1UgeeWx3T5IQ9s
         3efGubkhtI8Z38OdsNqxW7pFzj4dtngpEg144kYyVaySltlPvCk9rlPaJyryjvh08AmF
         kVOwb11Mrf1A8CXDxcqeX72ZoUUcQTvHfz6CdNcPLaOb8u5K9obSK5ivCr6FhAV5s93W
         j3hvIsus6TkqM8CQgzxFJCuAPew3HuhWn/x8Oy3jJ9GAZpcEs/zx41EjEQW60YBz24oT
         svNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773097725; x=1773702525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NT60/qqiArXvkGxozfzhAVQf7Na3NTonflzMTGv8cyU=;
        b=Q8x3id0V4aarJ10XLtcf+6Yf6DHM87TyHX5lDATyCcA7zJ6//A9gfP3ebEDjl7ZtZC
         U51UZ4FRpIv5uPLj0SRR5b3tEdVS1iKF3/uCG0+4id3NISTqhQmeXkq0pIymeFRoUan+
         Z+yU+DkYNUqfMt55TOA8kKmrHL8zRA6/UcAPUaEzAgl1SzD+y3D+YE2iYL8qGUc5S/S7
         rc+lORskzspyA4lKRY/meRXsrCjMb4RorLBIlvBb9GQUuCjhAT9Iohou+9YrUKQo/WgV
         PjExajYknesRajJZlPS4wTzS8185nnwmeQWRjUYlR+Uh47pMrbCDffWpWydxxp9P4cos
         PHrA==
X-Forwarded-Encrypted: i=1; AJvYcCUl/ZuFqnzwCW53AAFcPNytAayOC0JkFYN6CT1gCUuOzNHVPbDv567uLzRcOcH/LgbYcuxqs8BTUgS+@vger.kernel.org
X-Gm-Message-State: AOJu0YyaFDMd+9sDxKeZbQfHHA/bFo0NtcE/sVBUwd2HlqYUQUE6hdyZ
	An0ESNGFvmcF0huC1uVv3XVO88KrYkIKYtKur5hCR752Omsjvt/ITFGu
X-Gm-Gg: ATEYQzwyWugwfSW75dVcCAd8kxMoDR+lkbRkrCeyXHB0PBtVfKpI6DjHKCG426cOx6z
	Fve+3E7e+NzT4GUZkR2+TrfECP977ZCv2opiY8STyMEy9W9bhe2WzGpZl9DBTtUajrJF/qq8FH0
	A/PrxVIFquUjClROPujHKfl8aRpbDXO1qheNfCL5xWsVgpNsuTqyUQSex6PspH1vcbIkdp/yEof
	/Ht2EIous8gumaYdPsCwCmibaqFHGQhTcVM06NJG7O/u2Jwrsmlh1F60vo0dTIiomZ7Ippw0UPO
	j0m/iToW73kNLKSEGtEpEw10oukDEjnh1kC788LFOQ4jyCVbb/GFh6TAN87kQAbCWlUOHrIEnlg
	V5E7X0Ig27tnpEAIiRxvMw58KijWjWUrOp0UhPyK91lQwjLIqfaidzAEr/QZJuXoLWVpAdtf+iM
	+G2dcDGvv5g9pPQK59yRBuUfjJuHxWGUjYWwCXtDolYB62/4MUa7qQLNlbX37E3ggLiPX1/nlM3
	ulnre9UupNsURLDRx2+oj960FsujBmUyIRYWibX4T3YCEg7YqIYVOO4UA9meqorLtjdR5WPY9Zv
	Np8eFrXkTOw5SDhwGjePw5I8X7kN
X-Received: by 2002:a05:7301:3d1a:b0:2ba:66fd:3705 with SMTP id 5a478bee46e88-2be4de652f3mr5180803eec.1.1773097725064;
        Mon, 09 Mar 2026 16:08:45 -0700 (PDT)
Received: from arch.lan (c-98-51-119-100.hsd1.ca.comcast.net. [98.51.119.100])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be7d30fd82sm449116eec.21.2026.03.09.16.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 16:08:44 -0700 (PDT)
From: Milos Nikic <nikic.milos@gmail.com>
To: jack@suse.cz
Cc: tytso@mit.edu,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Milos Nikic <nikic.milos@gmail.com>
Subject: [PATCH] jbd2: gracefully abort on checkpointing state corruptions
Date: Mon,  9 Mar 2026 16:08:38 -0700
Message-ID: <20260309230838.422074-1-nikic.milos@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch targets two internal state machine invariants in checkpoint.c
residing inside functions that natively return integer error codes.

- In jbd2_cleanup_journal_tail(): A blocknr of 0 indicates a severely
corrupted journal superblock. Replaced the J_ASSERT with a WARN_ON_ONCE
and a graceful journal abort, returning -EUCLEAN.

- In jbd2_log_do_checkpoint(): Replaced the J_ASSERT_BH checking for
an unexpected buffer_jwrite state. If the warning triggers, we
explicitly drop the just-taken get_bh() reference and call __flush_batch()
to safely clean up any previously queued buffers in the j_chkpt_bhs array,
preventing a memory leak before returning -EUCLEAN.

Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
---
 fs/jbd2/checkpoint.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index de89c5bef607..cdfbfd27afae 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -267,7 +267,17 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 			 */
 			BUFFER_TRACE(bh, "queue");
 			get_bh(bh);
-			J_ASSERT_BH(bh, !buffer_jwrite(bh));
+			if (WARN_ON_ONCE(buffer_jwrite(bh))) {
+				put_bh(bh); /* drop the ref we just took */
+				spin_unlock(&journal->j_list_lock);
+				jbd2_journal_abort(journal, -EUCLEAN);
+
+				/* Clean up any previously batched buffers */
+				if (batch_count)
+					__flush_batch(journal, &batch_count);
+
+				return -EUCLEAN;
+			}
 			journal->j_chkpt_bhs[batch_count++] = bh;
 			transaction->t_chp_stats.cs_written++;
 			transaction->t_checkpoint_list = jh->b_cpnext;
@@ -325,7 +335,10 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 
 	if (!jbd2_journal_get_log_tail(journal, &first_tid, &blocknr))
 		return 1;
-	J_ASSERT(blocknr != 0);
+	if (WARN_ON_ONCE(blocknr == 0)) {
+		jbd2_journal_abort(journal, -EUCLEAN);
+		return -EUCLEAN;
+	}
 
 	/*
 	 * We need to make sure that any blocks that were recently written out
-- 
2.53.0

