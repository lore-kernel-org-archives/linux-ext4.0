Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EF93E3C48
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 08:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782462944; cv=none; b=jYpz+IFf7GAEgPJKFVuN9jsmPdUHfvuvcvazuIK93tRi+ZLUZwLbdvcWwn4PZEdbCsEJ/0/8DrF/1KN1KfOUcMdl0MP52zmBU4kQ9VmXLMDaQP8GrvUBCdwjEhjnvMXVRM2GQfq1qTV9yA7nV0a0AoJSzVlf6l63EPBlJGAHaiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782462944; c=relaxed/simple;
	bh=WEcZoRfXpMwDbR3gbRqVE6LS4xC/iBHMEtj3uBir7R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpYsZ6SAlqRQnXO3GfN8cVGfrgL+XzfCP6KxDG1uYrLrnV8Qk1toJB0oA3qoXbDzCw7U/8hf7vO/5Q5Gw1Lnpbw3YRnYdBuQzRflK0VL8R1KUnQ5sgLBl3NQnaJpEAixsP9gBxvcoZsRtQevhUHq0qD3LDQSBkHfpBwCJtRJN8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GL/jaRXs; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GL/jaRXs"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782462934; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Q56tzq2bPLyyH6+TKN6Kz46W3oQEgJEiDHUoj/cuacA=;
	b=GL/jaRXs5rZw5T0kLlzimhcwo4vaba/yHIh6D2tz8yGOuO/dxjhlmeHjqHqHfJWNqveagdjbnrbDG5FFuQduk76V2be9jReV7X8EYtcnxHml9chQbUwx+LVnbjh8fieyF5PLR7zROa5XeS2mNMxd1VYma3iF7CdAFLmp9Gxd3dE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5e4ziy_1782462932;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5e4ziy_1782462932 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 16:35:33 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v3 5/9] ext4: use kiocb_modified instead of file_modified in DIO/DAX write path
Date: Fri, 26 Jun 2026 16:35:14 +0800
Message-ID: <20260626083518.1064517-6-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
References: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
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

