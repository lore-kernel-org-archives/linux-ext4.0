Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C363F23AF
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 12:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787479; cv=none; b=M5psIxAKZXlcIn/a82HZNMWGlWWXu9tNFJFTuxDmj7Re7jkEwXIwQVTbRI8sKYHrg9IQKCeHdbAUdkxDwsmtzASbBCMdCSUG3MfZIkm3XJkULKID9n1KqTbg1s1x17OJm+yVW/Ll21GPfoETI9lpreo1pjj6eV+QLdXjrdxDo6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787479; c=relaxed/simple;
	bh=G5xRiwXbSp87jLiOvS+3JozqNnSegWEuPAZchqzeWhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSDf8rN/TRDsZHazZw9EROG5JKNtFNk5UWIZgYP1Q6XtPtHzVPQc+eQmA1BorI8fHJJnOOqNSmjMTlOfrxh9C9PfGlMwvx7NgwMWnjBlr4OQ6SckXFe/7/LUsWUEMh5WsNX+PjwSDYDfeDhyuTY6akJtJ1BbUX/kIFv7/oT9/Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Zh9lGZNh; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Zh9lGZNh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781787475; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4HlBlmwlJej0sLuQFAGk3LzRy0aKyzHdxI9nyDOc/y8=;
	b=Zh9lGZNhZCycbXe6vaXWBTc1N1Fp3ldWHxjAYAKyVbDnOaHBqP0SuZApBxN3qCkV5fc/x3W6vQYwkLa/ige12lB5+rf5MKULBYc5B6hG5rl9MHWnUDor5hPYd0Be4cHEwaFYI/BGc1Xa/DwQSxlqkR5++M39oS3gPJqOs8C19FU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X575f2A_1781787474;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X575f2A_1781787474 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 20:57:54 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v2 5/8] ext4: use kiocb_modified instead of file_modified in DIO/DAX write path
Date: Thu, 18 Jun 2026 20:57:32 +0800
Message-ID: <20260618125735.4156639-6-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
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

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2681f148e7b8..5ffc1afd8050 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -307,7 +307,7 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	if (count <= 0)
 		return count;
 
-	ret = file_modified(iocb->ki_filp);
+	ret = kiocb_modified(iocb);
 	if (ret)
 		return ret;
 
@@ -465,7 +465,7 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
  *
  * The decision is layered, evaluated in this order:
  *
- * 1. If file_modified() needs to update security info (!IS_NOSEC), upgrade
+ * 1. If kiocb_modified() needs to update security info (!IS_NOSEC), upgrade
  *    to the exclusive lock -- the security update itself requires it,
  *    regardless of whether the write extends the file or is aligned.
  *
@@ -555,7 +555,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 		*dio_flags = IOMAP_DIO_FORCE_WAIT;
 	}
 
-	ret = file_modified(file);
+	ret = kiocb_modified(iocb);
 	if (ret < 0)
 		goto out;
 
-- 
2.43.7

