Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9236738D69D;
	Fri, 14 Aug 2026 09:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700403; cv=none; b=slrYANhBiS5gTQGyUgxsrvpZ6v3H3riIs88VkhxaMwZdxZW1+YbOkuXmK89jQoQ+e4sCSOE/1LV4i4JzypNKwPRVRgA53CLz8LFRqnzMQFrI+lt9PMogIZ+JSLlyPNNlEz8UQHp2RLFHYw0ivMADQshwu8B2e5IUWTZtyebhXuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700403; c=relaxed/simple;
	bh=kAtOeW3AotyzWlGvjxc0dXev0Sckxwg/8ubM9GtQsa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBkH+Y3eRT5ChQ6Ne40VOGIN1JzjCIXdrFXb8g/Qoczsj4mmajYkXKgfzidbvv/9rwkOMbzhROjrq1wWakNO7zdLzDOIF8PfxXgiIpfr60ypoG8nczAeJ3/twUQY/3RshsWKFEiHCXSsub/AmLoX5aqijDB0Cm2fGWuvioGkeK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hLxyQ5kVPzKHNKH;
	Fri, 14 Aug 2026 17:39:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 8630A40561;
	Fri, 14 Aug 2026 17:39:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0JO4n5qk4oXCQ--.21396S7;
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
Subject: [PATCH -next v5 03/32] ext4: simplify error handling in ext4_setattr()
Date: Fri, 14 Aug 2026 17:33:02 +0800
Message-ID: <20260814093331.1703882-4-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgBHg0JO4n5qk4oXCQ--.21396S7
X-Coremail-Antispam: 1UD129KBjvJXoWxZr13JF1kCFW3Zr1UCF1ftFb_yoW5Wr4UpF
	13G3Wqkr48XF1UWF48tFy7Zw4Fga1Iq3yUXFyag3Z2kFn5Jr1qgFy2qayFgFy5GrWkGw1a
	qF4UKry3CFyUA3DanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnI
	WIevJa73UjIFyTuYvjTRMUDJDUUUU
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
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8654006a57ef..76bf0e944ebe 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6116,7 +6116,7 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct iattr *attr)
 {
 	struct inode *inode = d_inode(dentry);
-	int error, rc = 0;
+	int error;
 	int orphan = 0;
 	const unsigned int ia_valid = attr->ia_valid;
 	bool inc_ivers = true;
@@ -6229,10 +6229,10 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 
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
@@ -6244,15 +6244,19 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
@@ -6260,14 +6264,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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

