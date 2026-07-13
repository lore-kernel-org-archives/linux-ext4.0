Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A593E5EDC
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 10:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783938161; cv=none; b=M+1EA1r8sctJwv9/NCrkf5Tifw1jmgCE4pKP+GBNdaOmn9x17TuJpnAtmJe0t0ulm//4nGdMU/c0LMVAR5id1vCPQC9k35wmLHuLkiKf9cyG78bj+z9X8Z7TXahOby0mYEuDSIuqN0wVH1qGet07JEIDaxCdPwp/wdJcweuNcVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783938161; c=relaxed/simple;
	bh=9fvUIivmZtSZeqhsriqjOUYwnTIOxzDzZNMxJw1Icx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Biom/L6d4B1YUQ5EvizZQLhmiDjCj+O3O8DlD4EtHTv8MBiDnczPtAENbfGKqZXwVNf9xNY3S3CpsS2V33JmcdMgYLs5Ptjz6iXsiwFBngMCbKEZ3CvwuD+FqIcckKw3IakvCAATbzwoVo2lxU3dficgKpoXHIDlRBWT6k0q7MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=hSjWmLei; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="hSjWmLei"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-472326ca506so2388270f8f.2
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 03:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1783938158; x=1784542958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BqAzbIa03EEwzYHiTtc0EGAOtlFJgcTmBpG0VFTldcE=;
        b=hSjWmLei+vEEXiGvSF6MKPQ5rztV4dZbdHQ5vuz6E2uZGStiMuyfsW55ofVcyABPHR
         Pymx7NlEe5BHrNQrHZQ9G4v9vZqJIBVAr6JwQBWp8c3O1efeUvLbzs2yL4vszBcBSt4P
         D5kCSK+iRJXz7hJk03DiB6nYvYic4KfIoRTapxI8ryUcO+LwCo6lIa236F8JcJuc9w8h
         R8p4MCKkOeaJUqDHOgyVu0Jj7iTrY/97joHgAR9dmYvDnXvzosfdRyFAmCiej9nM1ces
         SATv9fjzd+eojNGJgzupeA1LnB8hAMxRNNwZcnCtLAYezVSTVCSfQuqvaOzSmtebGs4F
         h3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783938158; x=1784542958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BqAzbIa03EEwzYHiTtc0EGAOtlFJgcTmBpG0VFTldcE=;
        b=Yb77lgE9gz5R3kRW5AWVKh2magcz64dmsg27TyxAEnCyG68s5i8ffej3biK0I/7h9j
         a5GgTWdQBRLk90pW0q50wVdQxpmbRdlP74AHRxxb8vShWEL6DuXeJSeJjBkcTX/0PExt
         sBzPC96xq/4oj2zoqi0Nm5qQd5WmBfgi+R6VboAX0fFYyVCb7fxep9Ya/z5ieHYYkWIa
         mlzSsoOEiA6iuaas4qrH4zcfU1+EEeoFYkxBMRgZoDQq3eZhlj3C2eUQ1mUI3D7TF0+M
         iaqmLG2WXuf9zo5J/3WQeEzMGHM4dY9T0S8HYg+Md0b0678Jd9m0oSJA7DHeQXCHsLVo
         FqUA==
X-Forwarded-Encrypted: i=1; AHgh+RoraaYX13sHxgQbnYDFp+Mi0kbYQd4fmLEL+aO3e6Ytk19MF27UuowS2iu0KvvodNfLVEdIsnQZ77kB@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/ZpwdEovPnxfvyczuU4Ey3B2oYliZwHRe1NTXujnA52CMc/n9
	8xlsJO5tT5X4f54eSX4Mk7DorEzSe+GawZ8AGpOg+n3FuZDKfEdZ/n2aJgnJlKcNqDA=
X-Gm-Gg: AfdE7clkS7WOGBTTnO4vRZvQYaaD+GkYkWkZkATdrHQAU1NXa2nVNHhZXPQHAMgpUVo
	VQWUACPBayd5wCvSovZ/+ef/Rq4ix23pOmSEsomXiIXmoXTWfijHBkZBD4pOmFrp5l6+yOVRNiE
	ZGP0qi7lOSf80e8WspF7AS+/st8c5Xd6p+ojXYkyKUFm9LhKMCeKC4ALSYf0NzpnPD83WzHdUCt
	WEhSpzXTISkYUsXf2QMHTQXThHM2s1vm421qjtH7IB44Hg/sLzwPgJswSIVRFqDkK91u0o+h3IC
	A0bjRjcVjeb6x4OZI+O+BtJiwetXkMvmr0zymbr+u1CUM0eUHQU5/Yvlq9pEYz4I3WyEKGprJo7
	FwMbStL7TPGxJDIuP0YE8vqBLc3TucVPVgZieN0CglY9BYH4yFd+2uQfS2bKdiloOebkrlSVT5L
	fVfPKegBRSsktb5mgxbEBuZA3B5Sxm8WpcdBXznwoDQj5WnkxzeEaO4IxKNbIJ5FImdkz4EgDQR
	RYwD/NZKqYEaG4h
