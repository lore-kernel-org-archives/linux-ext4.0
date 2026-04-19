Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F98281503;
	Sun, 19 Apr 2026 06:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776580530; cv=none; b=lZrAFqF8Oaq2hW3RIw6wlGxO2ci71o5aGbSmdzKWujQPX+liLpmhMrUzKo9v29+V54Op19QztOZB4472ZJPy2Eu/8HtosdF5JcTbCy/SgVXqm6Edq87FAsR76oz1lXjzsI8QZDwd4TWt5ltpbIcuZbne0ZykrN0ossrpe7Fb3hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776580530; c=relaxed/simple;
	bh=hJghoW16mn/evag+0X1mnpiWLqmR+sfj9HtbvXpetdU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IC2Uqp6Ol2/y10U+JXAKeV9kLQTTZC61JgA4ynWIW5wcg7yQp8MeROF2G8HqzaHEs76Q/FyRwolEEh2C9okyAt5Ee+Lc51CxhuuXmpwRIy1Kq+6snlYr+PQZZ3RyiGSnker6Ra0Iyrp/4eEOdtsJyoDX7CIu+j41dgad+CsU9R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=J5BdsFmp; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="J5BdsFmp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=PI
	6Ymg5aJxzRVLwyUqr0UWzaz/U5NFi9ESZL5EWMitQ=; b=J5BdsFmpJQany7Xjii
	dy0X/mWUwB0OQqy3ZK/loRBudBYzkBF4liQ406Eaxvfecg3Fo/oiVMp4oZlU+Kt/
	KaGZaN/SDoDGoHMBSE7Za/XLic/fyp1t1N4YpFxD7lnbUBVPm8No0qri37P7cJEg
	nV2yIXPFvx6FnhlojWTaCmHcg=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgBHBQKBd+Rp1PA9Ag--.97S2;
	Sun, 19 Apr 2026 14:34:48 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: wangguanyu@vivo.com,
	liubaolin12138@163.com,
	yi.zhang@huaweicloud.com,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 v2 0/2] add blocks_allocated to mb_stats and clear mb_stats
Date: Sun, 19 Apr 2026 14:34:34 +0800
Message-ID: <20260419063436.17999-1-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgBHBQKBd+Rp1PA9Ag--.97S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFWrXry3Xw15CrWDCry8Zrb_yoWfCrb_Wa
	4FgryrA34avF1DCFy8Gwn5tryY9FW7Jr1DGFn8Jr4fZFy5XrsrCayDGr13Zr1xWr4ayr15
	Cr1xWw1xCrn2vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRNtCzDUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6giTXmnkd4gNVgAA3G

This series improves ext4 mballoc statistics in two small ways.

The first patch adds blocks_allocated to /proc/fs/ext4/<dev>/mb_stats,
so that the proc output covers the same mballoc summary counters
printed at unmount time.

The second patch makes /proc/fs/ext4/<dev>/mb_stats writable
and allows writing 0 to clear the current runtime mballoc statistics.

Changes since v1: 
 - Split blocks_allocated reporting and statistics clearing into two patches
 - Drop the separate mb_stats_clear sysfs node
 - Make /proc/fs/ext4/<dev>/mb_stats writable instead

Baolin Liu (2):
  ext4: add blocks_allocated to mb_stats output
  ext4: allow clearing mballoc stats through mb_stats

 fs/ext4/ext4.h    |  1 +
 fs/ext4/mballoc.c | 31 +++++++++++++++++++++++++++++++
 fs/ext4/sysfs.c   | 40 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 70 insertions(+), 2 deletions(-)

-- 
2.51.0

