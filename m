Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49056364EB8;
	Mon, 28 Sep 2026 08:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790585672; cv=none; b=ctkSp6IKs7hLxb82pe25QJPQxUwqVxy8m8f8YT13Yq4aIMPtHtYcJt9p7V4CgRuWGJfjHsDAWY34zF6ZsZRbLKbjYwPQpqYw5bm+he1YcvZRBBMj2ld6lDTnReQpvBjNUMnHTD3vzxai5a+NyA3T/6O1DRMj/hRSUNO1xE3OeA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790585672; c=relaxed/simple;
	bh=5gW3H/1yVOxL00jh4JY44hYMcfiOVXML9SuZIS61MNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hvzgU6faaa5B0gYuH5v7qannbCLH5kY7a2ErO1ZX3Iv7n6ZS28uIVCp4tn57pBVHij08bk/Nys1wY2A2gE8sCsP8TuN8K0JEVJEtYtoX9Z/8KRa5e3XBgMb6re2GmyGjzI7MuvZpbAqbT1/ugYhOaJFfW6AK2/uIMwTAMib99xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AkuKIMfe; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AkuKIMfe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=2C
	SflERWiIEUtHIYwYt7AZ8Vjsf1CeCsPdvuomIllHU=; b=AkuKIMfefAeDzcrSzh
	K97jzq9oF0lcUjL5stJxR7APUWu9D5/bXjOIYFkvjxbC/hALlrPLMXC2UlF0bO76
	VJQAZO3uKRFaPW12b/JxpyulpHnFvig5Mm7SX6jjLSgmkYcKC8sQx3/zXPsvhfHF
	4BtmbrKvqcNJofkccWvVl1pmQ=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3t582K7pqm5HnBA--.52401S3;
	Mon, 28 Sep 2026 16:54:16 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jan Kara <jack@suse.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH v3 1/3] ext2: drain in-flight DIO before buffered write fallback
Date: Mon, 28 Sep 2026 16:54:10 +0800
Message-Id: <20260928085412.2221055-2-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928085412.2221055-1-yaojiale02@163.com>
References: <20260928085412.2221055-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3t582K7pqm5HnBA--.52401S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFyUuryxtFyDXr47tF1DJrb_yoW8Zrykpr
	Z093W5JryqyrZ7Wwn7Wa18ur1fK398ArW3XrWvv3WDCry5Gws0gF4ktr1jvF1fGFsrJw4Y
	qan29r97u3W0yaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zinYFJUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhkiXGq6KzmQFAAA3v

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

