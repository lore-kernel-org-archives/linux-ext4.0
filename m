Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F6E46C832;
	Mon, 12 Oct 2026 11:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805684; cv=none; b=poFHhe0p4o2lHz7wh3bQANuhsHH7L/KM+LPV/L5JwsIX3nPPXM5pLh8iHnK/GICRYkA6Ecp+KaBfrnj7DlIlR8LzCzULwKzyKcgqnJwOTf5MAX6k40yHdHTwGGnF9RtzJ63YMkZOBl5EvosSczluOmd+dPHw68cwTcEhkTQYv1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805684; c=relaxed/simple;
	bh=qYqWcUCn6MiCl/FB5qXumgZK8VzUDIdbUosR8j9LkX0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eIaBUBhPjhY8LR7EZf26i8QfNScW046RLwmEK3aa1MwuU9y3DI2LgUTwI6XpU++0bJtlJ1gmKp/qv2SwpMw5R/5GyU/f07n/EjDegEFnUd88rRteFKcG3Smreq8OJfniP84aTRO/ataOhAz9zbGoj1zTC8Ngi+jMSXTXKCWvdtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=nL+bNp4k; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="nL+bNp4k"
Received: from localhost (gy-adaptive-ssl-proxy-3-entmail-virt135.gy.ntes [39.144.128.140])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50bb2b78e;
	Mon, 12 Oct 2026 19:47:48 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH 3/3] jbd2: check return value of blkdev_issue_flush() for async commits
Date: Mon, 12 Oct 2026 11:47:13 +0000
Message-Id: <20261012114713.4049391-3-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa12ff0ba3e03a2kunm3ef7205347e848
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGBpJVk4aSU9NHUlMTkpOTlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlIQlVKT09VSklDVUpPS1lXWRYaDxIVHRRZQVlPS0hVSktJQk
	NNQlVKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=nL+bNp4k4QOjmCQch3J+cW4y2cnmPZg9Q8AfAGJf21OkQyFfLr+F1PMvsi2VAU1zs9qyvrUqFjln2vJHWt4meELse123qMZt6Rcwt9gyrfqc+cLe1YeA/CPU2epLTk+qtK4ftBVQvwxTSzsbw4TxXuSjq9EPswFlGUdsO/KmtXs=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=8d1g2429ResGiYJIn7ErnpNUgVHxsqLqnox0s8ovTg4=;
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
index 99477e9c78c7..32ca502603be 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -912,7 +912,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	stats.run.rs_blocks_logged++;
 	if (jbd2_has_feature_async_commit(journal) &&
 	    journal->j_flags & JBD2_BARRIER) {
-		blkdev_issue_flush(journal->j_dev);
+		int err = blkdev_issue_flush(journal->j_dev);
+
+		if (err)
+			jbd2_journal_abort(journal, err);
 	}
 
 	if (err)
-- 
2.34.1

