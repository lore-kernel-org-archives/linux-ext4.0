Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1489340273
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776103714; cv=none; b=DkgRaryZB+27mXGtBOkO0y/pK1cK1fNr4un1en4VB6yw5FbcJBIPeSFwQLQSr/E/o4ySRrw9q3ja4xXrCTmrrHaQGh7aNQXDzyhyZpdyuOIsQS7TQxn4reOQN5Pkm2TJ7T+keSp5jBc2haDGJeFGLP9EHWUoCiyU2VMAY1SfdLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776103714; c=relaxed/simple;
	bh=PDvNSG3AeyzwcNNjTZ3UBK6bWsDy9nTGCF8ZugYhKTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eWO7URtKJc89tz3JH5tRrUTsRxjh6IcgHhaAiAr9aM2Br7LL7cd6kfZDrWcVJeguuBuuDatwsB/+y9Xoqnm+nykbb0c8p0fQqV5VNAAHv8J26HUhPFwJ+1uOQUGzx9Td1fXWJPeQcPWPp701IWaG74ML9vRYmTAIol3rlc5PMRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQXPoQis; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQXPoQis"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1273349c56bso6251682c88.0
        for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 11:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776103712; x=1776708512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b+uS5QHNkQJbtQuGTQaxTCJ42LhmMw1oPV48ehypgMg=;
        b=mQXPoQisPsisIeY5UxFTxN2Z4LW8JfGkGcTCdbXvhI7rutyBv9o/l8WerebIkM9krY
         PhBp2aC2gC0lTuhkXRw5zIV2S+2q+WEqihUkxZKpAuYAgavK9ehdfZvGJn6R8S9xyiwu
         l85313IhjO7RwWWI74ByvbagBSnto7M11zxVwF6d8fKNpo0NK0MYiwpX2A+XbrqAmJeT
         sfwdH9LdXlBSZvB5K11NQygnm1IOc6s0DaeCk//N+EafO2hTx9y//IDfjrjiR32B92Qt
         JHX22aje3e9P9Qb9y1/IpVgd5zpkS1fPYMkZt98XjRrkO345RMskHiJrwm07LcVe3gfj
         RPjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776103712; x=1776708512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+uS5QHNkQJbtQuGTQaxTCJ42LhmMw1oPV48ehypgMg=;
        b=ZRMqOA+kq9ssFra4eiJTwnWrznU/7WRNyezr0Em+eGpMTM2kvk1oeL/Nb6qIyOHdJS
         Eljt+l/uA3nyrp7mEWD15veFV2oMcII6oGrWcU8zWu2G01Ok9+C+TUFOUdQY6MiaULVm
         qZbQUuGEzejB7NYCxMRjZ2wri6+mkmyNHd1zM7eRQCERSHt7SkKGfj5tvloHIlnCP8th
         lpJDs1+O5u5OXftT+m3e4KYbsJd4SlW5oSC4VRyKFKyVcGCSWcTwxKDZHSA9FG8YuTAW
         6iZV+NDJKZD8rXoBSwJEeBZ5ZqxvKy/vVydLOl7SpkEWaoHGfZ8pFPKbsowE93KogXm2
         /UCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+V1OtO6KgNNY7I0EIb0froSp6knK9OVfm3nUd8evTN+EtMUqMLH+LUjuVZ85WWmi7RuV8A8zPdSLjy@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0yoKt2TCs5gycOFqXE9W0YnfYUB6peJewYvYTGWxDtFClZkUc
	GrCVMLedgpyOGwYmRTUJA0w2o8DMDmOwq4vQwaZu+5X4MjXg5VWZjHxs
