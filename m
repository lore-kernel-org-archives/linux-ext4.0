Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C3C415F17;
	Tue, 13 Oct 2026 01:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791855671; cv=none; b=TN1oy3jT/u6IsRVZyi9cpf1MBGmYSTmJ2gFCGGskkc9rr/VzrT81g8ANv6gwM5aiz8r5XdQw4rxUV1cy/n33uGW8aQLpGOe3Lg/u4n7BNsHdQopZW0PZ8EzAVN2SsScfxhTNKnDPGEyr7QMC7+cmBKnbAhHq+tnBpt1b6dYboxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791855671; c=relaxed/simple;
	bh=2YJyMThVUndm3oD+kJbqEIURGUHZrWy3ybVbazOq5FU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kNZieHmZFfBuV7D6YBcir7vf6050I+oW5ASCSzOZr9F1zwX2mMGlW88/WaUJeGVNavn13kojLLYDF7HyZ6yl7CN5i9l/o+72tkhtRJxJfCeeHBbykGUzAOzCxIMb4GX8pQ8g+7m6pRhlv7bXPjcWOPA80hDjg34ROzOAh+QAlhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=Pxmvvm0N; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="Pxmvvm0N"
Received: from localhost (gy-adaptive-ssl-proxy-2-entmail-virt205.gy.ntes [IPV6:240e:471:430:37de:7ca5:8deb:704c:6197])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50cb20abb;
	Tue, 13 Oct 2026 09:41:03 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] jbd2: check return value of blkdev_issue_flush() when committing
Date: Tue, 13 Oct 2026 01:40:27 +0000
Message-Id: <20261013014028.1152277-3-guolingxing@tju.edu.cn>
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
X-HM-Tid: 0aa132eb995b03a2kunm3be2324f49bafd
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSUkeVklMGkNIHU5DHh9IQ1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0seQU9MSkFPSEtBSEwfHkFMGBpOQUMfHhlBTEtPGEFNSk
	JMWVdZFhoPEhUdFFlBWU9LSFVKS0hKTENKVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=Pxmvvm0N2SpXtnvO8KdjYZZw+KpCYovagkrvOdrqkF1NGst7w1ANdKziA/HBMCRcPoB9vPZNFKVmqyrC3Ih26F20iSUJ0E7ImtngM7RpSYWd+Op43wQU+6svQnbDUFTedcU7OqzJ97ukoV0e3IDJ/1wvRfZ6tM1Y6CD1onuG6g8=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=iSFp3UqsXhZabYzs7h/Zns9j1wTRU8JOmsLbtln+Jks=;
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
index 3029cb6f6d64..8c561e42b60a 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -800,8 +800,12 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 */
 	if ((commit_transaction->t_need_data_flush || update_tail) &&
 	    (journal->j_fs_dev != journal->j_dev) &&
-	    (journal->j_flags & JBD2_BARRIER))
-		blkdev_issue_flush(journal->j_fs_dev);
+	    (journal->j_flags & JBD2_BARRIER)) {
+		err = blkdev_issue_flush(journal->j_fs_dev);
+
+		if (err)
+			jbd2_journal_abort(journal, err);
+	}
 
 	/* Done it all: now write the commit record asynchronously. */
 	if (jbd2_has_feature_async_commit(journal)) {
-- 
2.34.1

