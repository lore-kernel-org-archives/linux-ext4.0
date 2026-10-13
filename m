Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C909139CCEB;
	Tue, 13 Oct 2026 08:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879859; cv=none; b=CaJc9f98ivG+4m9pJmTn28/QWYo1l+pTxaAxbISKd0Ap2Sk3+VZ+ut/4Y/mKC/+wOqPPTGuF/V+kCe7FFElSUjv4McdNl6yEDeyY56xCd4GTUaDTr5RYnh1qjlG82hUUTHkTmEOXMFhFTdNRtmk95LY8TlFVgfBPCAG0ej89M4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879859; c=relaxed/simple;
	bh=ZMZzsJXcp53Je6UJpBdtUIUUczscPGpMwyWMth1Rc5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mm0TU/5NrYSyCTpHVL2nGjJCxUewXx8sg+YbYpPrRBJfOBD32o8YGZ9Leh6tNzRw5XBmVQC7ELMABNXh6/4WaKvlzGe73uODAtw9fb7SLwj29rjcoel0P4BWOelw7IImDVIJBXT3IxlFBFUrHhcohK/dhYFBEEU1FnXwz5C+rSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=odm3j3Xv; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="odm3j3Xv"
Received: from localhost (gy-adaptive-ssl-proxy-4-entmail-virt151.gy.ntes [39.144.128.132])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50da51910;
	Tue, 13 Oct 2026 16:24:09 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] ext4: check return value of blkdev_issue_flush() when starting a fast commit
Date: Tue, 13 Oct 2026 08:23:31 +0000
Message-Id: <20261013082331.2089623-3-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013082331.2089623-1-guolingxing@tju.edu.cn>
References: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
 <20261013082331.2089623-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1345ca4f703a2kunm576069d04afbe5
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDQkpNVksaGkNNHx5OTh9PGFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlIQlVKT09VSklDVUpISVlXWRYaDxIVHRRZQVlPS0hVSktJQk
	NNQlVKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=odm3j3XvxO5k6+07W0Fdt8uSPwNtXf6raNsKtneFUDL629Rt8H4F+js50VGyfJFsxxg7zFzylX2D6u58wLs8ysTYeQSR/wL/b/Hwhzy//H3MGfdRq6K3qBh48UFkGktMsoPeSMiz4l9nnaFZEnMOlXPJfoNvRA6Xbx7KHNLOTgs=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=ZWetvti57+HcsBtAlUpfvVBXLnijUiG57+Cx4gUTzTs=;
	h=date:mime-version:subject:message-id:from;

When the file system device differs from the journal device, a cache
flush is issued on the file system device before fast commit blocks
are written, but the return value is ignored.  If the cache flush
fails, the fast commit blocks are written and the fast commit
completes anyway, even though the updates covered by the preceding
transactions may not be on stable storage yet, so the fast commit may
provide guarantees it cannot keep.

Check the return value of blkdev_issue_flush() and abort the fast
commit if the cache flush fails.  ext4_fc_commit() will then fall back
to a full journal commit, so the caller still gets the expected
durability guarantees.

Since a cache flush failure now aborts the fast commit, also issue
the flush only when the journal barrier option is enabled, consistent
with the file system device flush issued during a full journal commit
and with the fast commit tail block flush.  This keeps file systems
mounted with nobarrier working on devices with failing cache flushes.

Fixes: da0c5d2695265 ("ext4: issue fsdev cache flush before starting fast commit")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/ext4/fast_commit.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..c669f4cd7d85 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1425,8 +1425,12 @@ static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
 	 * Step 5: If file system device is different from journal device,
 	 * issue a cache flush before we start writing fast commit blocks.
 	 */
-	if (journal->j_fs_dev != journal->j_dev)
-		blkdev_issue_flush(journal->j_fs_dev);
+	if (journal->j_fs_dev != journal->j_dev &&
+	    journal->j_flags & JBD2_BARRIER) {
+		ret = blkdev_issue_flush(journal->j_fs_dev);
+		if (ret)
+			return ret;
+	}
 
 	blk_start_plug(&plug);
 	alloc_ctx = ext4_fc_lock(sb);
-- 
2.34.1

