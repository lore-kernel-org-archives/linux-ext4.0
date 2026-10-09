Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AB74AD4A8;
	Fri,  9 Oct 2026 10:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542249; cv=none; b=gfm4EAxKN4kaRcx03uFW8E2yruEE578gfjxHmmqLz70VxJ4Wwv0IFcD34u2fZIiCCmvoq2fSbrVsqRhkQ76OFCKKUjO51h/Bunj0w4hhEtFk8V8naHfFvUIh7mHUvRsVYVK4YqIKt2xnxCvRdCSWMPb/3vfolB3GX5XT+A3GHRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542249; c=relaxed/simple;
	bh=24XEr937KBemqk4d0mAcaT7/7H82gSkruSxHBfqDhGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQv9Usry+Gvrl/+JHLzklAqL+T4QG/wBdnhMunnp26mp0OQI0+W6qeXcfgYY6lCEPzPYwlONFjozVyF57c3y1qDwIcsCmgn2ubuIZVWJIiAnvVz1eVH1owZzo1ykMHeOMCwijJ01fDl4Sfnw5HlNw8jUpjCE+hinLlCAiEJKPeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1NZV5gvyzYQv3V;
	Fri,  9 Oct 2026 18:36:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 0636640578;
	Fri,  9 Oct 2026 18:37:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXGG3Vw8hqUHceDQ--.45810S5;
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
Subject: [PATCH v7 01/31] ext4: simplify size updating in ext4_setattr()
Date: Fri,  9 Oct 2026 18:30:02 +0800
Message-ID: <20261009103033.2920530-2-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBXGG3Vw8hqUHceDQ--.45810S5
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4rtry7KFWUtr4UuFWfZrb_yoW8Kr1fpF
	y3Kw1vkw10gF1q9rn2gF1UZa48ta1093yUXFWUCw4IqFyDC3ZaqF17K3y3WFWrtrWkWw4Y
	qF4kGrs5Aw1UGrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRAb10DUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The logic for updating the file size in ext4_setattr() is currently
somewhat messy. By directly entering the error-handling path after
failing to add an orphan inode, the unnecessary recovery process
involving old_disksize and the file size can be avoided.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/inode.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26f0f9714f03c..ddee4c50bd859 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6080,7 +6080,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (attr->ia_valid & ATTR_SIZE) {
 		handle_t *handle;
 		loff_t oldsize = inode->i_size;
-		loff_t old_disksize;
 		int shrink = (attr->ia_size < inode->i_size);
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
@@ -6164,6 +6163,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			if (ext4_handle_valid(handle) && shrink) {
 				error = ext4_orphan_add(handle, inode);
 				orphan = 1;
+				if (error)
+					goto out_handle;
 			}
 
 			if (shrink)
@@ -6179,23 +6180,18 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
 					inode->i_sb->s_blocksize_bits);
 
-			down_write(&EXT4_I(inode)->i_data_sem);
-			old_disksize = EXT4_I(inode)->i_disksize;
-			EXT4_I(inode)->i_disksize = attr->ia_size;
-
 			/*
 			 * We have to update i_size under i_data_sem together
 			 * with i_disksize to avoid races with writeback code
-			 * running ext4_wb_update_i_disksize().
+			 * updating disksize in mpage_map_and_submit_extent().
 			 */
-			if (!error)
-				i_size_write(inode, attr->ia_size);
-			else
-				EXT4_I(inode)->i_disksize = old_disksize;
+			down_write(&EXT4_I(inode)->i_data_sem);
+			i_size_write(inode, attr->ia_size);
+			EXT4_I(inode)->i_disksize = attr->ia_size;
 			up_write(&EXT4_I(inode)->i_data_sem);
-			rc = ext4_mark_inode_dirty(handle, inode);
-			if (!error)
-				error = rc;
+
+			error = ext4_mark_inode_dirty(handle, inode);
+out_handle:
 			ext4_journal_stop(handle);
 			if (error)
 				goto out_mmap_sem;
-- 
2.52.0

