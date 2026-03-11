Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5577F40DFC1
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 04:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773202554; cv=none; b=Scl+8SuI3seQZO60OKUqINsQw7/fTs7oiUEgKv48NylARxsGBaVNzZfqMJmnjcNIkA7sgdZbHnrwN0G1RU60ffW3AfahMvJDZP4LVQi8IJ2yf7ccN9cNqbAquCOP7nneBxsJw29Ydw20BREX1KdfY3HFYLa4pwCx1jzdcbFqhEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773202554; c=relaxed/simple;
	bh=+20/KXrs1Oy+P7jBSLP/jI2E+aLaSPIUxi1O5iOd5Po=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FFc21QHIunr+B+1oHVktdWeaSIhsMaYqoHqs3NlgF46Nmlij5qndEOgXxo5tHQXv3utWJEMugeYKrRz67O2nS3yLAxiPZVoQ+CCMV6FOavn0zaWhp1POc3ocMR4HONpTzHjbjpZnvk3QosHhQE6JhCyzutEkaKW0LqTuxdgVtiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yog+XUxE; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yog+XUxE"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2be0711f493so337255eec.0
        for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 21:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773202552; x=1773807352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bit9jtZqtwLrzlp1IzMfbDRAcsth43R4vVsoHGCnWBs=;
        b=Yog+XUxEmIhNtfveqBCfYOFOY8VL6qr0vPMvAz9t1IPJpTODa/B3lKm8afG2LeGeDU
         YBm0iHZdpDlZyxRTOePbTUgQMQJo9Nb/ejXbLcqFbguiAROCtBsqMekLLQ/WNXDbeOB5
         G66ORvUTZ/Wn8kwNf7vBMCkkuj8WHU6TVz5E3jxoPZkNPm1aMUyHOaEP8HXe9JYzK5VU
         F36n7kLeTx0DEbs9Q9Wo8CO7peBGhms1BbfwBxBuRbnhjGK0a7sijA3iLkhJllNKCxz3
         XeMAAOz525TWPH/RqA6K2URJ3BzWWnwbeur2Lav5/amw/hL255Q1FNQP1rMYchvqJ6y2
         xbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773202552; x=1773807352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bit9jtZqtwLrzlp1IzMfbDRAcsth43R4vVsoHGCnWBs=;
        b=LG7oDJcqeWAo/ByrKW3p4kqT5233XI1RRRM+RH6vOWCxZB1k5MUEvYo7cyxaTLqAsJ
         0E/eZrL6sckNAqMoM9ZMmG1PPB73RKEfPMbxiB09ROo72iQrbp3yrSB1UUenpjVeKWxJ
         sbYX2vkVzdGiWNsgFSEaKTZe6X26GiE8624hek4u68RIK0EBOSyUreaXPkS5CO5c7PDX
         lXKHkmYL6qIsx2lMVVGqD0nSPfeg64ngpa/fYXOhY9fSuBMx5iuJO601p/64qFfi2PQF
         4f/mHEuw7YVBlF1rktatd1UlglnEIbYNQ0PZPeOIaPnsIyvOIWG4FgVZz71aUCIrwgmm
         1yog==
X-Forwarded-Encrypted: i=1; AJvYcCXn+GstXaUeRRO3AdCD/YNhSi6/wIBTSmp1GbkffEeh6DKMc3stkS0WCQdl8u9IGmB1xjt44gp7wsnA@vger.kernel.org
X-Gm-Message-State: AOJu0YzeZGn9AT6G73fGPdeOVkIKEj9jI+8Z9pqe0WORel7WFnu5takD
	frbV1gLoto72WtJ6Eb0j6dsdKTpa+4gnqIODVvgFadszlnMg9h+ScsiZ
