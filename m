Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89B93C0607;
	Fri,  9 Oct 2026 10:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542245; cv=none; b=Mhrx6ONntGHJIUJQt1E4heewebnLCtG6wZ/nX6PQOowStkGHsaw0DxDM3818rEP1iAeI3qnJ8HzRopHfOF54ovhykvOn9NtnuZYbcbO4fxc4UQqEI0WZQwqtbHq8dm/+55xqTIw1lnO/1c8It0mK4JX8y6iQrlCYrnNMvQ08Xo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542245; c=relaxed/simple;
	bh=FpFEIIw6z6LfKO7HtLkzed6dXK/6QXGSoQTmGa1VjdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a366NxkhOiPAseBShIpTOjCUWgjsj7tTkVba4oPbb1Dzi3glrO8JTk9mqPLQOz8IG1jCdQhIu4v5X/L9W1BNOk7GVkg9TFaCIO2R7yOI7hsPiHwLnJZ4RYUL0Uwcg73cZJbt4YBYwnMbgO7YkPpKgFgEey/hbhpv7X5dJZTjtPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZM1rhqzKHMpD;
	Fri,  9 Oct 2026 18:36:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 3135E40CCD;
	Fri,  9 Oct 2026 18:37:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S7;
	Fri, 09 Oct 2026 18:37:18 +0800 (CST)
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
Subject: [PATCH v7 03/31] ext4: set EXT4_MAP_NEW flag for delayed allocated blocks
Date: Fri,  9 Oct 2026 18:30:04 +0800
Message-ID: <20261009103033.2920530-4-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S7
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1UXrWxXF1xGFWrGw1kGrg_yoW8GF4fpa
	95CFy8WF10gr1UuanagF1UZF1UKa1kGrWUCFZ8Jr15ZrZxJrnYqr4q9F13XF1DtrZ7WrWF
	qF15WryrAa18C37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7VUUbAw7UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Set EXT4_MAP_NEW in ext4_da_map_blocks() to properly indicate that a
new delayed allocation block has been inserted, allowing callers to
distinguish newly created delayed extents from existing ones.

Currently, the buffer_head caller, ext4_da_get_block_prep(), does not
consume this flag. It intercepts EXT4_MAP_DELAYED and returns early, and
unconditionally calls set_buffer_new(bh) so EXT4_MAP_NEW is not used.
The flag is prepared for the iomap buffered I/O path added later.

Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/linux-ext4/cc05c17d-163e-4251-b2c9-aa3a6f9555d7@huaweicloud.com/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d0ccafa554f8d..c0f8ff495dd82 100644
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

