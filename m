Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C988A4DA0C
	for <linux-ext4@vger.kernel.org>; Tue, 27 Feb 2024 21:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.238.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709069609; cv=none; b=YeR5KboDeBspgtPGQMp+swcU/L3Y7kXu3i/OrpRno9gQ/cqaAYExuK6oe3ZveZfw7bkcJjiyTmmCybyb9yad5EL7oYkOiQeOsLF4Nfdb6zQr2qNyrtmwS2fMFAwR/X7BjMM7W76T9ISBh/nUCyiGUWciko7LqvKUMVa66hpcLZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709069609; c=relaxed/simple;
	bh=Ng5fq7bFGKGorX8ineXVl98VlG7mcrnX9ER8uqksi1c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LyiWKbwuHvTtHemQ0csEK8EHs4QTosI04Ey/E9yeakwnumjyIH5t0KNJXlk1T0Ms8edAeTIk5fJEJ/kOd4RSj8exuG0AvdW4ucyK1lpLLdi6HVlw7rR1sx1RwT+Im8/qWlDR3y+a5rPJik/VkTzcfpnOGZdzU8EZM3Vr6yjpnkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net; spf=pass smtp.mailfrom=thesusis.net; arc=none smtp.client-ip=34.202.238.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thesusis.net
Received: by vps.thesusis.net (Postfix, from userid 1000)
	id 1CDB627452; Tue, 27 Feb 2024 16:26:38 -0500 (EST)
From: Phillip Susi <phill@thesusis.net>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
	Phillip Susi <phill@thesusis.net>
Subject: [PATCH] [RFC] Fix jbd2 to stop waking up sleeping disks on sync
Date: Tue, 27 Feb 2024 16:25:46 -0500
Message-Id: <20240227212546.110340-1-phill@thesusis.net>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I noticed that every time I sync ( which happens automatically when
you suspend to ram ), ext4 issues a flush to the block device, even
though there have been no writes to flush.  This appears to be because
jbd2_trans_will_send_data_barrier() returns a 0 when no transaction
has been started.  The intent appears to be that a transaction that
has completed should return 0, and that when there is NO transaction,
it should return a 1, but the tests were in the wrong order, leading
to the 0 to be returned before checking for the absense of a
transaction at all.  Reversing the order allows my disk to remain in
runtime_pm when syncing.

I *think* this is correct, but I'm not very familliar with jbd2, so it
may have unintended consequences.  What do you think?
---
 fs/jbd2/journal.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b6c114c11b97..be13dae767be 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -632,14 +632,16 @@ int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid)
 	if (!(journal->j_flags & JBD2_BARRIER))
 		return 0;
 	read_lock(&journal->j_state_lock);
-	/* Transaction already committed? */
-	if (tid_geq(journal->j_commit_sequence, tid))
-		goto out;
 	commit_trans = journal->j_committing_transaction;
 	if (!commit_trans || commit_trans->t_tid != tid) {
 		ret = 1;
 		goto out;
 	}
+	/* Transaction already committed? */
+	if (tid_geq(journal->j_commit_sequence, tid))
+	{
+		goto out;
+	}
 	/*
 	 * Transaction is being committed and we already proceeded to
 	 * submitting a flush to fs partition?
-- 
2.43.0

