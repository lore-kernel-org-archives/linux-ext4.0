Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309834483BE
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 07:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752331; cv=none; b=diwC63//Va0VuiG68XZHMIaUTcZDXIi41atNuSsSJ55CpO9Xxu5ZR62pRJAgT02zTfD4cCX2tqEqXRuw63wZDKpEoxVuchfLgQqhypfF6MVaXZYfac6seZyWGIhk/sKFra4diAiKvYvA8yJGVEeyl+DpERCSMLZaqKekNzP0ePk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752331; c=relaxed/simple;
	bh=1oYWUB/5XT5Mh/9NCF8Nu1bpaaOruDR7UHM2wX9aEEQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=WjcFWUDRedNU5Kf5kEerioOMb4jkl+vPUDcxkLOP27Y6Kt9KgaSubUC7bSyJ8yjS3EOCc+mbvjjcoHH7UI0W4Vx63qA29xFPU1+Q5MxN7xxztd0Y7EUR41oF6ylB9fxe9VxVJwnT6dyLAzde19TJcQkPYy5Fbq0SEyRKuVi6wzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZcxyoZx8; arc=none smtp.client-ip=74.125.229.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZcxyoZx8"
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-34bcb929cceso870983eec.0
        for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 00:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790752329; x=1791357129; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WiZTybaldVx4e5A6kLF6m48cyba3CONHAf6iW/bp+V4=;
        b=ZcxyoZx8mkIadcFilE8YDXWO++sQkFhQSteNoYddOb8E10fGRcJtzQFl/vUfviA5ep
         WVmNl1aPy5yGI8N26Q1XqsKNaR6LnRoA/cZctOacOGXoFariOf1Zt3KLuCMFmgdB79Pp
         bLnBupnfZ8mZQOiOLKzp/8JXmN0ZfYmEFLyo8eMIZ0n6eCIAKHQkO9wzGeTLO9Fo5UjY
         At36qWChRF5tvKTF7Xp6CRkswVorMwSKQGLn7gpcKEBGRnYnZGYcl74z5p7uaOUfiplO
         MoPafS8F1zOurjmnsF/ECoE7xRRJtfhxwYc1So4Jhy/JVCKWhPgDs/C5OmG6E6H6xhns
         n5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790752329; x=1791357129;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=WiZTybaldVx4e5A6kLF6m48cyba3CONHAf6iW/bp+V4=;
        b=C8rUz6OjWhJ5e4RhISbwI7/opsa7s/iUe8gral0nBsCTSw5R6dMg+wIgWG+dX49/J5
         3ZyZeAij7njn+fMd4wmPqNpcHGrm5ibldzPNXfxEbjYO3ihJjT3BrsdfsW0NRFZVgD+9
         Kb4jUfwoqLCT72r1XeiEb0QoUz96zbcQuGNxSqqgfO2XH6VSC7zzwH96wAtn6O7SOkXI
         dS5ROgVMji3pLT8zxALlSUiQszMFFBvA6BfPtAhARyaTfYclX52AOT58wbTQOzZ96A/J
         7XW1xTk8LspmrQMgko4n/1+4oNrkiZuTJnX7HdUEGSM2vq44wnLEkl+Dms5AvLzYedP1
         qoXg==
X-Gm-Message-State: AFq9FYJiill81CyfRNMrWQTl84mIo2Z5YP89CKc7EHnxLUbwr8hQzgfE
	0YoNy35d1aDAesttD5TewnBBPk6dwrYBZF4DszCYuz5NspeDiSWZCi0u
X-Gm-Gg: AYBFou2hrc86e8YlvtNtVG+4d8svrf9jZxpt8jRQrYSbmrHRWwjJH9f2gZ6qPgazFfM
	3WakESCl0zBLJxQPvgu76Ch4qLgrMGav2aTF8vAFUqw2VNN0gbuDygqqbo1Reafz8R1oLhsjRDY
	Hyv3NT2Bhh7BcdejefC0vW53SrncHIWuDJphenIA7gkZpxiM7gQiXps7R007Eqvbi0dpHf2Nupr
	NeDbhRvkTOl/J9jXKNeIFH3CY3AteWLv7IHt/TGQq99wqoJoRPHWiXw8B9Qsz3Uc8Aai25Qkek/
	d1XCUetwLG3gqduRVtfbdTtN5Ff8ihQ7/HmRCHqU6WCgLcB9edKSBHZeCtkycKL1gvSmsoZBb3b
	k181Wt9DTw/rt1lAd9Hdn+9icDjWNUAqzg4lHpzz8rIsF8QGsoucGy8QpkGD7RcMnP8/f1WT2YR
	suyyDWRqi0SPzKpkRvwq0uAZcUEt6iotIfXtSVjB702DyJcJ+yN3ifeqT76Ia3KwVAPw==
