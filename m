Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7778F2C3259;
	Sun, 19 Apr 2026 06:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776580378; cv=none; b=TPQMxG9eXZ7v0IejD0gp1L90vGQ19JpBtAtuiNtLddUKRvCPLCFiAnKQUmiaYc7VtbWExKQoy/pkmEWCaaswogBb7nXumT0nJbRqRib1Fe0xovbPXsHTlSoDmdBKn+IgxS0jzHyyc2ZBWsszrznAN9KwuaIyffEWAMDah9sgZdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776580378; c=relaxed/simple;
	bh=hJghoW16mn/evag+0X1mnpiWLqmR+sfj9HtbvXpetdU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HhMBY/en3zCEx7TP0NLIzavUQiYO3gATIf2TqjcXRYd5G8rxrWSuYoCIks8nO/BVcP9qsXSfqFch1G8CAxqPo5TaBFZlmTPgzpmHc98C2+2xkaqiLldhEdTUkQpz3sB5U9FCZGvdrPzvcHi24XHbJoc0yTZlLphajeK3mi1iyBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=SlvHPNB1; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="SlvHPNB1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=PI
	6Ymg5aJxzRVLwyUqr0UWzaz/U5NFi9ESZL5EWMitQ=; b=SlvHPNB1Z6zzgMA/IV
	0dae9auoED7UuUG/GNvap8fA3QoigfIrJRepzP/v1/MiMKMqioMNSCIYjMk0DDlA
	zxQ7Rfwa+2TaqEK7R7N4Eu8YefmpxLS68HZu06sajCqS5y+wW+9aLJDW80UbVKSf
	UvbC4LXk7pX63td+7ByAgQwjk=
Received: from liubaolin-VMware-Virtual-Platform (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wC3MqvyduRpkPkNAg--.10457S2;
	Sun, 19 Apr 2026 14:32:20 +0800 (CST)
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
Date: Sun, 19 Apr 2026 14:31:49 +0800
Message-ID: <20260419063152.17938-1-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3MqvyduRpkPkNAg--.10457S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFWrXry3Xw15CrWDCry8Zrb_yoWfCrb_Wa
	4FgryrA34avF1DCFy8Gwn5tryY9FW7Jr1DGFn8Jr4fZFy5XrsrCayDGr13Zr1xWr4ayr15
	Cr1xWw1xCrn2vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRNv31JUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6RVuOWnkdvXl1QAA3V

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

