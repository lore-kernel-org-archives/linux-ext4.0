Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF664A64FC;
	Thu,  3 Sep 2026 12:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439382; cv=none; b=vAhK5Nyq2gxsX0hIrwPdiPuSJy3iVvNcKO1koysQMe8N5q5u0DwBApnRxhiMeygMxt9eeeGvQEsBPJ+AfiK31iDUe0Z4mz6GbVQt1ExXOOpywUNOIkuTMvThH7PGrNPR3KvVWmUbOhghnWEae7cv52RVMxJDFjvbbFOqtQXgfYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439382; c=relaxed/simple;
	bh=RoIsJBVzNW6ss2/ftgPAkJsPjDrxZw2yPuNWRCfwMvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7CgrH6Krknq0NuHKCPe8zHDM6DNvLCItvXG1A3QHkoIFyzVbj0m7zzAKMVyYG3FWrFyvo14zEPYmBrq3t47zIz5J21FMMJ7zTpU4PsdQT9l/KkaePaUQbfgBxQq5Wb4btJ45ixLJFP5QXjDi1QEwfPJpU1DL7T/SXAsRkgwDG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbK3z6c9hzYQv2r;
	Thu,  3 Sep 2026 20:42:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C06D040B54;
	Thu,  3 Sep 2026 20:42:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3HglDa5lqAJVrAg--.30843S7;
	Thu, 03 Sep 2026 20:42:50 +0800 (CST)
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
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v6 03/31] ext4: skip ordered I/O wait when zeroing beyond i_disksize block
Date: Thu,  3 Sep 2026 20:35:15 +0800
Message-ID: <20260903123543.2302999-4-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3HglDa5lqAJVrAg--.30843S7
X-Coremail-Antispam: 1UD129KBjvJXoW7CFy5Jr4fCw1fWw47uw1xXwb_yoW8uw1rp3
	43GF18Zr4kJ3sI9wn2qF1Iga4Yka95Gw4fGFW7Gr4q9FW5uw1v9F1xt34agFy2yrs5G3W0
	qFW5GrZ7u34DA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7sRRwID5UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_block_zero_eof() zeros the tail of a partial block beyond EOF.
After zeroing, it waits for ordered I/O completion to prevent stale
data exposure from concurrent post-EOF mmap writes during folio
writeback.

However, if the zeroed range lies entirely beyond the block containing
i_disksize, no stale data can be exposed because the zeroed region is
beyond existing on-disk data. The zeroed pages will be written out
before i_disksize is later extended past i_size, so the ordered I/O
wait is unnecessary. Add a condition to skip it.

Suggested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8654006a57ef..4fc0d331c49d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4241,9 +4241,22 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	 * truncating up or performing an append write, because there might be
 	 * exposing stale on-disk data which may caused by concurrent post-EOF
 	 * mmap write during folio writeback.
+	 *
+	 * Ordered I/O is required only when zeroing the tail of a block that
+	 * overlaps with i_disksize. If the zeroed range falls outside that
+	 * block, the zeroed data lies beyond the existing on-disk data. It
+	 * will be written out before i_disksize is later extended past
+	 * i_size, so no stale data can be exposed.
+	 *
+	 * Note that it's safe to read i_disksize without holding i_data_sem
+	 * here. Since we already hold i_rwsem, the only possible race is with
+	 * concurrent writeback that updates i_disksize. And if such a race
+	 * occurs, it means the previous unaligned EOF block has already been
+	 * zeroed (if needed) and persisted to disk.
 	 */
 	if (ext4_should_order_data(inode) &&
-	    did_zero && zero_written && !IS_DAX(inode)) {
+	    did_zero && zero_written && !IS_DAX(inode) &&
+	    from < round_up(READ_ONCE(EXT4_I(inode)->i_disksize), blocksize)) {
 		handle_t *handle;
 
 		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
-- 
2.52.0

