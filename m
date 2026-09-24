Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CBD3C7E13;
	Thu, 24 Sep 2026 10:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790247106; cv=none; b=uYxnS8r42Ex7OoypfLF7iVYsChDpYPg0FlgZT+ZOuvn64snN9+rW3VELneVM4WI55o1/pHoPUSbLptrX2MiZQvzXvLIPNxDZKBCUNTPfdQB+7jjwz5MJ73KW4TV6c7ysPS4GPf0gQQQk6tAnxWMwHdvmuM2Cy1dUgTLU6sm3KWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790247106; c=relaxed/simple;
	bh=5gW3H/1yVOxL00jh4JY44hYMcfiOVXML9SuZIS61MNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WGhzdJOdZ/TNSE9MIzwlRgBgDbANo9mBOerGTUn3XpmsDvZqgXBBH2bBFu51ewZuafMaVS1F58Q6G7UzbV7RxSZ+dN4Ef+1AQFhPlBHG+GZ3eBW/dzh2kguiCATL/dAGmYA68AISSeYsKxieeBXR+27oSeep1rD4of8K3hmWxWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=CKOuThfC; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CKOuThfC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=2C
	SflERWiIEUtHIYwYt7AZ8Vjsf1CeCsPdvuomIllHU=; b=CKOuThfCUhYxOEZhkl
	6qAaaBgFrq/JIGA9bKG2NPmje9vO7KW2kQk0vtmujQuQz0EaoBxnGxdFkOUOiysW
	Gr0nEtwgJPrmITRx8fVY1sRsWLgiUpF0iiQR8p/voCsxZhRq0FK1ceRXKSbeg1wE
	7v7lPFu0vLgTUN5baEU31xwwY=
Received: from pc.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgBHFxixALVqNOv+Aw--.7356S3;
	Thu, 24 Sep 2026 18:51:32 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jan Kara <jack@suse.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 1/3] ext2: drain in-flight DIO before buffered write fallback
Date: Thu, 24 Sep 2026 18:51:23 +0800
Message-Id: <20260924105125.577714-2-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924105125.577714-1-yaojiale02@163.com>
References: <20260924105125.577714-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgBHFxixALVqNOv+Aw--.7356S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFyUuryxtFyDXr47tF1DJrb_yoW8Zrykpr
	Z093W5JryqyrZ7Wwn7Wa18ur1fK398ArW3XrWvv3WDCry5Gws0gF4ktr1jvF1fGFsrJw4Y
	qan29r97u3W0yaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0p_o7KUUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhQ1b2q1ALR1kwAA3N

An asynchronous direct write can remain in flight after the inode lock is
released.  If another direct write falls back to buffered I/O while the
first write is still pending, generic_perform_write() can dirty pages
before the first write completes its post-I/O page cache invalidation.
The invalidation then finds dirty pages, reports a page cache invalidation
failure, and records -EIO in the mapping error sequence.  A later fsync()
therefore returns -EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed the same race in
ext4.  Ext2 has an equivalent fallback after iomap_dio_rw() returns
-ENOTBLK or a short write, but does not drain other in-flight DIO before
dirtying the page cache.

Wait for in-flight DIO before calling generic_perform_write() in the
fallback path.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning and made a subsequent fsync() return
-EIO:

  Page cache invalidation failure on direct I/O.  Possible data corruption
  due to collision with buffered I/O!

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.alibaba.com
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 fs/ext2/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index b9020df7d89e..67fe423c3828 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -135,6 +135,13 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		int ret2;
 
 		iocb->ki_flags &= ~IOCB_DIRECT;
+
+		/*
+		 * Prevent concurrent direct I/O and buffered I/O to the same file
+		 * range. Wait for in-flight DIO to finish before dirtying pages.
+		 */
+		inode_dio_wait(inode);
+
 		pos = iocb->ki_pos;
 		status = generic_perform_write(iocb, from);
 		if (unlikely(status < 0)) {
-- 
2.34.1

