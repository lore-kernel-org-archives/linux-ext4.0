Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CFE22D781;
	Sun, 24 May 2026 01:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779587738; cv=none; b=mErVGCmccf9KgpRmGu+cJyUz+RG4bnmhfN7K6z54wt5buDhHdW/wiu3PGNJV38jKbouanERHWtEJeW0N44FJv8UkEIfeIIVMVC3fRaEtLe+FQmLwOeiTFGFDq3BI81gi1UOLB57QwchjQ+j7byaovLHkbGSZ574l+SMYxW4tjSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779587738; c=relaxed/simple;
	bh=GiIFR/AoQHpQu8uv2K1cnAgsE0/ens5HIg9WncpyMMs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rvwXeBCI9hBcawLzqbukC7TwEdrIgE4E4YA2/Oktgh5qw+J3wNIl4RS8KQEdJM9hehT6FuaGFciDeHpShexiuhia+NGKI2NGmAXSvlr1d8CP74KMn38X6hsJoNyIgvwjhAyeQkksumfsWSheONFCba1eI15WtweG4hfiE3NcHgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EQSn72Sa; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EQSn72Sa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=j9
	CW7PSlLFxxKiDaoeOb2ybE8ILF5R4HCSaQkjhqvJI=; b=EQSn72SaFOhj2jbXIk
	M88q6KffBXzwb3GsiztUArIYX++H4DCnpXwl+nI1MCwIzKsQsc8+mC58viHlgJYy
	cDFMTq7iumDEvw5LF3O/LXHEhhtcHqywSwucBjHcbFBQ0yRP2BU7rb+TK/gqoQpi
	ly9aUEsfCL4JaYwdkhi4DFhoE=
Received: from liubaolin-ThinkPad-E15-Gen-2 (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAn6uNUWhJqz5eTEw--.270S2;
	Sun, 24 May 2026 09:54:31 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: corbet@lwn.net,
	skhan@linuxfoundation.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baolin Liu <liubaolin@kylinos.cn>
Subject: [PATCH v6 v6 0/3] ext4: improve mballoc statistics reporting and control
Date: Sun, 24 May 2026 09:54:18 +0800
Message-ID: <20260524015421.2529617-1-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAn6uNUWhJqz5eTEw--.270S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4UXF4rCryDGFW7WF48WFg_yoWDCFg_Z3
	4kKayrA34fJFyUCay8tws5KFWYvFWxKF1UGFn3Xr4fZFyDtFWDXa4DWrWUZr1xWF43Cr45
	urnrXFyxuFnFyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU80oGJUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6hfKlWoSWlcM7wAA30

From: Baolin Liu <liubaolin@kylinos.cn>

This series improves mballoc statistics reporting and control by adding
blocks_allocated to /proc/fs/ext4/<dev>/mb_stats, using
READ_ONCE()/WRITE_ONCE() for concurrent accesses to s_mb_stats, and
allowing mballoc stats to be controlled through
/proc/fs/ext4/<dev>/mb_stats.

Changes in v6:
 - Serialize proc and sysfs updates to s_mb_stats with a mutex so that
   clearing mb_stats through the proc control path cannot race with
   concurrent administrative writes.

Baolin Liu (3):
  ext4: add blocks_allocated to mb_stats output
  ext4: use READ_ONCE/WRITE_ONCE for s_mb_stats
  ext4: allow controlling mballoc stats through proc mb_stats

 Documentation/ABI/testing/sysfs-fs-ext4 |  3 +-
 Documentation/admin-guide/ext4.rst      |  9 ++-
 Documentation/filesystems/proc.rst      | 13 +---
 fs/ext4/ext4.h                          |  2 +
 fs/ext4/mballoc.c                       | 58 ++++++++++++++----
 fs/ext4/sysfs.c                         | 80 ++++++++++++++++++++++++-
 6 files changed, 135 insertions(+), 30 deletions(-)

-- 
2.51.0

