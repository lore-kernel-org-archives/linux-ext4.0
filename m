Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEC93E0096
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 11:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733125; cv=none; b=oYcnJw/W484rNfcUGxFjdosqBHrxLUnYTfguROk+RUhoBOkyiHYDnLg1ovB8kZ8I06WFSDnmmnTeRUnGLbgm8bOr9gyMPozHZabJBTt2U8brYbTEru5wifAKd53IPe99I9TE8SdCTAdmHwlPOyrxyb+QFUYjSLnP/bjDNK3w77Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733125; c=relaxed/simple;
	bh=gpBGfGGB08IWHYKbRh63vO4keQC25LklqDN97aE/hT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S/mnsUXgZU8SClDD4DMQJ3E9YvwJBi6zOlQm+swO44s2QGkt4iIlcrisCFKioo97HXB0u1mPdl1I93ro07i1CAU+zi2o4OSg7yTT7IX6XrclTz1v3TMVEnayBBrLIQG4X1Dvh5B9/eN20N7GfqDRY3ytmaTXFWjZOOBK8IEPQjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wjvKgFwO; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wjvKgFwO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782733121; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=Kp133e1bP+R1D0Vi45/vdHBewtKr+z8uoA557w7iW94=;
	b=wjvKgFwOyZxLz+VnjHNwUOEus8KGAiFiw+9SxTlU0QiczEHLjOSNnwTKk5R8M+VLc4ua/j8FpYWGldKtRoWubX/XZBhR6XHq2HUn6L/gU7WgN5e1QhROz6BPY9u4V6fpoL9y4AMN9CWYTH9QF6+blUGu1iHkZG/paq3NQLFNcxQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X5sgdBX_1782733120;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5sgdBX_1782733120 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 29 Jun 2026 19:38:41 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 6/6] ext4: fix NOWAIT semantic violation in DAX extending writes
Date: Mon, 29 Jun 2026 19:38:27 +0800
Message-ID: <20260629113827.4074335-7-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260629113827.4074335-1-libaokun@linux.alibaba.com>
References: <20260629113827.4074335-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a DAX write starts before EOF but extends past i_disksize,
ext4_write_checks() skips the IOCB_NOWAIT check because
iocb->ki_pos <= old_size. However, ext4_dax_write_iter() later calls
ext4_journal_start() to prepare for inode extension, which can sleep
waiting for journal space or transaction commit.

This violates NOWAIT semantics and can stall asynchronous I/O frameworks
like io_uring that rely on non-blocking behavior.

Fix this by checking IOCB_NOWAIT before calling ext4_journal_start()
in the extending write path. If NOWAIT is set and extension is needed,
return -EAGAIN so the caller can retry in blocking context.

Example scenario:
  - File: i_size = 1000, i_disksize = 1000
  - DAX NOWAIT write: offset = 500, count = 2000
  - ext4_write_checks(): ki_pos (500) <= old_size (1000), skip NOWAIT check
  - ext4_dax_write_iter(): offset + count (2500) > i_disksize (1000)
  - ext4_journal_start() → may sleep → violates NOWAIT

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260618125735.4156639-1-libaokun@linux.alibaba.com?part=5
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0e9448a110dc..9a16071b719d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -725,6 +725,11 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	count = iov_iter_count(from);
 
 	if (offset + count > EXT4_I(inode)->i_disksize) {
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			ret = -EAGAIN;
+			goto out;
+		}
+
 		handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
-- 
2.43.7

