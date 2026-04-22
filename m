Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACBA2FFFA4;
	Wed, 22 Apr 2026 02:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824220; cv=none; b=KfJw4GFr3GoDVWr5X7PeKSACa/GtGTaFrVu4TRa6/WzXuLub0p0s9BQAv+LFZVU4Vhm1gS2chf6NNSYb/sZ8+65oIB50ZnNXtP3ivRQpY3R/Re5KOQOR1Y06dcCQkM/RwSP4e2goB5cWNBhIrktiOKGfL3HQJS4KhPta0sY6A9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824220; c=relaxed/simple;
	bh=2GLqOrJzpWznwh/KQhRAwJU+dvoOKIfi+7HjpC9I4vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVnBhKAxhuW+KELN/zeDecq4QwHVPIFLgBbdVy+bHfYkadFA1O6suiCFzDzCj4CkhegKR36qgDAdx8Yh3t3Z21hYclZuwicH71UvurtwfqE1LCoCnrAw/qYBTdXVNTXnWjM5Q5HW5ZXcD88O171tjCA+6lZQNCbMcKEoenb7FsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g0jWL3M0pzYQtpd;
	Wed, 22 Apr 2026 10:15:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A6843405D6;
	Wed, 22 Apr 2026 10:16:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S5;
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
Subject: [PATCH v3 01/22] ext4: simplify size updating in ext4_setattr()
Date: Wed, 22 Apr 2026 10:10:21 +0800
Message-ID: <20260422021042.4157510-2-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S5
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4rtrW5Xr4DZr1kJr4ruFg_yoW8tryxpF
	yakw1vkw10gF1q9rs2gF1UZa40qa1093yUJFWjkw4IqF1DC3ZaqF17tay3uFW8trWDWw4Y
	qFWkKr4rJ34UGrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JUfKs8UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The logic for updating the file size in ext4_setattr() is currently
somewhat messy. By directly entering the error-handling path after
failing to add an orphan inode, the unnecessary recovery process
involving old_disksize and the file size can be avoided.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..0751dc55e94f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5953,7 +5953,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (attr->ia_valid & ATTR_SIZE) {
 		handle_t *handle;
 		loff_t oldsize = inode->i_size;
-		loff_t old_disksize;
 		int shrink = (attr->ia_size < inode->i_size);
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
@@ -6037,6 +6036,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			if (ext4_handle_valid(handle) && shrink) {
 				error = ext4_orphan_add(handle, inode);
 				orphan = 1;
+				if (error)
+					goto out_handle;
 			}
 
 			if (shrink)
@@ -6052,23 +6053,18 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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

