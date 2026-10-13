Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA66417D7A;
	Tue, 13 Oct 2026 01:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791855675; cv=none; b=VfTBnCUQrku/JBErOMcdIrF5I0773G5Zjb9yee/B6WVoz7HNoGwVubbthHk1/IiE2yi3Bm7ehgUoOo61ZPiX0m8Qd5T4kvr2LhYdy6YlcgCh/T4dm3OQxvZRmw19vd0q8uR4opUxviidfZgSM57xtDDVVJimSrvNje2aPfTQlWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791855675; c=relaxed/simple;
	bh=gTRDGZXS/ElOUG7YXVlzfeE0FjqPoS8JvzJ6p9GTtEo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IrBJCi9zpabHv/lE89GtkBQo4NlRheSdaUhNSr7YDIRmpmsiiATGu2WxAN2P2G179oT7XjML2FKx53QBPT5IflzmVw4zjqH2XE1/FKMeAD3Lf3J+n2btT0cZIuzjkDAEPp1ATCbUrBDBzXPmBfTZ5YctoGQ6paqMtzhsZDL6L4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=qzroEZa3; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="qzroEZa3"
Received: from localhost (gy-adaptive-ssl-proxy-2-entmail-virt205.gy.ntes [IPV6:240e:471:430:37de:7ca5:8deb:704c:6197])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50cb20abd;
	Tue, 13 Oct 2026 09:41:07 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] jbd2: check return value of blkdev_issue_flush() for async commits
Date: Tue, 13 Oct 2026 01:40:28 +0000
Message-Id: <20261013014028.1152277-4-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013014028.1152277-1-guolingxing@tju.edu.cn>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
 <20261013014028.1152277-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa132eba86d03a2kunm516cbfb549bb08
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQx9DVhofHU9CQx1MS09CS1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0seQU9MSkFPSEtBSEwfHkFMGBpOQUMfHhlBTEtPGEFNSk
	JMWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ01CVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=qzroEZa3IgSzq1q2J5qrNSqzALd6Id3959vXgITluVrSLk74BRRnr5EPES+xnve4l4Io3P/6Wd1iwQGTpB0q/cSZ5NMMiV2BwgRwBDG0Z/Q1Vq+8hFN/Ib9X4hmIX5IsZqIazVQRzPmE2nW5DbQaDtUJNsXXKf7kuXT8HSZIiDc=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=lri7Vuh8Rri1lrGUbZyaMa3zHPULPB1JfCcowMTrkt0=;
	h=date:mime-version:subject:message-id:from;

When asynchronous commits are enabled, jbd2_commit_transaction()
calls blkdev_issue_flush() on the journal device to make the commit
record permanent.  However the return value is ignored so if the
flush fails, the transaction is considered committed although the
commit record may have never reached the disk.  Abort the journal
when the flush fails, as we already do when waiting for the commit
record fails.

Fixes: f73bee49855f ("jbd2: Modify ASYNC_COMMIT code to not rely on queue draining on barrier")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/jbd2/commit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 8c561e42b60a..4e8ebce34077 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -912,7 +912,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	stats.run.rs_blocks_logged++;
 	if (jbd2_has_feature_async_commit(journal) &&
 	    journal->j_flags & JBD2_BARRIER) {
-		blkdev_issue_flush(journal->j_dev);
+		int flush_err = blkdev_issue_flush(journal->j_dev);
+
+		if (!err)
+			err = flush_err;
 	}
 
 	if (err)
-- 
2.34.1

