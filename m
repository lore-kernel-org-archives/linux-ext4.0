Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7063224AFA;
	Tue, 13 Oct 2026 08:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879852; cv=none; b=tKlUBTdmn0slN38QbubLikImWAjqZKIy8pyk1ZmcJ3nIH/Varps42nVt2vziuQxcY2j1wPUpttIu02qsHf5H8Gxn2XMH3UTkzHN+O2ePVCsF60iwxRI1ZHskbJYEXIGBUzIP3Zwfa8vTmk6WKf3zsz5zUkJxbFF09WGHBKVzhRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879852; c=relaxed/simple;
	bh=FL3N2EWSEs19T6YpEpT1oJ7zpqoUzfVaDg+gEGjEonw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tvSOcS2YwaRLujhpBB+78CR5jW7jLAZM5+jEGrjv/D73HmsIw+vGJMKzpDT4I7vr0M0JETMq1GDCNkl8wxdpGU2AEZ36A7oK5k+VVkI31PimuQhmsq0As4BbCBBiFZ9eF4dKsp4XCQXALXLKOPAb4d2Qb1vwE1l8sarSRByMMzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=nB83hZ6D; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="nB83hZ6D"
Received: from localhost (gyproxy-mailtls0-entmail-virt215.gy.ntes [39.144.128.132])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50da51901;
	Tue, 13 Oct 2026 16:23:59 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>
Subject: [PATCH v2 0/2] ext4: check return value of blkdev_issue_flush() in unchecked call sites
Date: Tue, 13 Oct 2026 08:23:29 +0000
Message-Id: <20261013082331.2089623-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
References: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1345c7c9e03a2kunmd2eb76d44afbb0
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTENPVhhMQkgeGE1MQ0hCQ1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlIQlVKT09VSklDVUpISVlXWRYaDxIVHRRZQVlPS0hVSktJQk
	NNQlVKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=nB83hZ6DRO5Aul7ugQpUpU3SqdtcyL2fzjFW09SiLM4yh9xgYrcbBnU0P+YME6YdZKtGjCt4IV3CKVaFR2TsCyoHkdNDakWvv3Q8K7gqVd9EK1F2ZHPtcuj6kWRSDLYWe5I6KvAsnDmV/gYayQ2NGGT/hkMF4L30R236Dt8d5Fg=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=hypzV0gEJ0mH66H1FnKZni7nEAlyf3kjnUs+Ymg0TMo=;
	h=date:mime-version:subject:message-id:from;

This series adds return value checks to the blkdev_issue_flush() call
sites in ext4 which ignore the return value: lazy inode table
initialization and the file system device flush issued before
starting a fast commit.  Both call sites also issue the flush without
checking the barrier mount option; the series makes them honor the
option, consistent with the other cache flushes in ext4 and jbd2.

Changes since v1:
- Drop the fast commit replay patch.  JBD2 already calls
  sync_blockdev() on the file system device, checks the device write
  error, and issues a final barrier-gated cache flush after journal
  and fast commit replay, and it propagates all of these errors to
  the mount.  The error check added by that patch was therefore
  redundant; the pre-existing per-inode flush in the replay path is
  left as is for now.
- Gate the remaining two cache flushes on the barrier mount option
  (JBD2_BARRIER for the fast commit path).  Checking the return value
  makes a cache flush failure fatal for lazy inode table
  initialization and fast commits; without the gating, this would
  regress file systems mounted with nobarrier on devices with failing
  cache flushes.
- Update the patch descriptions to describe the gating.

The patches are otherwise unchanged since v1.

guolingxing (2):
  ext4: check return value of blkdev_issue_flush() when initializing
    inode tables
  ext4: check return value of blkdev_issue_flush() when starting a fast
    commit

 fs/ext4/fast_commit.c | 8 ++++++--
 fs/ext4/ialloc.c      | 7 +++++--
 fs/ext4/super.c       | 3 ++-
 3 files changed, 13 insertions(+), 5 deletions(-)

-- 
2.34.1