X-Received: by 2002:a05:7301:4d15:b0:33c:6e0:3cd7 with SMTP id 5a478bee46e88-34cd917cfc3mr851963eec.1.1790752328821;
        Wed, 30 Sep 2026 00:12:08 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34cf5e423fasm1882953eec.26.2026.09.30.00.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 00:12:08 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Wed, 30 Sep 2026 15:11:58 +0800
Subject: [PATCH v4] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-fix-jbd2-shrink-scan-nr-scanned-v4-1-eb9a3ccc2524@gmail.com>
X-B4-Tracking: v=1; b=H4sIAD22vGoC/5XNTQ7CIBAF4Ks0rB3DT8XiynsYFwhDi1pqwBBN0
 7tLuzKu7GryJnnfG0nC6DGRQzWSiNknP4QS6k1FTKdDi+BtyYRTLqniDTj/guvFckhd9OEGyeg
 AIS43oAUjqGqMVZQhJ0V5RCyVZeF0Lrnz6TnE9zKY2fz9384MGKB0NWUSjVTq2Pba37dm6MlsZ
 77S48XbI0OHRmhn3a8nVnqieIpJo7XeiZrTb2+apg9xcCdybgEAAA==
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>, 
 Jan Kara <jack@suse.cz>
X-Mailer: b4 0.13.0

jbd2_journal_shrink_scan() never signals SHRINK_STOP, so
do_shrink_slab() has no way to tell "there was nothing to reclaim
this pass" from "a full batch was scanned and none of it was
freeable". It keeps calling scan_objects() until the original,
one-shot total_scan budget derived from the (possibly stale) percpu
checkpoint count is drained, even when every buffer in the
checkpoint list is busy and nothing gets freed.

Return SHRINK_STOP whenever jbd2_journal_shrink_checkpoint_list()
frees nothing, so do_shrink_slab() stops calling us for the rest of
this reclaim pass instead of burning through its scan budget against
the same stale freeable count.

Tested by creating 20000 small files without an explicit sync (to let
jbd2's normal 5-second commit timer move them onto the checkpoint list
while their buffers are still busy being written back) and then
triggering "echo 2 > /proc/sys/vm/drop_caches", tracing jbd2_shrink_*:

              scan_objects() calls   calls with nr_shrunk == 0
  before             176                    176 (100%)
  after                8                      8 (100%)

Fixes: 4ba3fcdde7e3 ("jbd2,ext4: add a shrinker to release checkpointed buffers")
Cc: stable@vger.kernel.org
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
V3 -> V4:
- Drop the sc->nr_scanned computation entirely; just return
  SHRINK_STOP when nr_shrunk is 0 (Zhang Yi, Sashiko AI review).
- Add Jan Kara's Reviewed-by (carried over: the code is functionally
  identical to what he reviewed in v1).

V2 -> V3:
- Rebase onto v7.3-rc5. It already includes Max Kellermann's
  "jbd2: bound shrinker scans by examined checkpoint buffers"
  (15cb16496446), which independently fixes the busy-buffer
  accounting in journal_shrink_one_cp_list()/
  jbd2_journal_shrink_checkpoint_list() that v2 also touched. Drop
  the now-redundant checkpoint.c changes; this revision only touches
  journal.c, reusing the accurate nr_to_scan tracking Kellermann's
  fix already provides.
- Add a Fixes: tag for the commit that introduced
  jbd2_journal_shrink_scan() without ever setting sc->nr_scanned.
- Re-measure test data against the new baseline (176 -> 8 calls,
  vs the old baseline's 168 -> 7).

V1 -> V2:
- Count examined buffers, not just freed ones, in
  journal_shrink_one_cp_list() (Sashiko AI review finding).
- Trigger SHRINK_STOP on nr_shrunk == 0 instead of
  sc->nr_scanned == 0.

v3: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v3-1-916caaa53420@gmail.com
v2: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v2-1-7e1efec3afdf@gmail.com
v1: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com
---
 fs/jbd2/journal.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 00f5a98f3d4fe..c921afce7d061 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1267,6 +1267,16 @@ static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
 	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
 	trace_jbd2_shrink_scan_exit(journal, nr_to_scan, nr_shrunk, count);
 
+	/*
+	 * A checkpoint list full of busy buffers can keep reporting a
+	 * stale, positive freeable count after nothing more can be
+	 * reclaimed. Stop this reclaim pass once a call frees nothing,
+	 * instead of burning through do_shrink_slab()'s scan budget
+	 * retrying against buffers whose writeback won't finish any sooner.
+	 */
+	if (nr_shrunk == 0)
+		return SHRINK_STOP;
+
 	return nr_shrunk;
 }
 

---
base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
change-id: 20260928-fix-jbd2-shrink-scan-nr-scanned-c3098cd901e2

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>

