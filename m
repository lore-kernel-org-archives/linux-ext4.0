Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4074738B12B;
	Fri, 24 Apr 2026 10:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777027713; cv=none; b=MRYfyUXElzqA+N2BhhL3TfHjiMUSFwre8PW1Zk0eAaJljhQatS2bJ1lvodpHDB4EFCBT0v/RN+l28FvKO4rmMLzjDdHf01n+EzGfDwa39l+LhEEYv2P30TyX6jLlo8Me/G1sab6W04WBHEq4AzGwu40nmnWbUT0r3jA9GPPmnGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777027713; c=relaxed/simple;
	bh=6CbsLRcrbTHKaxJhYojnw+b1Dwgvvj+npSygMMFvt8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xuj9q3yP6cb1W7KSihBzTC+b3YrOkAfkVrnri03O6dqTLAC189sczUtflc4tXRAri4Tq5kt/q3RCZIbClwSNpPCJROun0Ce/MVAYWvr8eazUgWF6pr7ARsYbhpCppKeY065g9uaAQnrQAt+8cZ243cDoKzc8Y6OTxp4/8HOwxmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g28mW30tnzYQvHD;
	Fri, 24 Apr 2026 18:47:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 9AA9840573;
	Fri, 24 Apr 2026 18:48:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgC3ZL5uSutpM1IvBg--.55362S4;
	Fri, 24 Apr 2026 18:48:22 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH] ext4: fix LOGFLUSH shutdown ordering to allow ordered-mode data writeback
Date: Fri, 24 Apr 2026 18:42:01 +0800
Message-ID: <20260424104201.1930823-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgC3ZL5uSutpM1IvBg--.55362S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFWDZF13urWrXr1xAF1UJrb_yoW8Kw4xpr
	W8Ca42qr409r1xuFs7Wa17JFyjgw10y3yUJry3C3Z0g3y3Zr1xGrWIgFyaqF1UK392gayF
	qF4I934UKas0kFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUpwZcUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In EXT4_GOING_FLAGS_LOGFLUSH mode, the EXT4_FLAGS_SHUTDOWN flag was set
before calling ext4_force_commit().  This caused ordered-mode data
writeback (triggered by journal commit) to fail with -EIO, since
ext4_do_writepages() checks for the shutdown flag.  The journal would
then be aborted prematurely before the commit could succeed.

Fix this by calling ext4_force_commit() first, then setting the
shutdown flag, so that pending data can be written back correctly.

Note that moving ext4_force_commit() before setting the shutdown flag
creates a small window in which new writes may occur and generate new
journal transactions.  When the journal is subsequently aborted, the
new transactions will not be able to write to disk.  This is intentional
because LOGFLUSH's semantics are to flush pre-existing journal entries
before shutdown, not to guarantee atomicity for writes that race with
the ioctl.

Fixes: 783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
This fix addresses my new generic/970 test, which fails during the file
size verification after shutdown and remount.

 https://lore.kernel.org/fstests/20260424092228.1396658-1-yi.zhang@huaweicloud.com/

 fs/ext4/ioctl.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 1d0c3d4bdf47..110e3fb194ec 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -830,11 +830,17 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
 		bdev_thaw(sb->s_bdev);
 		break;
 	case EXT4_GOING_FLAGS_LOGFLUSH:
+		/*
+		 * Call ext4_force_commit() before setting EXT4_FLAGS_SHUTDOWN.
+		 * This is because in data=ordered mode, journal commit
+		 * triggers data writeback which fails if shutdown is already
+		 * set, causing the journal to be aborted prematurely before
+		 * the commit succeeds.
+		 */
+		(void) ext4_force_commit(sb);
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
-		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal)) {
-			(void) ext4_force_commit(sb);
+		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal))
 			jbd2_journal_abort(sbi->s_journal, -ESHUTDOWN);
-		}
 		break;
 	case EXT4_GOING_FLAGS_NOLOGFLUSH:
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
-- 
2.52.0

