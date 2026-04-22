Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A59320299B;
	Wed, 22 Apr 2026 02:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776824220; cv=none; b=TreVKJCl9Ogge1iiiVHvHcFM1B3/e76acRFZFdWrcqCfrxv8UbM4DuQRgD83d43+4fd5/Wc4vmbaUiq4eCMZHxWfxBSuqxkVFADzgdBuX8XrgRTT/cmOpURzLz2tEtfRhA+D+xVMbXhLSAlBDnzhyaYwSvmYPHIONudVJl+wcCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776824220; c=relaxed/simple;
	bh=v0C9dOfxKQztbHv75QGxmgf12Sk8kWfhRM5Rh5+JIOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvWIkE9H+VtLTNvQLeMjCzh7mO4Dwrnu9miIfHKLlRODEWLxNnX0xi0mA+vGMojnotCVUtKwLs1bfnkuO9IaYrpYmfiysVEf4pLnQ6URKKTUsSaBmiOrzzhU7S8UmtcHbx0sC0xK5HwIRal/0GR8V6WSfVo7IXhFZlD9d/EAfGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g0jWL4cc0zYQtpy;
	Wed, 22 Apr 2026 10:15:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id D0B8F40604;
	Wed, 22 Apr 2026 10:16:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL6PL+hpqkgUBQ--.2635S7;
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
Subject: [PATCH v3 03/22] ext4: simplify error handling in ext4_setattr()
Date: Wed, 22 Apr 2026 10:10:23 +0800
Message-ID: <20260422021042.4157510-4-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgB3JL6PL+hpqkgUBQ--.2635S7
X-Coremail-Antispam: 1UD129KBjvJXoW7uw1xZr4UKF17Kw1xXryrZwb_yoW8Kry5pF
	yfG3Wqkr48Wr9rWr4rKFy7Z3WFq3WIq3yUAFy3K3Z2kFn3JwnxtFy2gayFgFW5GrWkWw1a
	qF4UKr9xCr15W3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjfUF3kuDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Remove the redundant rc variable and consolidate error handling.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5e913aca6499..59405a95ecfc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5960,7 +5960,7 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct iattr *attr)
 {
 	struct inode *inode = d_inode(dentry);
-	int error, rc = 0;
+	int error;
 	int orphan = 0;
 	const unsigned int ia_valid = attr->ia_valid;
 	bool inc_ivers = true;
@@ -6073,8 +6073,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 
 		filemap_invalidate_lock(inode->i_mapping);
 
-		rc = ext4_break_layouts(inode);
-		if (rc) {
+		error = ext4_break_layouts(inode);
+		if (error) {
 			filemap_invalidate_unlock(inode->i_mapping);
 			goto err_out;
 		}
@@ -6096,22 +6096,23 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		 * Call ext4_truncate() even if i_size didn't change to
 		 * truncate possible preallocated blocks.
 		 */
-		if (attr->ia_size <= oldsize) {
-			rc = ext4_truncate(inode);
-			if (rc)
-				error = rc;
-		}
+		if (attr->ia_size <= oldsize)
+			error = ext4_truncate(inode);
 out_mmap_sem:
 		filemap_invalidate_unlock(inode->i_mapping);
+		if (error)
+			goto err_out;
 	}
 
-	if (!error) {
-		if (inc_ivers)
-			inode_inc_iversion(inode);
-		setattr_copy(idmap, inode, attr);
-		mark_inode_dirty(inode);
-	}
+	if (inc_ivers)
+		inode_inc_iversion(inode);
+	setattr_copy(idmap, inode, attr);
+	mark_inode_dirty(inode);
 
+	if (ia_valid & ATTR_MODE)
+		error = posix_acl_chmod(idmap, dentry, inode->i_mode);
+
+err_out:
 	/*
 	 * If the call to ext4_truncate failed to get a transaction handle at
 	 * all, we need to clean up the in-core orphan list manually.
@@ -6119,14 +6120,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (orphan && inode->i_nlink)
 		ext4_orphan_del(NULL, inode);
 
-	if (!error && (ia_valid & ATTR_MODE))
-		rc = posix_acl_chmod(idmap, dentry, inode->i_mode);
-
-err_out:
-	if  (error)
+	if (error)
 		ext4_std_error(inode->i_sb, error);
-	if (!error)
-		error = rc;
 	return error;
 }
 
-- 
2.52.0

