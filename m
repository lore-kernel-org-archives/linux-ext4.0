Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4AE255F2D;
	Tue,  7 Jul 2026 02:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783390904; cv=none; b=K99fCkJKc3rooweI7TVklk0kyvNSbQpWFimRb3O0F0XnE4N12XbrOC1iRQfIDW9LYtPZH5b/ZceCkbNT+5Ti/9lStMiOdrXmjojEvdP4eJOKqPGhZRn3HWPaWGOk3ihRiAJ1+kfkUWJEH7Apu5lChmXfogb6Ai76WQ4K1YQSyRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783390904; c=relaxed/simple;
	bh=g2pWyn7ZLC46hOBc7CISdvKnsnqTspC+2Lf/zLEFqIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYUJVDPSu4CjoSF5E5dRRCM7HIybDYuXN0Z5PqfnjBOG7PLpsZQhLHECDFEaqrR9J9L0uZ24Oou2mPq2ADQEM7RXLhPIU/7f+9jqJsAqRzsRHmqfXvj+tEIhNMXSIFnbRnhsPA6WWHUtfA3dvlpXhCcMorBCy+x5Pp2sR2pF+bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gvQ2l0701zYQtjR;
	Tue,  7 Jul 2026 10:21:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 95A654056F;
	Tue,  7 Jul 2026 10:21:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3SHShYkxqYSBRAQ--.61087S6;
	Tue, 07 Jul 2026 10:21:37 +0800 (CST)
From: Zhang Yi <yi.zhang@huawei.com>
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
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v2 2/6] ext4: clarify return semantics of ext4_load_tail_bh()
Date: Tue,  7 Jul 2026 10:13:34 +0800
Message-ID: <20260707021338.1182268-3-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260707021338.1182268-1-yi.zhang@huawei.com>
References: <20260707021338.1182268-1-yi.zhang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3SHShYkxqYSBRAQ--.61087S6
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF43ZF1kuF1xAr4UuryrtFb_yoW8Zry7p3
	s8KasFgrZ5W3s29ayxJ3W7Xr15tasrGr4UWayfK3W2va45Wr4IvF10yFyS9F4jvrWfGrZ0
	qFWUKry7Ga1DCrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHFb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ew
	Av7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY
	6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0aVACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxc
	IEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l42xK
	82IY64kExVAvwVAq07x20xyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF6pBDUUUU
Sender: yi.zhang@huaweicloud.com
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

ext4_load_tail_bh() returns NULL for both holes and clean unwritten
buffers, but the conditions that lead to this are not obvious from the
code alone. Document this behavior to clarify the return value, so that
readers do not mistakenly assume that only holes result in a NULL
return.

Also update the inline comment following the ext4_get_block() call to
reflect this, and note that a lookup-only get_block (without
EXT4_GET_BLOCKS_CREATE) never sets BH_Mapped for clean unwritten
extents, which is why a clean unwritten bh falls through to the
"nothing to do" path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..45a7e6cdb2a1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
  * because it might have data in pagecache (eg, if called from ext4_zero_range,
  * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
  * racing writeback can come later and flush the stale pagecache to disk.
+ *
+ * Return the loaded bh if it actually needs zeroing - in written, dirty
+ * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
+ * a clean unwritten block).
  */
 static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 {
@@ -4065,7 +4069,12 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
 		ext4_get_block(inode, iblock, bh, 0);
-		/* unmapped? It's a hole - nothing to do */
+		/*
+		 * It's a hole or a clean unwritten block - nothing to do.
+		 * Note that a lookup-only get_block (without
+		 * EXT4_GET_BLOCKS_CREATE) never sets BH_Mapped for clean
+		 * unwritten extents.
+		 */
 		if (!buffer_mapped(bh)) {
 			BUFFER_TRACE(bh, "still unmapped");
 			goto unlock;
-- 
2.52.0

