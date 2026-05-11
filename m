Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DFD3815FE;
	Mon, 11 May 2026 07:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484510; cv=none; b=igEKUiUC/I8jb13RbT92fbOlKqtiGON54mmyASSg37eRDpnQUOqFiWd2G4GGzEncYmmunr5ZlY8ELoslGsDTGvPmwCLiBvm1Cya6CSIH+gIs7/Fo9+cANlOf0H+TWDbnnMWMyMeeCGwYBWXmRCUYhzMZw7e6M17qyAs+z2Pw0mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484510; c=relaxed/simple;
	bh=OGMBpPyaow+gJIEij8UMq76ggdRYF2wiiOdFP8IUo3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cs/XwuOw85ONk8HJmWRlbBVMABavksxulApiljlOivFEux2z0ujPyk9O1+l94PNq7uKeaINPYQrasIl9hjNi/STAizgmCctJRNQ51qPET7/34ywmXPQCrfZjIlg+f5QXos+/UDtps0Jq/1dLGI3a7ylo1tpilrNMnzUeJdhujE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gDWX40RX5zKHMct;
	Mon, 11 May 2026 15:27:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 918CC4056B;
	Mon, 11 May 2026 15:28:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S5;
	Mon, 11 May 2026 15:28:22 +0800 (CST)
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
Subject: [PATCH v4 01/23] ext4: simplify size updating in ext4_setattr()
Date: Mon, 11 May 2026 15:23:21 +0800
Message-ID: <20260511072344.191271-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S5
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4rtrWrZw1kAw1rXw18Krg_yoW8tF4DpF
	yakw1vkw10gF1q9rn2gF1UZa40qa1093yUXFWjkw40qF1DC3ZaqF17t3y3uFW8trWDWw4Y
	qF4kKr4rJw1UGrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JU4OJ5UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The logic for updating the file size in ext4_setattr() is currently
somewhat messy. By directly entering the error-handling path after
failing to add an orphan inode, the unnecessary recovery process
involving old_disksize and the file size can be avoided.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
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

