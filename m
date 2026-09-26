Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C13A351C22;
	Sat, 26 Sep 2026 07:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790407616; cv=none; b=Dqg9RugCa8owFJB2EcHrUUTfMIvDDE8Dc/TfNX52UFlyO/BW42H5OV55b1bS1Ec/up+Dg4C/6EYTMvY/jtZJ5YiM4kc8PFxOeDlLNH7a3aeJC3FUcs5nem6SuReCGjPJOr1tNYoTtepXlR9zwDxvZv25iXa1ua3rGS5xN+vEUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790407616; c=relaxed/simple;
	bh=2ZSNPAPQ5uFpNEKRdOTXowKTOrg10NYXVjhcH0Q8yps=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BnsuKs7a/NWTIUrccdbvztRNARIxqf3ejQrmbYq3WmvhW8u7uZ9ljKUSronX859C4X+toUHs50HYEWkJFyRherrzwyCu7nMVpAIRau7b/d0RdeAMoGMhK/772AQ+0bOqAuBj3jYHP+fZe0fDK/QH8AVW269v4JI0H1L02+F3vdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EIKtKwzf; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EIKtKwzf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=f5
	OESZYUSuEE3QJEQwFZEeCJAa7TO61zwpOGvTN/CgY=; b=EIKtKwzfLvhrF8zGGi
	hhaChGSOCy8bGpAYeEaIYlv9P0FxCRBBcyH/j9BW6/kxy0F8+Ggw/fKCG0/0wCdj
	ouqAFSoI+QH/lt2CMWqZeCsjvzY57GssmnxkcC82xY4Q5VVN6fIOMvfOiYDMyGxD
	kAnfPgPeECzwH+D7vvmcNWwkY=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3v62dc7dqbEDbAw--.41165S2;
	Sat, 26 Sep 2026 15:26:22 +0800 (CST)
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
Subject: [PATCH v2 0/3] fs: drain in-flight DIO before buffered write fallback
Date: Sat, 26 Sep 2026 15:26:09 +0800
Message-Id: <20260926072612.3022680-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3v62dc7dqbEDbAw--.41165S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF1DtryfXF1fKry5tryDtrb_yoW8CrWrpr
	WYga1rtrnIyFZ7Awn7uF4xGr1rCas5Z3y3ZrZ3Wa4j9w1rGr4DXF48tr1jqrW3Aa13Gw1j
	vw4Fvas7WryDCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piL0ePUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzR6Mxmq3c57+KwAA38

An asynchronous direct write can remain in flight after its submitting
thread releases the inode lock.  If another direct write falls back to
buffered I/O in the meantime, the buffered write can dirty page cache
before the first write completes post-I/O invalidation.  The invalidation
then finds dirty pages, emits a page cache invalidation failure warning,
and records -EIO in the mapping error sequence.  A later fsync() returns
-EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed this race in ext4.
The same ordering is missing from the buffered fallback paths in ext2,
NTFS, and exFAT.

This series adds inode_dio_wait() before each fallback dirties page cache.
Each patch fixes one filesystem and remains independently buildable.  The
NTFS patch also avoids entering the blocking fallback for IOCB_NOWAIT
requests: it returns -EAGAIN if DIO made no progress and preserves a
positive result after a partial direct write.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning on all three filesystems and made a
subsequent fsync() return -EIO:

  Page cache invalidation failure on direct I/O.  Possible data corruption
  due to collision with buffered I/O!

Changes in v2:
- Handle IOCB_NOWAIT before the potentially blocking NTFS fallback,
  returning -EAGAIN before any bytes are written and preserving a positive
  short-write result otherwise, as requested in review.

Jiale Yao (3):
  ext2: drain in-flight DIO before buffered write fallback
  ntfs: drain in-flight DIO before buffered write fallback
  exfat: drain in-flight DIO before buffered write fallback

 fs/exfat/file.c |  6 ++++++
 fs/ext2/file.c  |  7 +++++++
 fs/ntfs/file.c  | 13 +++++++++++++
 3 files changed, 26 insertions(+)

-- 
2.34.1