X-Gm-Gg: ATEYQzwlPScXLjlG9XFj1yieyNtLsgWWempy9w01pLt5+wQHJEm9jEDs443KvfpCgSj
	qRExIYYWli5A8L113GS/b+1NXlmEhbAOc72Wp8mV9imHbBM0lcsyt2JM2fCTTAy3ve2n6wglYG+
	KEXNWbOzbMR4k8w1O/VsTRpHF959WS8xrpl9+756hfI6/lJ7sU6KvEvszJvk06t8v4TlWT+1Hcn
	E41DB2MG/U7zD4+7HpSMQ3fg6LuattwaMA9N5rsX9M5DRuCFCAHWB68VuDo+mysdp45o6jGvQMO
	Aq8WoeDXS+swGN4xb4Wf88D/wOXpYgCaXpUarYofgJE36z0nphymAPOqPornmwCGKJaaTy6RWZG
	2U9IdDSjeYznBSUCEG90pz1ZkrbwxDrzd/pMsro20K4/Tvrcj3osSXQIk5nRBcPmOXAlkPTlWop
	DkiU9RJIQQ8f1tF2cd0daCfpTEXTJ11g5DbykIxOMMFB4kRmQyt11s0H9BRI9QNWK4zkFkcpL+x
	5H03hnn33QabXX8Y2dDBRR+qM/yL381GGnlHoBHp8HJkNlUYdI6wFlMKZnnwn630ybuPWpzdeQ9
	s9ISNjnniOHvPxrdkxyEr6YfV9/3
X-Received: by 2002:a05:7022:225:b0:127:5c70:92b with SMTP id a92af1059eb24-128dde0740emr2287274c88.2.1773202552274;
        Tue, 10 Mar 2026 21:15:52 -0700 (PDT)
Received: from arch.lan (c-98-51-119-100.hsd1.ca.comcast.net. [98.51.119.100])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128e7c0d698sm1620283c88.6.2026.03.10.21.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 21:15:51 -0700 (PDT)
From: Milos Nikic <nikic.milos@gmail.com>
To: jack@suse.cz
Cc: tytso@mit.edu,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Milos Nikic <nikic.milos@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: [PATCH v2 1/1] jbd2: gracefully abort on checkpointing state corruptions
Date: Tue, 10 Mar 2026 21:15:48 -0700
Message-ID: <20260311041548.159424-1-nikic.milos@gmail.com>
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
and a graceful journal abort, returning -EFSCORRUPTED.

- In jbd2_log_do_checkpoint(): Replaced the J_ASSERT_BH checking for
an unexpected buffer_jwrite state. If the warning triggers, we
explicitly drop the just-taken get_bh() reference and call __flush_batch()
to safely clean up any previously queued buffers in the j_chkpt_bhs array,
preventing a memory leak before returning -EFSCORRUPTED.

Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
---
 Changes in v2:

    Replaced the -EUCLEAN error code with -EFSCORRUPTED to better align with ext4/jbd2 semantics for on-disk metadata inconsistencies (per Baokun's review).

    Reordered the error path in jbd2_log_do_checkpoint() so that jbd2_journal_abort() is called after __flush_batch(). This ensures cleanly batched buffers are logically flushed before the journal kill switch is flipped.

    Collected Reviewed-by tags from Andreas Dilger, Zhang Yi, and Baokun Li.

Changes in v1:

    Initial implementation converting J_ASSERTs in jbd2_cleanup_journal_tail() and jbd2_log_do_checkpoint() to WARN_ON_ONCE and graceful journal aborts.

 fs/jbd2/checkpoint.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index de89c5bef607..1508e2f54462 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -267,7 +267,15 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 			 */
 			BUFFER_TRACE(bh, "queue");
 			get_bh(bh);
-			J_ASSERT_BH(bh, !buffer_jwrite(bh));
+			if (WARN_ON_ONCE(buffer_jwrite(bh))) {
+				put_bh(bh); /* drop the ref we just took */
+				spin_unlock(&journal->j_list_lock);
+				/* Clean up any previously batched buffers */
+				if (batch_count)
+					__flush_batch(journal, &batch_count);
+				jbd2_journal_abort(journal, -EFSCORRUPTED);
+				return -EFSCORRUPTED;
+			}
 			journal->j_chkpt_bhs[batch_count++] = bh;
 			transaction->t_chp_stats.cs_written++;
 			transaction->t_checkpoint_list = jh->b_cpnext;
@@ -325,7 +333,10 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 
 	if (!jbd2_journal_get_log_tail(journal, &first_tid, &blocknr))
 		return 1;
-	J_ASSERT(blocknr != 0);
+	if (WARN_ON_ONCE(blocknr == 0)) {
+		jbd2_journal_abort(journal, -EFSCORRUPTED);
+		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * We need to make sure that any blocks that were recently written out
-- 
2.53.0

