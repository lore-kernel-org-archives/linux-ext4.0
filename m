Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D85476CDC;
	Thu, 24 Sep 2026 11:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790247997; cv=none; b=T4kUdYtgkMJGpGalEFtnH6WeS5DJ8Q9KRKRM7UT2J+SqQbfUo3wQ7Y6Sk44Hsk8KXv5VpKx533bLw92S3Hr3P9hh+nEsyqXz32Q+YXxDqRkZW2RnhQ7woZm7o2SRpHqxeEIKOWOcZYq5zDLW8+l0cHXb2pu8tYwb8IwgyfmB7/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790247997; c=relaxed/simple;
	bh=VCOUBmSvA08OLSZZ0QUtRpBpXc4RIeX5lNww1zeNj+w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tTZTER6ITCHLoRhsn2RuW7dNqAEcbMT8+BdUfPPNhY4LRGPHH/8RUwLvzGY8KTUUC+Czqvxu0+AZPXWycizqi3PsZAWBoAvu13SQHNQSoioi7ufeYyxx5WKh1rFXFEJ9/8VyjzRTWXZr7riQdPvZfd0vac47SOs/xOvmxHdB7j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZWKFbg3W; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZWKFbg3W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Gb
	iQVEWtVb+Jbk8/U09Tj0Cxmmbe6xVeYJInM/aCluU=; b=ZWKFbg3WI+2uRabZyb
	xLrcHeF30uZ1HravdqT0LHmBtf7HH0omtCkWZq+EvQMIMYYUxgmjwiLZw3iFh48n
	I1ye0PvgRdVMyWGMKkHzHEgUlgVtH7oaZpXBNzW4eKMQIAVUvo4MbeAhI+xkjXz1
	ry+pEQZ3r8jd+GvNWukxD4XxA=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3N3wNBLVqE0AmAg--.64280S5;
	Thu, 24 Sep 2026 19:05:56 +0800 (CST)
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
Subject: [PATCH 3/3] exfat: drain in-flight DIO before buffered write fallback
Date: Thu, 24 Sep 2026 19:05:44 +0800
Message-Id: <20260924110544.601390-4-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3N3wNBLVqE0AmAg--.64280S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF4kGFy5AFykKF47tr1rXrb_yoW8ZF43pr
	Z0ga45JryDt397XwnruF48W3WFk395A3y3ZrWvv3WDCrWUWr4vga1ktr1YvF43JanrGr4j
	qa109rykAr1DCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRorW7UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BQOSGq1BBRZSAAA38

An asynchronous direct write can remain in flight after the inode lock is
released.  If another direct write falls back to buffered I/O while the
first write is still pending, iomap_file_buffered_write() can dirty pages
before the first write completes its post-I/O page cache invalidation.
The invalidation then finds dirty pages, reports a page cache invalidation
failure, and records -EIO in the mapping error sequence.  A later fsync()
therefore returns -EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed the same race in
ext4.  ExFAT has an equivalent fallback after iomap_dio_rw() returns
-ENOTBLK or a short write, but does not drain other in-flight DIO before
dirtying the page cache.

Wait for in-flight DIO before calling iomap_file_buffered_write() in the
fallback path.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning and made a subsequent fsync() return
-EIO:

  Page cache invalidation failure on direct I/O.  Possible data corruption
  due to collision with buffered I/O!

Fixes: 867b9c96dc83 ("exfat: add iomap direct I/O support")
Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.alibaba.com
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 fs/exfat/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index a2a9ee1a2004..cf5ccbd54823 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -807,6 +807,12 @@ static ssize_t exfat_fallback_buffered_write(struct kiocb *iocb,
 
 	iocb->ki_flags &= ~IOCB_DIRECT;
 
+	/*
+	 * Prevent concurrent direct I/O and buffered I/O to the same file
+	 * range. Wait for in-flight DIO to finish before dirtying pages.
+	 */
+	inode_dio_wait(file_inode(iocb->ki_filp));
+
 	written = iomap_file_buffered_write(iocb, from, &exfat_write_iomap_ops,
 			NULL, NULL);
 	if (written < 0)
-- 
2.34.1

