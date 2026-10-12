Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E2C486B8F;
	Mon, 12 Oct 2026 11:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805681; cv=none; b=OgEw8Fb9CzyPNZp5/IRH3uZ4nAjsXnq0Sa7CgBiPkQBMZ1Q+SY3tyVfutG8SMSbigljR8kAXdXe8EBeGKvNgOME4blhSNlcfY0vqNUKKVNFqV5HQDabG96auG8zdr89kH6fYZGnm3BHNNm+w24rruH159Sapj9BsRZsmisjSy/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805681; c=relaxed/simple;
	bh=u/FrjB6I0lj8OmlShb9gfX/cV5TpLi9ILFa5s7s63iw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FLHEPWKmnhkJt1mzJsejtnxaC8KDMBwAqFOLh0s3Bylwi8iAw6JpmLVNCbuHD0HvPayeEIkDke343eQYQPNLhZH4zLFHry4pK08gPCm9n3ry5oW1OKM0EhzUDnokQvAGqEk+PcUdD0YCxNPdfhZfZslvwu6sacahD3I0VzD4Sm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=e1J7nJTs; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="e1J7nJTs"
Received: from localhost (gyproxy-mailtls0-entmail-virt215.gy.ntes [IPV6:2409:8d28:140:849:c9f1:798d:951b:9e3f])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50bb2b788;
	Mon, 12 Oct 2026 19:47:44 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH 2/3] jbd2: check return value of blkdev_issue_flush() when committing
Date: Mon, 12 Oct 2026 11:47:12 +0000
Message-Id: <20261012114713.4049391-2-guolingxing@tju.edu.cn>
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
X-HM-Tid: 0aa12ff0ab1803a2kunmef167be047e83a
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTEMfVklDQh1JSkhNSxlOSVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSk9LQUNPQkEYQh1KQUxCQx9BQk5KGUFCHk
	gdWVdZFhoPEhUdFFlBWU9LSFVKS0hKTENKVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=e1J7nJTsbfWSBoa1PoccMkWqkfbDO1jD4iFO6x7lGhAuQQF59dEvuCPDDBI/IV47vgsOvZ9gQR/c9n7/MTqW/EfER6h+NG+5GnB6iLvq7u8SYkl3xXQxWg39OFKK4u1XV/CYF7rf6SIuZjoAiOklIhbw6G9qaNv7FnlDbnmj3oE=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=RjGt3ZP3ZB6apk3GFMJWI0Ilz4mIsRFM/N+BaxsjmCg=;
	h=date:mime-version:subject:message-id:from;

For journals on a separate device, jbd2_commit_transaction() must
flush the file system device before submitting the commit record,
otherwise the transaction may get committed while the ordered data
are still in the device cache.  However the return value of
blkdev_issue_flush() is ignored so if the flush fails, the commit
record is still submitted and fsync() reports success although the
ordered data may have never reached the disk.  After a crash the
journal recovery will consider such transactions committed and data
written by fsync() may be lost.

Abort the journal when the flush fails.  The commit record is then
not submitted anymore since journal_submit_commit_record() checks
for an aborted journal.

Fixes: cc3e1bea5d87 ("ext4, jbd2: Add barriers for file systems with exernal journals")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/jbd2/commit.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 3029cb6f6d64..99477e9c78c7 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -800,8 +800,12 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 */
 	if ((commit_transaction->t_need_data_flush || update_tail) &&
 	    (journal->j_fs_dev != journal->j_dev) &&
-	    (journal->j_flags & JBD2_BARRIER))
-		blkdev_issue_flush(journal->j_fs_dev);
+	    (journal->j_flags & JBD2_BARRIER)) {
+		int err = blkdev_issue_flush(journal->j_fs_dev);
+
+		if (err)
+			jbd2_journal_abort(journal, err);
+	}
 
 	/* Done it all: now write the commit record asynchronously. */
 	if (jbd2_has_feature_async_commit(journal)) {
-- 
2.34.1

