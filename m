Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EC33D669C
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 11:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733126; cv=none; b=OlmtgxxdyRX8NO2FFN1rYio/wb9yLiUkJONVC4p1flFSoKSf+KGY6LmuzVxD8NkYMQkbBbK0KbD3eGzOOFESCyA8lQWo9vMLiou/XMfml9eFbw8mNt05dAs4ATjFoJIwT9H7WoCFPGLu66ngLDHQ6yMbyi14rlFeWszXnasN/HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733126; c=relaxed/simple;
	bh=WEcZoRfXpMwDbR3gbRqVE6LS4xC/iBHMEtj3uBir7R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJRUU76pFZCtxlFb2UIzBRBo8izN84xVcMWGTF/wOCUcc7ok0vI+RmMVF8uHwijLc87y1EpMTi0OTY6WHHPUWBocJO397mu6kirTMARjtPB535kBrrpmKvR2GvvtUANs1BUuI6CfIUURZbfnUFxYRrPEVNZHExYpmUUO9hzXurw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=IS+LW/Dp; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="IS+LW/Dp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782733121; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Q56tzq2bPLyyH6+TKN6Kz46W3oQEgJEiDHUoj/cuacA=;
	b=IS+LW/Dpi3Z6BOGrBYaGtaqYJbK2PgYz8DfVdE9TzPWI4KKeLZbHvI+CVJrUs8NWWwRq9l4tHEJE1j/Dk+WoKMlWhD4Ozel8tWsjwJzQLIzn3xweObgjexFA8lN6TGVPfrYbokFd7lOBQblrM8WgRfAGkyYDLsyvMpvNk9SWyZk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5sgdBI_1782733120;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5sgdBI_1782733120 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 29 Jun 2026 19:38:40 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v4 5/6] ext4: use kiocb_modified instead of file_modified in DIO/DAX write path
Date: Mon, 29 Jun 2026 19:38:26 +0800
Message-ID: <20260629113827.4074335-6-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260629113827.4074335-1-libaokun@linux.alibaba.com>
References: <20260629113827.4074335-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

file_modified() passes flags=0 which drops IOCB_NOWAIT, causing
file_update_time() to sleep in ext4_journal_start() via
ext4_dirty_inode() even in non-blocking contexts.

kiocb_modified(iocb) propagates iocb->ki_flags so that
generic_update_time() correctly returns -EAGAIN when IOCB_NOWAIT
is set and ->dirty_inode could block, matching the behavior
already adopted by XFS, FUSE, and ext2.

Affected paths:
- ext4_dio_write_checks(): DIO NOWAIT write
- ext4_write_checks(): shared by buffered (rejects NOWAIT upfront)
  and DAX write (supports NOWAIT)

ext4_fallocate() in extents.c is not affected as it has no kiocb.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index d12445e3907a..0e9448a110dc 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -307,7 +307,7 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	if (count <= 0)
 		return count;
 
-	ret = file_modified(iocb->ki_filp);
+	ret = kiocb_modified(iocb);
 	if (ret)
 		return ret;
 
@@ -466,7 +466,7 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
  *
  * The decision is layered, evaluated in this order:
  *
- * 1. If file_modified() needs to update security info (!IS_NOSEC), upgrade
+ * 1. If kiocb_modified() needs to update security info (!IS_NOSEC), upgrade
  *    to the exclusive lock -- the security update itself requires it,
  *    regardless of whether the write extends the file or is aligned.
  *
@@ -556,7 +556,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 		*dio_flags = IOMAP_DIO_FORCE_WAIT;
 	}
 
-	ret = file_modified(file);
+	ret = kiocb_modified(iocb);
 	if (ret < 0)
 		goto out;
 
-- 
2.43.7

