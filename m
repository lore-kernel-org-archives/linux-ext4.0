Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C926A378822
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 11:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776772042; cv=none; b=Fgae5Qlo99mlw15O213pZlGWWWDfIBhg9qfWwuBdb9Qbudp9aV5qdq7tGPzfLZTCi+C8mjyhHpgH54BRe0UTdgxwXZO/M3fKuUZa/1+cqPa2vNdJ2NSrlM1OtxrBRPNTwGdSA7K+5SP8tU247ZqHdudtm/RfNkIHR3UdTh6TleE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776772042; c=relaxed/simple;
	bh=EXIpyePpkEcn2m5uABMFMAm/ipu1E/AN4eD7mtstiiw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qFruAu/wyouI9zjYIrowe6taDGMQul+s4h8/wsNzknX2strf03TceN4LIk951sw/XXvQDkbfRoS+W15z4HAshQGq8ksyvptK62Ka8ad0i5Xax8zJb9eBu8YrLsJGB/849lG/0nJFTNQF2qgaYoBMnHDDR1skhFMRfEpBpAhuSCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g0LDS4gMGzKHMls
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 19:46:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id B920040602
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 19:47:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL21Y+dp_aHLBA--.55420S6;
	Tue, 21 Apr 2026 19:47:07 +0800 (CST)
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
Subject: [PATH 6.6 2/3] ext4: get rid of ppath in ext4_force_split_extent_at()
Date: Tue, 21 Apr 2026 19:34:15 +0800
Message-Id: <20260421113416.4040274-3-yangerkun@huawei.com>
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
X-CM-TRANSID:_Ch0CgAHtL21Y+dp_aHLBA--.55420S6
X-Coremail-Antispam: 1UD129KBjvJXoW3Ar47Gr48Aw47GFy5Wr18AFb_yoW7XF1fpr
	13CFn7Gr95Kas0grWIq3W7Zr1aka1UGrWUGr97Gas5GF1qqw1F9F17t3WrtFy5trW8ua4a
	yr4I9r15W3W5ta7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
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
	cSsGvfC2KfnxnUUI43ZEXa7IU1jXdUUUUUU==
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit f07be1c367369636d7d338d7994473d6eae283c5 ]

The use of path and ppath is now very confusing, so to make the code more
readable, pass path between functions uniformly, and get rid of ppath.

To get rid of the ppath in ext4_force_split_extent_at(), the following is
done here:

 * Free the extents path when an error is encountered.

No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-17-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 fs/ext4/extents.c | 69 ++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 31 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 300bf2289bc1..0406dac7fbf1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -329,27 +329,20 @@ static inline int ext4_ext_space_root_idx(struct inode *inode, int check)
 	return size;
 }
 
