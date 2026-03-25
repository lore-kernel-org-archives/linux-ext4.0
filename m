Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993EA27AC4C;
	Wed, 25 Mar 2026 07:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774424028; cv=none; b=iidLM3eQbM/kBJHnjdwOs26yiGb0zZu53qecSu9IWYDcMMi7A5j4KQkWuZP3jUCJucXiESlsOripqJoTCZN8GHDjBti1H7GgegyIJ5TWu2pzSHnZByk6nGObBIEogiAulIE/3YZyh6YhJLwIrja43gSetzQYMeBBJCOxIpB6IiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774424028; c=relaxed/simple;
	bh=KKd39nSq2/Q+ECUd1egjak+o/qKi+d5in9fXewxY3bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQzHJrPcr/RSQpn7PgKZ1uF5Nbg2AT48RpTbP+BmvkrINhLxZMX3G95/RyLOnPMIhADVRfPopu9QXgSB1Hr5UQ+1C/qDVuR4oiLYWxeExyiMk3t3nIk2sy1gqtEbV5z9j2puaVxz3JmQJMJhb1jotvUDlVfNW9pht79b3Y6lqe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fgdt46mQTzKHMYn;
	Wed, 25 Mar 2026 15:33:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4876740575;
	Wed, 25 Mar 2026 15:33:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgAHC9vFj8NpuR6cCA--.49898S6;
	Wed, 25 Mar 2026 15:33:39 +0800 (CST)
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
Subject: [PATCH v2 02/10] ext4: ext4_block_truncate_page() returns zeroed length on success
Date: Wed, 25 Mar 2026 15:28:41 +0800
Message-ID: <20260325072850.3997161-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325072850.3997161-1-yi.zhang@huaweicloud.com>
References: <20260325072850.3997161-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAHC9vFj8NpuR6cCA--.49898S6
X-Coremail-Antispam: 1UD129KBjvJXoWxJrWrXFW3Jw4xWFyUWF1xZrb_yoW8AFykpr
	98K3yrGr4Dua4q9an29F1aqr1ak3WfGFW8Way7K34Y934fXF1xKF93KF1Fva1jqrWxXayj
	qF45tFWa9w17A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JUADGOUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Return the actual zeroed length instead of 0 on success. This prepares
for the upcoming iomap buffered I/O conversion by exposing zeroed length
information to callers.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1c9474d5d11d..f21be26b4642 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4136,6 +4136,7 @@ static int ext4_block_zero_page_range(handle_t *handle,
  * up to the end of the block which corresponds to `from'.
  * This required during truncate. We need to physically zero the tail end
  * of that block so it doesn't yield old data if the file is later grown.
+ * Return the zeroed length on success.
  */
 static int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from)
@@ -4143,6 +4144,8 @@ static int ext4_block_truncate_page(handle_t *handle,
 	unsigned length;
 	unsigned blocksize;
 	struct inode *inode = mapping->host;
+	bool did_zero = false;
+	int err;
 
 	/* If we are processing an encrypted inode during orphan list handling */
 	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
@@ -4151,7 +4154,12 @@ static int ext4_block_truncate_page(handle_t *handle,
 	blocksize = i_blocksize(inode);
 	length = blocksize - (from & (blocksize - 1));
 
-	return ext4_block_zero_page_range(handle, mapping, from, length, NULL);
+	err = ext4_block_zero_page_range(handle, mapping, from, length,
+					 &did_zero);
+	if (err)
+		return err;
+
+	return did_zero ? length : 0;
 }
 
 int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
-- 
2.52.0

