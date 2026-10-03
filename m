Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3BF3E8331;
	Sat,  3 Oct 2026 09:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791019875; cv=none; b=dGxJalkeVpfyo/bNq4Z2aa1rYxDKxtAKIHduMhCrZduhaUEjSfo8j+wUgTdbxrJMgDqDNtPS2cAtpXr8IGcpchlzb5ZB2ZOWgldRlAoLhuh3+KKIgXORrQv1SDk8nm5hRtP/cH0LzvcspSMJ6KNe05zd0GOQrdibBMhrqN9G48E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791019875; c=relaxed/simple;
	bh=rxtFUFSHxs8TblB4lb0hLms4E4gJN7vG6V6DWTK1Rvw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F/beuXzdAdVMNpTzC4hJcmcvKjNt+IEhodQ3C8pP4sKwhLZLd+Kt5Oud1YCBugai7c+TfX3BUa8m7fIn4KL7THM3DyVzqIppoGstQbHq9pfPiI9jVU43pjlIbSqpPTR9NZPkoDmHszGtTxyQNLT9Cd6ihgHKcKokG29YmTOT7I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=R37Oe0XN; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="R37Oe0XN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=M0
	fMs6qgG2xKZRFestL3XQh7m7yKQHNCKfKQ/oaF3mM=; b=R37Oe0XNiDZHpUfCuY
	+f0+hSD3a/uxhjVr8GPfX1B2GldDZQEYcq5BzqM2nvRTTVVvXSH8oR+40SGFw2vz
	MiAtFZwrcjvGQL8xH+0MgbuYQoeQohvJS3T/k4HGT1XBnJq9V5iPvebLVwrG6OCj
	JUrxxdFCsUxZRHzKbybJD5aZ8=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgBnTqs9y8BqZLmrCg--.23213S2;
	Sat, 03 Oct 2026 17:30:37 +0800 (CST)
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
Subject: [PATCH v4 0/3] fs: drain in-flight DIO before buffered write fallback
Date: Sat,  3 Oct 2026 17:30:32 +0800
Message-Id: <20261003093035.532916-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgBnTqs9y8BqZLmrCg--.23213S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF1DtryfXFy7ZFykGF4rXwb_yoW8tF4kpr
	WYga15trnFyrZ7ArZ7uF43JF1Sgws3X3y3urZIg34Uuwn8Gr4qqF48tr1jgr43Aa1fGw42
	vw4vvas7uFyDC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piK9a9UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzR7MB2rAyz6nowAA3D

An asynchronous direct write can remain in flight after its submitting
thread releases the inode lock.  If a buffered write dirties page cache
in the meantime, the direct write can complete post-I/O invalidation after
the pages become dirty.  The invalidation then reports a page cache
invalidation failure and records -EIO in the mapping error sequence.  A
later fsync() returns -EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed this race in ext4.
The same ordering is missing from the buffered fallback paths in ext2,
NTFS, and exFAT, and from the regular buffered-write and valid-size
extension paths in exFAT.

This series adds inode_dio_wait() before these paths dirty page cache.
Each patch fixes one filesystem and remains independently buildable.  The
NTFS patch also avoids entering the blocking fallback for IOCB_NOWAIT
requests: it returns -EAGAIN if DIO made no progress and preserves a
positive result after a partial direct write.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning on all three filesystems and made a
subsequent fsync() return -EIO:

  Page cache invalidation failure on direct I/O.  Possible data corruption
  due to collision with buffered I/O!

Changes in v4:
- Add inode_dio_wait() to exfat_extend_valid_size(), as requested by
  Chi Zhiling.

Changes in v3:
- Add inode_dio_wait() to both the regular and fallback buffered-write
  paths in exFAT, and move the explanatory comment to
  exfat_file_write_iter(), as requested by Chi Zhiling.
- Add Baolin Liu's Reviewed-by tag to the NTFS patch.

Changes in v2:
- Handle IOCB_NOWAIT before the potentially blocking NTFS fallback,
  returning -EAGAIN before any bytes are written and preserving a positive
  short-write result otherwise, as requested in review.

Jiale Yao (3):
  ext2: drain in-flight DIO before buffered write fallback
  ntfs: drain in-flight DIO before buffered write fallback
  exfat: drain in-flight DIO before buffered writes

 fs/exfat/file.c | 14 ++++++++++++--
 fs/ext2/file.c  |  7 +++++++
 fs/ntfs/file.c  | 13 +++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

-- 
2.34.1

