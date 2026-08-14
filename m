Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E45B377EC6;
	Fri, 14 Aug 2026 09:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700401; cv=none; b=MN83Nz347G1ROSkCdTqkKrLHVVEYxksxvV9nb87kc0xsZ3oIo+6Yq0nKzdZMlghbmpZIXj7zqawXa+LxUnT/rsaUHEk7IRmGqYlHR+7MkzTCt4fBe4vHtVfVggqwFGCPdCjqhPk9la0WfdrxglSHDu8rKtcqFyGCMORPAG01DCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700401; c=relaxed/simple;
	bh=Ze8OLBqaSJHPqqxEAibPW8+QCySn1F2/YqZV0G4UaJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6FAlfVjZUQHNRcAoNaEIJoq+NmaOomg+MxHe/apc3PKu0ebmxqvUsaodAMNIGn3+qHNmTzWO9cZX9CwQYkN7HiSkLkxnv10t46SCB5pdW2puz7xsFCc5QVwt/lm7jA7RXUlZgcj1EcKH2Qc6TVslMKJbQAhGTjw0yZCSElil1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyR06qszKHNMR;
	Fri, 14 Aug 2026 17:39:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id AFB9840593;
	Fri, 14 Aug 2026 17:39:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S9;
	Fri, 14 Aug 2026 17:39:47 +0800 (CST)
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
	yukuai@fnnas.com
Subject: [PATCH -next v5 05/32] ext4: set EXT4_MAP_NEW flag for delayed allocated blocks
Date: Fri, 14 Aug 2026 17:33:04 +0800
Message-ID: <20260814093331.1703882-6-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S9
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4xCr4xGrWUZF48XF1rCrg_yoWDZFgE9a
	yxZr48Zr1rJr1Ska98AF13Zr1vkw4xGr1xua45try3Xa48ArZ8G3ZxAFy3Za4DuF4rurZ8
	AryrXrW2kFWIqjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb98FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRPCzZUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Set EXT4_MAP_NEW in ext4_da_map_blocks() to properly indicate that a
new delayed allocation block has been inserted, allowing callers to
distinguish newly created delayed extents from existing ones.

Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/linux-ext4/cc05c17d-163e-4251-b2c9-aa3a6f9555d7@huaweicloud.com/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7601fe3618b1..9dbece14ae56 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1990,7 +1990,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
 		}
 	}
 
-	map->m_flags |= EXT4_MAP_DELAYED;
+	map->m_flags |= EXT4_MAP_DELAYED | EXT4_MAP_NEW;
 	retval = ext4_insert_delayed_blocks(inode, map->m_lblk, map->m_len);
 	if (!retval)
 		map->m_seq = READ_ONCE(EXT4_I(inode)->i_es_seq);
-- 
2.52.0

