Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225AA21ABD7;
	Fri, 22 May 2026 04:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779422412; cv=none; b=JcDuqI6IBYaBI1sAg7OvlBQRlg63fOB5OP3yrgOlSJguMAUlEtKs1Os0gbyWvOHHuV+onoPTHZKLRETfeYLc89UqMO+9YX0NPij5nD7KyQ3sPQQCts/ESXAyTaNPsNxy5ARRoW1dd41Yed5QKrKSkKdb3d13F835v7nKXl5uNWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779422412; c=relaxed/simple;
	bh=tieXjTmzbh62WK13seIc88AJfzroIZhPrypKXFEXOcA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gcNjm+KP/tyue+as1aVVBJp5YwflzCzfHJXvaosjkQJZznfbPsRyq3JTtqeuHIuW6OO2lOwK16fKuIL8S9caYwWBmDdAl20TQMdfC4O4akMWW1imTIsVOGSJd+OtZoUPVif3R02OnSlsZr/FXWeFM4FqubF6emWOnzKhu/v4lHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BWg+Ln7q; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BWg+Ln7q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ll
	ZoxEz0/wllLaF4vVnyVJp8owncoVhQehmZp0aNs1E=; b=BWg+Ln7qe8wSJbtdB7
	BrS/E12GTuQ6rGTzcYS+QY0s3cvvCF9a/eeHVzI1fsw3sv9PbvjP0U9MUL07sEYD
	7k7FfHcO4XhoYUhdA4G8FrrMqO5Qr2gavmGVIWFiUm74OzuN1QNpyyGBYl82w2BP
	zNK3vIjif4LpeWHu813eZNEm0=
Received: from liubaolin-ThinkPad-E15-Gen-2 (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDX3wWO1A9qtnXKCg--.18860S2;
	Fri, 22 May 2026 11:59:11 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baolin Liu <liubaolin12138@163.com>
Subject: [PATCH v5 v5 0/3] ext4: improve mballoc statistics reporting and control
Date: Fri, 22 May 2026 11:59:02 +0800
Message-ID: <20260522035905.1145743-1-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX3wWO1A9qtnXKCg--.18860S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtry3Jr4DGw4rtF4ruFWxWFg_yoWDuwc_Z3
	4kKFW5J343JFW2kay8tr4rtFWY9FWxAr18GFnIqr4fZFyDJFWDZ34DWrWDAr17Ww4akr45
	Gr17XrW8uFnFqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRM8nYUUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6g+2gWoP1I8vLgAA3t

This series improves mballoc statistics reporting and control by adding
blocks_allocated to /proc/fs/ext4/<dev>/mb_stats, using
READ_ONCE()/WRITE_ONCE() for concurrent accesses to s_mb_stats, and 
allowing mballoc stats to be controlled through
/proc/fs/ext4/<dev>/mb_stats.

Changes in v5: 
 - Use READ_ONCE()/WRITE_ONCE() for s_mb_stats accesses instead of
   converting s_mb_stats to atomic_t, as suggested in review.
 - For proc mb_stats writes of -1, disable stats collection before
   clearing the counters, then re-enable it.

Baolin Liu (3):
  ext4: add blocks_allocated to mb_stats output
  ext4: use READ_ONCE/WRITE_ONCE for s_mb_stats
  ext4: allow controlling mballoc stats through proc mb_stats

 Documentation/ABI/testing/sysfs-fs-ext4 |  3 +-
 Documentation/admin-guide/ext4.rst      |  9 ++-
 Documentation/filesystems/proc.rst      | 13 +----
 fs/ext4/ext4.h                          |  1 +
 fs/ext4/mballoc.c                       | 57 ++++++++++++++-----
 fs/ext4/sysfs.c                         | 73 ++++++++++++++++++++++++-
 6 files changed, 126 insertions(+), 30 deletions(-)

-- 
2.51.0

