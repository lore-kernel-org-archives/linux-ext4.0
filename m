Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98704383C6F;
	Mon, 11 May 2026 07:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484519; cv=none; b=jMkLZ2ozbUWYrdsluivzIqIU8Sz9xWqGN30FvNG7sPrrpEFi2uMsEiiUE9z+MNRCkN04bZoEq1G2OisvGmnE7oynbsAjMdd6cW3HfMXWh5HLmmCw6ErG1+ZhPkqkZOYIxEie16Zyo/gRlscnmTvk31Y+6jQ8F8a9lvAjLxGXQwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484519; c=relaxed/simple;
	bh=K5R16M3oqschNp9djqgRbio2WZjcMBSGBDr/MmrzL8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gm0WP2QbIdldsGpfGZ3fnshkQbo20myziAiP/QOiif6Ik1VZ/RI997/NzUr6jnfHNMPDTPUua7ZYN4TMk27d4EFgRab8JjXZcdpP6AOnM0Sq1D4YS4pOW2NKH1oqpVA8HpYchoC8yC9DaUCyuwRJRJfpMMJG9ZAyHwhXCT0My0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gDWXV2T9czYQv2f;
	Mon, 11 May 2026 15:27:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 061624056D;
	Mon, 11 May 2026 15:28:23 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S11;
	Mon, 11 May 2026 15:28:22 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	djwong@kernel.org,
	hch@infradead.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 07/23] ext4: do not use data=ordered mode for inodes using buffered iomap path
Date: Mon, 11 May 2026 15:23:27 +0800
Message-ID: <20260511072344.191271-8-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S11
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWkuw4DCF4fJw1rGrWUtwb_yoW5ArW5pF
	W3K3s8J3s5uasFkF4kur4Iqr1Fv3y5Jr4UXFy3KrsxuayDJa1IyFy3tF92ya45trs3G3WI
	qF48ArW8WFs0yrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The data=ordered mode introduces two fundamental conflicts with the
iomap buffered write path, leading to potential deadlocks.

1) Lock ordering conflict
   In the iomap writeback path, each folio is processed sequentially:
   the folio lock is acquired first, followed by starting a transaction
   to create block mappings. In data=ordered mode, writeback triggered
   by the journal commit process may attempt to acquire a folio lock
   that is already held by iomap. Meanwhile, iomap, under that same
   folio lock, may start a new transaction and wait for the currently
   committing transaction to finish, resulting in a deadlock.

2) Partial folio submission not supported
   When block size is smaller than folio size, a folio may contain both
   mapped and unmapped blocks. In data=ordered mode, if the journal
   waits for such a folio to be written back while the regular writeback
   process has already started committing it (with the writeback flag
   set), mapping the remaining unmapped blocks can deadlock. This is
   because the writeback flag is cleared only after the entire folio is
   processed and committed.

To support data=ordered mode, the iomap core would need two invasive
changes:
 - Acquire the transaction handle before locking any folio for
   writeback.
 - Support partial folio submission.

Both changes are complicated and risk performance regressions.
Therefore, we must avoid using data=ordered mode when converting to the
iomap path.

Currently, data=ordered mode is used in three scenarios:
 - Append write
 - Post-EOF partial block truncate-up followed by append write
 - Online defragmentation

We can address the first two without data=ordered mode:
 - For append write: always allocate unwritten blocks (i.e. always
   enable dioread_nolock), preserving the behavior of current
   extent-type inodes.
 - For post-EOF truncate-up + append write: postpone updating i_disksize
   until after the zeroed partial block has been written back.

Online defragmentation does not yet support iomap; this can be resolved
separately in the future.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4_jbd2.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 63d17c5201b5..26999f173870 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -383,7 +383,12 @@ static inline int ext4_should_journal_data(struct inode *inode)
 
 static inline int ext4_should_order_data(struct inode *inode)
 {
-	return ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE;
+	/*
+	 * inodes using the iomap buffered I/O path do not use the
+	 * data=ordered mode.
+	 */
+	return !ext4_inode_buffered_iomap(inode) &&
+		(ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE);
 }
 
 static inline int ext4_should_writeback_data(struct inode *inode)
-- 
2.52.0