-static inline int
+static inline struct ext4_ext_path *
 ext4_force_split_extent_at(handle_t *handle, struct inode *inode,
-			   struct ext4_ext_path **ppath, ext4_lblk_t lblk,
+			   struct ext4_ext_path *path, ext4_lblk_t lblk,
 			   int nofail)
 {
-	struct ext4_ext_path *path = *ppath;
 	int unwritten = ext4_ext_is_unwritten(path[path->p_depth].p_ext);
 	int flags = EXT4_EX_NOCACHE | EXT4_GET_BLOCKS_PRE_IO;
 
 	if (nofail)
 		flags |= EXT4_GET_BLOCKS_METADATA_NOFAIL | EXT4_EX_NOFAIL;
 
-	path = ext4_split_extent_at(handle, inode, path, lblk, unwritten ?
+	return ext4_split_extent_at(handle, inode, path, lblk, unwritten ?
 			EXT4_EXT_MARK_UNWRIT1|EXT4_EXT_MARK_UNWRIT2 : 0,
 			flags);
-	if (IS_ERR(path)) {
-		*ppath = NULL;
-		return PTR_ERR(path);
-	}
-	*ppath = path;
-	return 0;
 }
 
 static int
@@ -2890,11 +2883,12 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 			 * fail removing space due to ENOSPC so try to use
 			 * reserved block if that happens.
 			 */
-			err = ext4_force_split_extent_at(handle, inode, &path,
-							 end + 1, 1);
-			if (err < 0)
+			path = ext4_force_split_extent_at(handle, inode, path,
+							  end + 1, 1);
+			if (IS_ERR(path)) {
+				err = PTR_ERR(path);
 				goto out;
-
+			}
 		} else if (sbi->s_cluster_ratio > 1 && end >= ex_end &&
 			   partial.state == initial) {
 			/*
@@ -5772,17 +5766,21 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 		/* Prepare left boundary */
 		if (e1_blk < lblk1) {
 			split = 1;
-			*erp = ext4_force_split_extent_at(handle, inode1,
-						&path1, lblk1, 0);
-			if (unlikely(*erp))
+			path1 = ext4_force_split_extent_at(handle, inode1,
+							   path1, lblk1, 0);
+			if (IS_ERR(path1)) {
+				*erp = PTR_ERR(path1);
 				goto finish;
+			}
 		}
 		if (e2_blk < lblk2) {
 			split = 1;
-			*erp = ext4_force_split_extent_at(handle, inode2,
-						&path2,  lblk2, 0);
-			if (unlikely(*erp))
+			path2 = ext4_force_split_extent_at(handle, inode2,
+							   path2, lblk2, 0);
+			if (IS_ERR(path2)) {
+				*erp = PTR_ERR(path2);
 				goto finish;
+			}
 		}
 		/* ext4_split_extent_at() may result in leaf extent split,
 		 * path must to be revalidated. */
@@ -5798,17 +5796,21 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 
 		if (len != e1_len) {
 			split = 1;
-			*erp = ext4_force_split_extent_at(handle, inode1,
-						&path1, lblk1 + len, 0);
-			if (unlikely(*erp))
+			path1 = ext4_force_split_extent_at(handle, inode1,
+							path1, lblk1 + len, 0);
+			if (IS_ERR(path1)) {
+				*erp = PTR_ERR(path1);
 				goto finish;
+			}
 		}
 		if (len != e2_len) {
 			split = 1;
-			*erp = ext4_force_split_extent_at(handle, inode2,
-						&path2, lblk2 + len, 0);
-			if (*erp)
+			path2 = ext4_force_split_extent_at(handle, inode2,
+							path2, lblk2 + len, 0);
+			if (IS_ERR(path2)) {
+				*erp = PTR_ERR(path2);
 				goto finish;
+			}
 		}
 		/* ext4_split_extent_at() may result in leaf extent split,
 		 * path must to be revalidated. */
@@ -5974,24 +5976,29 @@ int ext4_ext_replay_update_ex(struct inode *inode, ext4_lblk_t start,
 		ext4_ext_get_actual_len(ex) != len) {
 		/* We need to split this extent to match our extent first */
 		down_write(&EXT4_I(inode)->i_data_sem);
-		ret = ext4_force_split_extent_at(NULL, inode, &path, start, 1);
+		path = ext4_force_split_extent_at(NULL, inode, path, start, 1);
 		up_write(&EXT4_I(inode)->i_data_sem);
-		if (ret)
+		if (IS_ERR(path)) {
+			ret = PTR_ERR(path);
 			goto out;
+		}
 
 		path = ext4_find_extent(inode, start, path, 0);
 		if (IS_ERR(path))
 			return PTR_ERR(path);
+
 		ex = path[path->p_depth].p_ext;
 		WARN_ON(le32_to_cpu(ex->ee_block) != start);
 
 		if (ext4_ext_get_actual_len(ex) != len) {
 			down_write(&EXT4_I(inode)->i_data_sem);
-			ret = ext4_force_split_extent_at(NULL, inode, &path,
-							 start + len, 1);
+			path = ext4_force_split_extent_at(NULL, inode, path,
+							  start + len, 1);
 			up_write(&EXT4_I(inode)->i_data_sem);
-			if (ret)
+			if (IS_ERR(path)) {
+				ret = PTR_ERR(path);
 				goto out;
+			}
 
 			path = ext4_find_extent(inode, start, path, 0);
 			if (IS_ERR(path))
-- 
2.39.2

