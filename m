Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AFA382F28;
	Mon, 11 May 2026 07:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484516; cv=none; b=dEvjKgVAlWQnpdSvHg1OsxrD6zQEVcEKWUMJIZfEKIqTXbeQITCiA+ARMOXF/58YXk9YReLvhJmezkwPLueXpFZNmEXo6wTI0wukcY5lGIfeRzufsdK9EbKLz1LOF4iCvDwbsmE5eMgRTWa8zYxQtS9cgK00OuHs2MCnIxizTL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484516; c=relaxed/simple;
	bh=ZGKx46dogqEsmAMWIMKLQxCHSYqNgfVNQ7opl+nGZ5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/A5kuGhJ0+Aiff66U6dbI4FktPNXF8XWv/Yp0bedYMVbb4WWAtAdDGNoszgQre3hlDyJaLEz+gnd0VZdcDMwSMPVlnBN8leUpLmlUCfdtoTb0irK3RkWVBGIn5MmszfO1fmBUxP1V5/XyCp9FIX0Vx+Ew3PIorg07q8DI+zdRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gDWXV0XyvzYQv22;
	Mon, 11 May 2026 15:27:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B553F40579;
	Mon, 11 May 2026 15:28:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sKhQFqAy6MBw--.28537S7;
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
Subject: [PATCH v4 03/23] ext4: simplify error handling in ext4_setattr()
Date: Mon, 11 May 2026 15:23:23 +0800
Message-ID: <20260511072344.191271-4-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgD3v1sKhQFqAy6MBw--.28537S7
X-Coremail-Antispam: 1UD129KBjvJXoWxZr13JF1kCFW3Zr1UAry5Arb_yoW5XrWUpF
	13Ga4qkr48XF1UWr48KFy7Zw1Fg3WIq3y8Zry3K3Z7AFn5JwnFqFy2qa4SgFW5GrWkGw1a
	qF4UKr9xCFy7Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjfUO_MaUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Refactor the error handling in ext4_setattr() for better clarity:

 - Return directly on ext4_break_layouts() failure.
 - Propagate ext4_truncate() errors using the existing error variable
   and jump to the common 'err_out' label.
 - Propagate posix_acl_chmod() errors also through the error variable,
   as it theoretically does not return a non-fatal error.

With these changes, every error path either returns immediately or jumps
to err_out. Consequently, the "if (!error)" condition guarding
setattr_copy() and mark_inode_dirty() becomes unreachable for error
cases. Remove this redundant check and the unused rc variable can be
removed as well.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 35e958f89bd5..b1ef706987c3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5989,7 +5989,7 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct iattr *attr)
 {
 	struct inode *inode = d_inode(dentry);
-	int error, rc = 0;
+	int error;
 	int orphan = 0;
 	const unsigned int ia_valid = attr->ia_valid;
 	bool inc_ivers = true;
@@ -6102,10 +6102,10 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 
 		filemap_invalidate_lock(inode->i_mapping);
 
-		rc = ext4_break_layouts(inode);
-		if (rc) {
+		error = ext4_break_layouts(inode);
+		if (error) {
 			filemap_invalidate_unlock(inode->i_mapping);
-			goto err_out;
+			return error;
 		}
 
 		if (attr->ia_size > oldsize)
@@ -6117,15 +6117,19 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		}
 
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
@@ -6133,14 +6137,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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

