Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F060B472079;
	Thu, 24 Sep 2026 11:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790247988; cv=none; b=t12GuwbWAWfNZ950E0knfvKMcKEFpKgwXqcwb/BpH9LqeOdUohsokUQddhq9REXNFRkn1FIIgEnR7pl+tWvqDxHlxdygBJ+9vDBkvLEWrDtSMeoyY9Z8KFjSeJAUu4u8IT8h/eQjxdgGPBW0NjH372zlflRfXCtfhvlFlFn3J0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790247988; c=relaxed/simple;
	bh=LyAsME2aAIOk2JZFx8uU+tBPkszTymuqPYtXMvbI6J0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U1SZKpcimizcuBVfvetLlTsL66rixq3alKlhqP2dPE1qdSrVVCRIKu0+bntces/0QA/XqRaRgviP8b4Bzy5Rd6ejVNZ0btg12OmJIE/YUWwPNyG0m/Iy+oiqh+CB6GvT+6HSxLezMS0EpRdlh3LW2FBYJmWtly4JL0jNTbBs9m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=fohSV3Ed; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="fohSV3Ed"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Rt
	VfmyuRagvTTukFY5aIEOHEwHMeiypogrE/cHmNAKI=; b=fohSV3EdEZNwAtXnCl
	EnX0mfwQfX48T62X8Ujy7YJTYimpGjN6CYAUla88WVCZT87bmJbGaOlY3KCpy1+f
	DLr1jsLOIEcYEsAdkD8zrH6q7tsO9rQHS019CZEeEAzynAY3hDP2/aQFNeZs08E8
	Py2SIFV9VIcio6iMH4PQDPZYQ=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3N3wNBLVqE0AmAg--.64280S2;
	Thu, 24 Sep 2026 19:05:50 +0800 (CST)
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
Subject: [PATCH 0/3] fs: drain in-flight DIO before buffered write fallback
Date: Thu, 24 Sep 2026 19:05:41 +0800
Message-Id: <20260924110544.601390-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3N3wNBLVqE0AmAg--.64280S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF1DtryfXF1fKry5tryDtrb_yoW8Gw1fpr
	WYgw45JrnFyrZ2yFn7uF4xGr1FkrZ5Z3y3urZ5W3ZFk348Gr4UWa1ktr1jvrW3Ca13Jw42
	vw4rur97WryvkaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piL0ePUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8A4MRmq1BA5YmwAA3i

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
Each patch fixes one filesystem and remains independently buildable.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning on all three filesystems and made a
subsequent fsync() return -EIO:

  Page cache invalidation failure on direct I/O.  Possible data corruption
  due to collision with buffered I/O!

Jiale Yao (3):
  ext2: drain in-flight DIO before buffered write fallback
  ntfs: drain in-flight DIO before buffered write fallback
  exfat: drain in-flight DIO before buffered write fallback

 fs/exfat/file.c | 6 ++++++
 fs/ext2/file.c  | 7 +++++++
 fs/ntfs/file.c  | 7 +++++++
 3 files changed, 20 insertions(+)

-- 
2.34.1

