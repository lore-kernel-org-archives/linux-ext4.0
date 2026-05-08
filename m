Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201042EA498;
	Fri,  8 May 2026 09:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778232904; cv=none; b=CQ25NGGFH67elP/WLHvvhybiMH5As3D5ouOZYVp/n5EqLldLp3d6odTG/dZwLB6njAhvfnAkA29BxkU/T9J7FZmREKYEQ5nCBJAPNl14dd5nSVAvsptkuuADpaw8wRVdaaAoXvb4nvRQ+wA8p6lmHpxl+eOcF8DXIbDJy/WMN7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778232904; c=relaxed/simple;
	bh=fXLomLoZmY3O+huwgBxeO+z/kIn+pPzOO/e5MLLLEpA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z/sl/LlkfJAxC7JjiajqaIh8F/nEL8HkJGL0fc7exAvzkWX5s0kV8vy4Is6srOhqD3F9HTvpRjNAysQb1vOeUrCRlHPhQ36HxEdzK7+fgOnXESKtOGvUN8HBVcbd+ptkbY8mdNwYhtngDfV5/UC454rTlzH1WdgkvOguQEPSY3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=M4+Exeuj; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="M4+Exeuj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7j
	MC6DUZiOS7Wban9FJyNbMFUdCN5d4YMh8KUY//5iA=; b=M4+ExeujLewXoQBu7a
	V56SwjnIvs8Gnp+V7PrOv2jzPnMSACZl4MybAVifqYnkNU3C/4VJSLD0MbiXbhVa
	cpcB8OIFFxLSl6w7QfusFuQYyllbtPgTyNDbNi/YcRtXGIbBG0npv7T4dIVbkH8G
	3wwYSzj3Nm+ehLMzuYxJlbRq8=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDXeCEprv1pUW9wDg--.60442S2;
	Fri, 08 May 2026 17:34:35 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com
Cc: ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangguanyu@vivo.com,
	adilger@dilger.ca,
	liubaolin12138@163.com
Subject: [PATCH v4 v4 0/3] ext4: improve mballoc statistics reporting and control
Date: Fri,  8 May 2026 17:34:25 +0800
Message-ID: <20260508093428.5814-1-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDXeCEprv1pUW9wDg--.60442S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF1UWF4DKw1rGr43Gw1xZrb_yoW8Xr17pF
	WSvw1SqFn5Zw1fJwnxGF42q343A3yfCw47Gr42g34xuF98tr1SyF4rtrWrAF98JrW0vF4U
	Xr4jkr95CFW2yrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pimhF7UUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6guPWmn9riuJlAAA34

This series improves ext4 mballoc statistics reporting and control.
Compared with v3, this version adds a new patch to convert s_mb_stats
to atomic_t and use atomic operations for its accesses, so as to avoid
potential concurrent accesses to this variable.

Patch 3 is updated according to comments from Ted and BaoKun. Writing 0
to /proc/fs/ext4/<dev>/mb_stats disables statistics collection, writing
1 enables it, and writing -1 clears the current statistics and enables
collection. The related documentation is updated accordingly, and the
sysfs mb_stats entry is documented as deprecated in favor of the proc
mb_stats entry.

Changes since v3:
  - add a new patch to convert s_mb_stats to atomic_t and use atomic
    operations for its accesses
  - update /proc/fs/ext4/<dev>/mb_stats write semantics based on comments
    from Ted and BaoKun
  - update related documentation and document sysfs mb_stats as deprecated

Baolin Liu (3):
  ext4: add blocks_allocated to mb_stats output
  ext4: use atomic operations for s_mb_stats accesses
  ext4: allow controlling mballoc stats through proc mb_stats

 Documentation/ABI/testing/sysfs-fs-ext4 |  3 +-
 Documentation/admin-guide/ext4.rst      |  9 +++-
 Documentation/filesystems/proc.rst      | 13 +-----
 fs/ext4/ext4.h                          |  3 +-
 fs/ext4/mballoc.c                       | 57 +++++++++++++++++++------
 fs/ext4/sysfs.c                         | 55 ++++++++++++++++++++++--
 6 files changed, 109 insertions(+), 31 deletions(-)

-- 
2.51.0