X-Received: by 2002:a05:6000:460f:b0:475:f0f0:9ef1 with SMTP id ffacd0b85a97d-47f2dd0d580mr8735399f8f.54.1783938157596;
        Mon, 13 Jul 2026 03:22:37 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f484700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f48:4700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa09608d4sm84858344f8f.25.2026.07.13.03.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 03:22:36 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: tytso@mit.edu,
	jack@suse.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] jbd2: bound shrinker scans by examined checkpoint buffers
Date: Mon, 13 Jul 2026 12:22:29 +0200
Message-ID: <20260713102229.1598812-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713102229.1598812-1-max.kellermann@ionos.com>
References: <20260713102229.1598812-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The jbd2 shrinker currently accounts only checkpoint buffers that it
successfully releases against nr_to_scan.  Busy buffers therefore do not
consume the scan budget.

If a checkpoint transaction contains mostly busy buffers, the shrinker
can scan its entire checkpoint list while holding journal->j_list_lock.
Large checkpoint lists can result in excessive lock hold times and leave
other CPUs spinning on j_list_lock, causing soft lockups or RCU stalls.

Pass nr_to_scan into journal_shrink_one_cp_list() and decrement it for
every buffer examined, including busy buffers.  Pass NULL from checkpoint
cleanup paths so their existing full-list behavior is preserved.

This restores the scan-budget semantics that existed before
journal_shrink_one_cp_list() was changed to always scan a complete
checkpoint list.

Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/jbd2/checkpoint.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 5266017565ac..513273712010 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -358,15 +358,16 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 /*
  * journal_shrink_one_cp_list
  *
- * Find all the written-back checkpoint buffers in the given list
- * and try to release them. If the whole transaction is released, set
- * the 'released' parameter. Return the number of released checkpointed
- * buffers.
+ * Find written-back checkpoint buffers in the given list and try to release
+ * them. If 'nr_to_scan' is set, scan at most that many buffers. If the whole
+ * transaction is released, set the 'released' parameter. Return the number of
+ * released checkpointed buffers.
  *
  * Called with j_list_lock held.
  */
 static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 						enum jbd2_shrink_type type,
+						unsigned long *nr_to_scan,
 						bool *released)
 {
 	struct journal_head *last_jh;
@@ -375,13 +376,15 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 	int ret;
 
 	*released = false;
-	if (!jh)
+	if (!jh || (nr_to_scan && !*nr_to_scan))
 		return 0;
 
 	last_jh = jh->b_cpprev;
 	do {
 		jh = next_jh;
 		next_jh = jh->b_cpnext;
+		if (nr_to_scan)
+			(*nr_to_scan)--;
 
 		if (type == JBD2_SHRINK_DESTROY) {
 			ret = __jbd2_journal_remove_checkpoint(jh);
@@ -403,7 +406,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 next:
 		if (need_resched())
 			break;
-	} while (jh != last_jh);
+	} while (jh != last_jh && (!nr_to_scan || *nr_to_scan));
 
 	return nr_freed;
 }
@@ -425,7 +428,6 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
 	tid_t first_tid = 0, last_tid = 0, next_tid = 0;
 	tid_t tid = 0;
 	unsigned long nr_freed = 0;
-	unsigned long freed;
 	bool first_set = false;
 
 again:
@@ -458,10 +460,9 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
 		next_transaction = transaction->t_cpnext;
 		tid = transaction->t_tid;
 
-		freed = journal_shrink_one_cp_list(transaction->t_checkpoint_list,
-						   JBD2_SHRINK_BUSY_SKIP, &released);
-		nr_freed += freed;
-		(*nr_to_scan) -= min(*nr_to_scan, freed);
+		nr_freed += journal_shrink_one_cp_list(transaction->t_checkpoint_list,
+						       JBD2_SHRINK_BUSY_SKIP,
+						       nr_to_scan, &released);
 		if (*nr_to_scan == 0)
 			break;
 		if (need_resched() || spin_needbreak(&journal->j_list_lock))
@@ -517,7 +518,7 @@ void __jbd2_journal_clean_checkpoint_list(journal_t *journal,
 		transaction = next_transaction;
 		next_transaction = transaction->t_cpnext;
 		journal_shrink_one_cp_list(transaction->t_checkpoint_list,
-					   type, &released);
+					   type, NULL, &released);
 		/*
 		 * This function only frees up some memory if possible so we
 		 * dont have an obligation to finish processing. Bail out if
-- 
2.47.3

