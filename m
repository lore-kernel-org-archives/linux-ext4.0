Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ECC363097
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 11:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776772041; cv=none; b=T3m06dj10O5KZ/YPcWxUHVW8h4cXmGUVvLVFsc19Xr/DmoC9y12EoTa5r+YAPvUJFZdpQEH/N0fW+Zefx8FDp9zTYo2xTae9Wl9ayYNtsIXeij9j32VZFbOgt2Axzxgd8BMkvgxx9s9jwXQp4X4V3Z5pq/6A2+MnzpUKJYlA5ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776772041; c=relaxed/simple;
	bh=D66/wMh0iVaRHLdp1t7CiazsAhJEfo45kH7FuW4jvlA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rmq5tbqQqy4aZXiDdN0fSfB5HSssA9eA/JQ6QEvVCZuvLBeUn1YWk4/hSDrqLgZhEDa1tKYb5B6MICEwOB/GzODpK8tvryuhwzqrDxRUWsja/LZoa9u6AKe3oP/IcImhfFGBc0569GzMuWPr0E1qmhS898seXpRO1DnQ2QOZvJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g0LCl3MMkzYQv7t
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 19:46:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A08DD40604
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 19:47:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL21Y+dp_aHLBA--.55420S5;
	Tue, 21 Apr 2026 19:47:05 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: stable@kernel.org,
	linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	libaokun@linux.alibaba.com,
	adilger.kernel@dilger.ca,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	jack@suse.cz,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	zhangxiaoxu5@huawei.com
Subject: [PATH 6.6 1/3] ext4: get rid of ppath in get_ext_path()
Date: Tue, 21 Apr 2026 19:34:14 +0800
Message-Id: <20260421113416.4040274-2-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260421113416.4040274-1-yangerkun@huawei.com>
References: <20260421113416.4040274-1-yangerkun@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAHtL21Y+dp_aHLBA--.55420S5
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4kJrW7Kr48uw47tF18Zrb_yoWrWrWkpF
	4Syr1Ygr40qa12krZ7Ka1UZr1UKa1rG3y7WryfGw109FW7Xr1F9F1xt3WYvFyrKFW8WFya
	vF4Syr1UC34UKrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY
	6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14
	v26r1q6r43MxAIw28IcxkI7VAKI48JMxAIw28IcVAKzI0EY4vE52x082I5MxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
	cSsGvfC2KfnxnUUI43ZEXa7IU875r7UUUUU==
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 6b854d552711aa33f59eda334e6d94a00d8825bb ]

The use of path and ppath is now very confusing, so to make the code more
readable, pass path between functions uniformly, and get rid of ppath.

After getting rid of ppath in get_ext_path(), its caller may pass an error
pointer to ext4_free_ext_path(), so it needs to teach ext4_free_ext_path()
and ext4_ext_drop_refs() to skip the error pointer. No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-13-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[we need IS_ERR_OR_NULL to prevent oops]
Reported-by: Hulk Robot <hulkrobot@huawei.com>
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 fs/ext4/extents.c     |  5 +++--
 fs/ext4/move_extent.c | 34 +++++++++++++++++-----------------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7626cf2b07f1..300bf2289bc1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -114,7 +114,7 @@ static void ext4_ext_drop_refs(struct ext4_ext_path *path)
 {
 	int depth, i;
 
-	if (!path)
+	if (IS_ERR_OR_NULL(path))
 		return;
 	depth = path->p_depth;
 	for (i = 0; i <= depth; i++, path++) {
@@ -125,6 +125,8 @@ static void ext4_ext_drop_refs(struct ext4_ext_path *path)
 
 void ext4_free_ext_path(struct ext4_ext_path *path)
 {
+	if (IS_ERR_OR_NULL(path))
+		return;
 	ext4_ext_drop_refs(path);
 	kfree(path);
 }
@@ -4227,7 +4229,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	path = ext4_find_extent(inode, map->m_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
-		path = NULL;
 		goto out;
 	}
 
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index d5636a2a718a..96a84de32169 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -17,27 +17,23 @@
  * get_ext_path() - Find an extent path for designated logical block number.
  * @inode:	inode to be searched
  * @lblock:	logical block number to find an extent path
- * @ppath:	pointer to an extent path pointer (for output)
+ * @path:	pointer to an extent path
  *
- * ext4_find_extent wrapper. Return 0 on success, or a negative error value
- * on failure.
+ * ext4_find_extent wrapper. Return an extent path pointer on success,
+ * or an error pointer on failure.
  */
-static inline int
+static inline struct ext4_ext_path *
 get_ext_path(struct inode *inode, ext4_lblk_t lblock,
-		struct ext4_ext_path **ppath)
+	     struct ext4_ext_path *path)
 {
-	struct ext4_ext_path *path = *ppath;
-
-	*ppath = NULL;
 	path = ext4_find_extent(inode, lblock, path, EXT4_EX_NOCACHE);
 	if (IS_ERR(path))
-		return PTR_ERR(path);
+		return path;
 	if (path[ext_depth(inode)].p_ext == NULL) {
 		ext4_free_ext_path(path);
-		return -ENODATA;
+		return ERR_PTR(-ENODATA);
 	}
-	*ppath = path;
-	return 0;
+	return path;
 }
 
 /**
@@ -95,9 +91,11 @@ mext_check_coverage(struct inode *inode, ext4_lblk_t from, ext4_lblk_t count,
 	int ret = 0;
 	ext4_lblk_t last = from + count;
 	while (from < last) {
-		*err = get_ext_path(inode, from, &path);
-		if (*err)
-			goto out;
+		path = get_ext_path(inode, from, path);
+		if (IS_ERR(path)) {
+			*err = PTR_ERR(path);
+			return ret;
+		}
 		ext = path[ext_depth(inode)].p_ext;
 		if (unwritten != ext4_ext_is_unwritten(ext))
 			goto out;
@@ -634,9 +632,11 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 		int offset_in_page;
 		int unwritten, cur_len;
 
-		ret = get_ext_path(orig_inode, o_start, &path);
-		if (ret)
+		path = get_ext_path(orig_inode, o_start, path);
+		if (IS_ERR(path)) {
+			ret = PTR_ERR(path);
 			goto out;
+		}
 		ex = path[path->p_depth].p_ext;
 		cur_blk = le32_to_cpu(ex->ee_block);
 		cur_len = ext4_ext_get_actual_len(ex);
-- 
2.39.2