X-Gm-Gg: AeBDievnjDlYUV4eMqEED36V9UlAOdA1MgJ/okSmGC+wUl6bMzRbzhjqmv6qn6HDDxB
	egNj5Z16irVlTNUN9kbvYhka/ldZyTK28yI1WwO3WXsfV44mnMMHzlYy6Q6ke0Tq7NH4DrkxSnh
	b4ghjJ6qhZ1hDXwgl2D6Ocd4WSrvU5FP47uV1TxYmQ6jCcseHZVajymz9PywsDfFVmET6XA2n2y
	nPhbobVyobZv2E3ScCANsyiiuLtbkoDiVRruz49iNQISD2w2WsPWmayVApFZMUpY61m0zjmKEcc
	6T3uizGb1LRsseRH0/nmxovclWB0ns2qdh/lgfuxTuq8hbk5WG4jrq5F7b+a8vneoEDhcBKyam7
	jNDHZ8LE4GFQcPt7eSd5l/DEPBvwADE8Ce3BVaJR0IhKNiLhuNkgOFie6G6a9uye1DJv1X0eim0
	92fX5IFsek9MUgsobGYdURho6hegwa76JPlo07dKMPBxfpL50ahS6mSOvGDn4gOn0fq2r1HkpIP
	4ZVEylTLqyIQPscJrIhzmMA3FbSgeUloDo+XTUkOaEKTxM01FiB7DKRZcevBNS7Yh+2uZ65idJn
	WQCoY7FKOM1JMFnGudc2Hk5KgQ/T+8K3J6p0w1Q=
X-Received: by 2002:a05:7022:f92:b0:128:bae0:e043 with SMTP id a92af1059eb24-12c34f14057mr8333267c88.31.1776103711937;
        Mon, 13 Apr 2026 11:08:31 -0700 (PDT)
Received: from arch.lan (c-98-51-119-100.hsd1.ca.comcast.net. [98.51.119.100])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c346fb141sm14860956c88.12.2026.04.13.11.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:08:31 -0700 (PDT)
From: Milos Nikic <nikic.milos@gmail.com>
To: jack@suse.cz,
	tytso@mit.edu,
	linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Milos Nikic <nikic.milos@gmail.com>
Subject: [PATCH] jbd2: validate transaction state before dropping from journal
Date: Mon, 13 Apr 2026 11:08:24 -0700
Message-ID: <20260413180824.126739-1-nikic.milos@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, __jbd2_journal_drop_transaction() unlinks the transaction
from the journal's checkpoint lists and only then proceeds to validate the
transaction's internal state using a series of J_ASSERTs.

There is no need to 'mutate before validate'. If we are going to halt the
system that makes manipulating corrupted pointers in memory irrelevant.

Move the state validation block above the pointer manipulation. This
ensures the transaction is entirely valid before modifying the journal's
internal lists, modernizing the function's logic and paving the way
for future graceful degradation of these assertions.

Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
---
 fs/jbd2/checkpoint.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 1508e2f54462..c82b6bedd27b 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -703,6 +703,15 @@ void __jbd2_journal_drop_transaction(journal_t *journal, transaction_t *transact
 {
 	assert_spin_locked(&journal->j_list_lock);
 
+	J_ASSERT(transaction->t_state == T_FINISHED);
+	J_ASSERT(transaction->t_buffers == NULL);
+	J_ASSERT(transaction->t_forget == NULL);
+	J_ASSERT(transaction->t_shadow_list == NULL);
+	J_ASSERT(transaction->t_checkpoint_list == NULL);
+	J_ASSERT(atomic_read(&transaction->t_updates) == 0);
+	J_ASSERT(journal->j_committing_transaction != transaction);
+	J_ASSERT(journal->j_running_transaction != transaction);
+
 	journal->j_shrink_transaction = NULL;
 	if (transaction->t_cpnext) {
 		transaction->t_cpnext->t_cpprev = transaction->t_cpprev;
@@ -714,15 +723,6 @@ void __jbd2_journal_drop_transaction(journal_t *journal, transaction_t *transact
 			journal->j_checkpoint_transactions = NULL;
 	}
 
-	J_ASSERT(transaction->t_state == T_FINISHED);
-	J_ASSERT(transaction->t_buffers == NULL);
-	J_ASSERT(transaction->t_forget == NULL);
-	J_ASSERT(transaction->t_shadow_list == NULL);
-	J_ASSERT(transaction->t_checkpoint_list == NULL);
-	J_ASSERT(atomic_read(&transaction->t_updates) == 0);
-	J_ASSERT(journal->j_committing_transaction != transaction);
-	J_ASSERT(journal->j_running_transaction != transaction);
-
 	trace_jbd2_drop_transaction(journal, transaction);
 
 	jbd2_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
-- 
2.53.0

