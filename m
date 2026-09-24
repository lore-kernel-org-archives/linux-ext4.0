Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA004756D8;
	Thu, 24 Sep 2026 11:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790247991; cv=none; b=KTmx/Io7ZgUkugNgXLwhVi7y3NKiZE5zac01SxuBOgEr+9TlfKBnzpn3wbDVSI3lXlNrI9/MQu+tqodaMi/TKRvB8du2T8puVB2RwPsiUChU/sTUIgbi+Ni9N1T9a9rn8kU1kdC+PPM6Qfg8t3CWhOlOotWHsKYW9+2XAruJXuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790247991; c=relaxed/simple;
	bh=udv3pN6JGLOROzjpDV16RH4kQg/3UFq0mNydJmYnm4g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uTJIjfTPFE4YsSmf3yeV4ufVSRzVVXwJgRTglB4lkqysZ8/TfiF+VjHXAqK9eu1EjX9Opr2pXlUWaxOxI3DVlK3R9qMsEL7PYmAXpfstq7JQ1OTH+tJedCWhvikIXxDwZAhJ0G1tgbgn7oG2y3HrMzsaHV7qurKRiW7fAXGVH6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VaT7byJs; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VaT7byJs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Au
	27lUNj1GK7J3KD7BF4roguS87dAGZ5tWOs9x7uxlk=; b=VaT7byJsvGmBeMt92c
	b18gIjzE/i9nrOm4LZqh7sl+vPg/gnvwvmfhvlyH4KzLU3OCJ9Ao6uleMUBbqzs1
	9eize13t2Rxi15IMg2S2ehl1GW0wJ+9HaETjJFg2xqCjOs7wuuVfSKzb21pzFimd
	nUogL29U1CjjYZopb3FGuDhOM=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3N3wNBLVqE0AmAg--.64280S4;
	Thu, 24 Sep 2026 19:05:54 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Jan Kara <jack@suse.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	exfat@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	ntfs@lists.linux.dev
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 2/3] ntfs: drain in-flight DIO before buffered write fallback
Date: Thu, 24 Sep 2026 19:05:43 +0800
Message-Id: <20260924110544.601390-3-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924110544.601390-1-yaojiale02@163.com>
References: <20260924110544.601390-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3N3wNBLVqE0AmAg--.64280S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF4kGFy5AFykKF47tr1rXrb_yoW8Zw1Upr
	ZIkFy5Gr9rtr4xXwn7CF4rW3WFkrZ8X3y3ZrWkWw1kCrW8Gw4vga18tF1jvryrJFZrJr42
	qa109rWkZryUZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zK9akLUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BINR2q1BBJZFwAA3v

An asynchronous direct write can remain in flight after the inode lock is
released.  If another direct write falls back to buffered I/O while the
first write is still pending, iomap_file_buffered_write() can dirty pages
before the first write completes its post-I/O page cache invalidation.
The invalidation then finds dirty pages, reports a page cache invalidation
failure, and records -EIO in the mapping error sequence.  A later fsync()
therefore returns -EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed the same race in
ext4.  NTFS has an equivalent fallback after iomap_dio_rw() returns
-ENOTBLK or a short write, but does not drain other in-flight DIO before
dirtying the page cache.

Wait for in-flight DIO before calling iomap_file_buffered_write() in the
fallback path.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning and made a subsequent fsync() return
-EIO:

  Page cache invalidation failure on direct I/O.  Possible data corruption
  due to collision with buffered I/O!

Fixes: 9c87959601e8 ("ntfs: update file operations")
Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.alibaba.com
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 fs/ntfs/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 007d1614b9ac..2fc2ffde3846 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -527,6 +527,13 @@ static ssize_t ntfs_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 		offset = iocb->ki_pos;
 		iocb->ki_flags &= ~IOCB_DIRECT;
+
+		/*
+		 * Prevent concurrent direct I/O and buffered I/O to the same file
+		 * range. Wait for in-flight DIO to finish before dirtying pages.
+		 */
+		inode_dio_wait(file_inode(iocb->ki_filp));
+
 		written = iomap_file_buffered_write(iocb, from,
 				&ntfs_write_iomap_ops, &ntfs_iomap_folio_ops,
 				NULL);
-- 
2.34.1

