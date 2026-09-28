Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40313783C5;
	Mon, 28 Sep 2026 08:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790585703; cv=none; b=jO+9TiCAr2VqxCBJtPA1QLPgyox6FccRysGcHfdhXiBbjaFxNr/WzIiv7jNSp64OqiTmfOky5DdxtCT3mrX3FOf3UYUuM1Mj2hRPCHVCUOWbtzsS4LsvQJmCADMH/yEBR5EbqYD61yS1hoAMmOwWpc9Jp8RSUpmO57WiC2ZG81o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790585703; c=relaxed/simple;
	bh=Gu8VLPRTCftgq6QZnrODe2DmnF3NE5o5dYzYXSoNsYY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Cbtdriq7N5AOIcky3WT6kRk/OkhqIwDSXu+hKUm2EvmgPMMEzMXGv9JTySsKhJvFalxOlbiuI55dseXRw6fgaZys9OWMEtxE1572RbzzhFUC6VZk060hGlXi2xibbWgwhA7o+YmgL+7nESIcGUQD76P6D/MgYnKrG0bGB7Aew/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=CjgxTm+6; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CjgxTm+6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=C0
	xN9+Mm1EwHMBNzwLSmbI7LvmBH8XFz7NRvmKmiqKM=; b=CjgxTm+6/BQZfxrJTm
	Kbf1UBoWMa3PZqyjCz02ppbP51TsYLj+30LYyfTeCZ7Jk5hupWkW+S7cEnuTksqW
	e1Q4y9h6ngec+wpG9dj72HyXl7a1x1CXtsZoiZiRQmOrzC3CgimojYp8iSZlejc5
	xz7gwmjHPPxmCXS/3vK0pROQo=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3t582K7pqm5HnBA--.52401S2;
	Mon, 28 Sep 2026 16:54:15 +0800 (CST)
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
Subject: [PATCH v3 0/3] fs: drain in-flight DIO before buffered write fallback
Date: Mon, 28 Sep 2026 16:54:09 +0800
Message-Id: <20260928085412.2221055-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3t582K7pqm5HnBA--.52401S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF1DtryfXFy7ZFykGF4rXwb_yoW8uF4Upr
	WYga15trnFyrZ7CrZ7ua17JF1S9ws3J3y3urWag34Uuwn5Gr4DXF48tr1jqr43Aa1fGw12
	vw40vas7uFyUC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piL0ePUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xgiXGq6KzgicAAA3Y

An asynchronous direct write can remain in flight after its submitting
thread releases the inode lock.  If a buffered write dirties page cache
in the meantime, the direct write can complete post-I/O invalidation after
the pages become dirty.  The invalidation then reports a page cache
invalidation failure and records -EIO in the mapping error sequence.  A
later fsync() returns -EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed this race in ext4.
The same ordering is missing from the buffered fallback paths in ext2,
NTFS, and exFAT, and from the regular buffered-write path in exFAT.

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

 fs/exfat/file.c | 12 ++++++++++--
 fs/ext2/file.c  |  7 +++++++
 fs/ntfs/file.c  | 13 +++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.34.1

