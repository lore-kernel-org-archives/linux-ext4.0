Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535E23F5BE5;
	Tue, 14 Jul 2026 08:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784016554; cv=none; b=q06S2LkvKVXmOjGwo9JtR7JAneNJLeIlcSbloMnxlS9mtFhnLYtfyCH9j6FAemADnDa1/Esu/ELp7Jc1loZ8kNggQZFNNYSqRB9qmmkG5b2+3Arq4NSjcS0HbfYr31BDyazoXo5rE7Xr+eolDXzaoLA125KONHNU66KrmAm1Ys4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784016554; c=relaxed/simple;
	bh=cJzYjg+TKxGpl1RWyKyr/JXSx96psFme5BQTN6TaH+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOhO+FA/qhuyFXdw/iia6vVSjFRepyUfJn1IHQGks/sFpGzt1xzPdT5QuGlrxdpnG1UjZBVUqBIB1SSRvQ7AnERG5lfKkWs+C1F2MeG8Bj34VIYkYJOLOr+hXyNMMwvj1NkwU0Ee2JcfRvrPF4sGtYJlZdM4C2luZqYHz6CGRHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gzsQ93Zn8zYQtlS;
	Tue, 14 Jul 2026 16:08:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 7AF334056E;
	Tue, 14 Jul 2026 16:09:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgD3B3ST7lVqDS26BA--.56424S9;
	Tue, 14 Jul 2026 16:09:04 +0800 (CST)
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
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 5/9] ext4: clarify return semantics of ext4_load_tail_bh()
Date: Tue, 14 Jul 2026 16:00:40 +0800
Message-ID: <20260714080044.4038124-6-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
References: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3B3ST7lVqDS26BA--.56424S9
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF43ZF1kuF1xAr4Utr4rAFb_yoW8ZFyrpa
	sIgasFgrWrWas7uayIq3W7Xr1rtasrGr4UWayrK3W2va45Wr4SvF1qyFyS9F4jyrWfGrWY
	qFWUKry3Gan8A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl
	6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x
	IIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
	c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4U
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

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
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 77ec82fbda89..479ed73b5cda 100644
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
@@ -4067,7 +4071,12 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 		err = ext4_get_block(inode, iblock, bh, 0);
 		if (err < 0)
 			goto unlock;
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

