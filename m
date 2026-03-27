Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621411C3F31;
	Fri, 27 Mar 2026 10:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774607676; cv=none; b=jSgT6Ax5B4kHbeUVtJmpcWv+yD1fFtyF+k/Mhr2TKM/CafMdk6Y7kSxaWttG4C3K8FlKTdG03gghT7WFah4HdZMyI8mE0VWKy0FLqtnR9QD1aZlE+mPgFA8er2fmfsqM77Qe3PxBZ6v5v0u0/3rTg9vfdulxeo1GyOZM2jHLdHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774607676; c=relaxed/simple;
	bh=Pr9zvjwOfGLX5Mr9kIHJP1iN6iabU2fPfM7KwF0Hr9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1I2++Uspm2bsFN9k/sQczWmxjwhzdEeFHIMAmkVILCx3KgzWsxEhNjBB7aAa/y77BplAYSPTJ9x0WU7Hm4y5u2pq/FQDfN6Y9wvDS11v23ekapUCVt8b97dJoOJwpuIU7D6tic7C0qAkv9FAIYt0k2bZgbCAzt3orWaj0QzRsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fhxnq1FSkzKHMdw;
	Fri, 27 Mar 2026 18:33:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id D1B4740572;
	Fri, 27 Mar 2026 18:34:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgC3utouXcZp_T2cCQ--.28730S15;
	Fri, 27 Mar 2026 18:34:32 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 11/13] ext4: remove ctime/mtime update from ext4_alloc_file_blocks()
Date: Fri, 27 Mar 2026 18:29:37 +0800
Message-ID: <20260327102939.1095257-12-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
References: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgC3utouXcZp_T2cCQ--.28730S15
X-Coremail-Antispam: 1UD129KBjvdXoWrtFyUCrW7Cr4rCw48ZFWfAFb_yoWkGrc_Wa
	y7JrW0yw43X3WSgF4DCw13JwsYvr18Gr15WFWftFWfZw1UKrWkJ3WDAr15urW5Ww45CrZ8
	Ww4ktr4UtryIgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbvAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The ctime and mtime update is already handled by file_modified() in
ext4_fallocate(), the caller of ext4_alloc_file_blocks(). So remove the
redundant calls to inode_set_ctime_current() and inode_set_mtime_to_ts()
in ext4_alloc_file_blocks().

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f4009544f762..7abe47f923c0 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4623,13 +4623,10 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 		 */
 		retries = 0;
 		epos = EXT4_LBLK_TO_B(inode, map.m_lblk + ret);
-		inode_set_ctime_current(inode);
 		if (new_size) {
 			if (epos > new_size)
 				epos = new_size;
-			if (ext4_update_inode_size(inode, epos) & 0x1)
-				inode_set_mtime_to_ts(inode,
-						      inode_get_ctime(inode));
+			ext4_update_inode_size(inode, epos);
 			if (epos > old_size)
 				pagecache_isize_extended(inode, old_size, epos);
 		}
-- 
2.52.0

