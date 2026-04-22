Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EB530F938;
	Wed, 22 Apr 2026 02:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824221; cv=none; b=Wd/OVerq5FH2tsCuEUJNROXBQZMSf/mVhyGoyAXskG74vrLjGM+s2DaLoRZQ6ZOzqhr2Hc93umN1xKojHv3oT06TMqrOLcAnWBrrfpNo+x2E6RfRCXKDSCD6oBkFF2UEdNRYVETPv42/C+o+5MLbMiv4eJ6HbeOVibQT/o4CuAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824221; c=relaxed/simple;
	bh=J6TPc/ZuvZyAI7NvDmtzSyRLjPtrL2PL7n1prHF0gKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zp+4RO4f3dX6gN4Jj0Wzj/khdZGKLxtruDQzClT3CSs8tTfZ6S2GLVhojU+s6jKAQY17wrDzsgy4IeQV2mxdquSbCWKmwnzL2gmjYflaSPq4JceQzhELL79XRRYusdJJWmToAfI20OU17H4/iFmiUHiKkn0+dWcNrpZ+/7gyg1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g0jX41WdBzKHMS4;
	Wed, 22 Apr 2026 10:16:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 3D57640605;
	Wed, 22 Apr 2026 10:16:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S11;
	Wed, 22 Apr 2026 10:16:55 +0800 (CST)
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
Subject: [PATCH v3 07/22] ext4: do not use data=ordered mode for inodes using buffered iomap path
Date: Wed, 22 Apr 2026 10:10:27 +0800
Message-ID: <20260422021042.4157510-8-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S11
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1fJFW8tw43CFWrury7GFg_yoW5CrWfpF
	W5K345JrWvva47Cr4xuF4Iqr1ay3yrJr47JFy7GFZrua98J3WIkFy8tF1Yya4UKrWfG3W2
	qr4UGrWxWFs0yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Do not use data=ordered mode for inodes using the buffered iomap path.
There are two reasons:

1. The lock ordering of the folio lock and starting transactions
   conflicts with the data=ordered mode. In the writeback path of the
   iomap, it processes each folio one by one. It first holds the folio
   lock and then starts a transaction to create the block mapping. In
   the data=ordered mode, if we perform writeback through the journal
   commit process, it may try to acquire the folio lock of a folio
   already locked by iomap, and the iomap could start a new transaction
   under this folio lock, which may also wait for the current committing
   transaction to finish, finally triggering a deadlock.
2. The iomap writeback path doesn't support partial folio submission. In
   the data=ordered mode, when the journal process is waiting for a
   folio to be written back, and the folio may also contain unmapped
   blocks with a block size smaller than the folio size, if the regular
   writeback process has already started committing this folio (and set
   the writeback flag), then a deadlock may occur while mapping the
   remaining unmapped blocks. This is because the writeback flag is
   cleared only after the entire folio are processed and committed.

To support the data=ordered mode, we need to modify the iomap
infrastructure by grabbing the transaction handle before we lock any
folio for writeback. In addition, we need to add support for submitting
partial folios, which is complicated and tricky, and may also cause
performance regressions. Therefore, we need to get rid of the
data=ordered mode when doing the conversion.

Currently, there are three scenarios where the data=ordered mode is used:

 - Append write
 - Post-EOF partial block truncate up and append write
 - Online defragmentation

For append write, we can get rid of it by always allocating unwritten
blocks, retains the behavior of the current extents-type inode. For
post-E0F partial block truncate up and append write, we can get rid of
it by postponing updating i_disksize after the zeroed partial block is
written back. For the case of online defragmentation, it has not yet
been supported, we can find other solutions later.

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

