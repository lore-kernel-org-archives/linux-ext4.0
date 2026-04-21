Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383CF30FC34
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 11:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776772042; cv=none; b=UijInad4VOQIxwHAdSp7IuE+BZQDYEWfjN0+atJOstR7yGGZ2J9BD+2GHej1cVxEIzQSwcx47a8qb061mav4SKRH9dPqQOIrdKqcCg9dlIxPUaQeVch1agA0obzI66IBj/eXWit7emDNhSLX/qycKmF4mrG8gExkaS4Fp68i/L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776772042; c=relaxed/simple;
	bh=IZNXMonAYULaiUHcL6JTv5QJlHcabQ2QE9Un6yOKerg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UmKeVKs8jJvrEg0YZRuILjOOzRfD71eyhi0mVg63LwMgjNojfZZ1vruymHK2hlBwYKALi+yliG4pRdsT6LjJ/mQLwICJVV8N8ltQQRlBdZuD75MSNFmnDYza4bfQNILtDQMJyZcsyDDiU7d/NMZNh6Y5Q+OVL2DLyQ5gaUA/ixk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g0LCl4mmZzYQv9S
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 19:46:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id D085940600
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 19:47:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL21Y+dp_aHLBA--.55420S7;
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
Subject: [PATH 6.6 3/3] ext4: get rid of ppath in convert_initialized_extent()
Date: Tue, 21 Apr 2026 19:34:16 +0800
Message-Id: <20260421113416.4040274-4-yangerkun@huawei.com>
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
X-CM-TRANSID:_Ch0CgAHtL21Y+dp_aHLBA--.55420S7
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4DKF45Wr13uF45ArW5ZFb_yoWrJr1fpF
	yfZr1rCr1Yg3y2grZ7Ja1UZryaka18Ga1UGrW3t34F9an2vr1FgFyxt3WFyFWFqFW8Wa4a
	vFW0yr18C3W7CaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmlb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij28IcwCFx2IqxVCF
	s4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
	1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWU
	JVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4U
	JbIYCTnIWIevJa73UjIFyTuYvjxUoZXoUUUUU
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4191eefef978d734fa8249bede3f9b02a85aa3c0 ]

The use of path and ppath is now very confusing, so to make the code more
readable, pass path between functions uniformly, and get rid of ppath.

To get rid of the ppath in convert_initialized_extent(), the following is
done here:

 * Free the extents path when an error is encountered.

No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-23-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 fs/ext4/extents.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0406dac7fbf1..1c55f498ce4f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3830,13 +3830,12 @@ ext4_convert_unwritten_extents_endio(handle_t *handle, struct inode *inode,
 	return ERR_PTR(err);
 }
 
-static int
+static struct ext4_ext_path *
 convert_initialized_extent(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map,
-			   struct ext4_ext_path **ppath,
+			   struct ext4_ext_path *path,
 			   unsigned int *allocated)
 {
-	struct ext4_ext_path *path = *ppath;
 	struct ext4_extent *ex;
 	ext4_lblk_t ee_block;
 	unsigned int ee_len;
@@ -3861,29 +3860,25 @@ convert_initialized_extent(handle_t *handle, struct inode *inode,
 	if (ee_block != map->m_lblk || ee_len > map->m_len) {
 		path = ext4_split_convert_extents(handle, inode, map, path,
 				EXT4_GET_BLOCKS_CONVERT_UNWRITTEN, NULL);
-		if (IS_ERR(path)) {
-			*ppath = NULL;
-			return PTR_ERR(path);
-		}
+		if (IS_ERR(path))
+			return path;
 
 		path = ext4_find_extent(inode, map->m_lblk, path, 0);
-		if (IS_ERR(path)) {
-			*ppath = NULL;
-			return PTR_ERR(path);
-		}
-		*ppath = path;
+		if (IS_ERR(path))
+			return path;
 		depth = ext_depth(inode);
 		ex = path[depth].p_ext;
 		if (!ex) {
 			EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
 					 (unsigned long) map->m_lblk);
-			return -EFSCORRUPTED;
+			err = -EFSCORRUPTED;
+			goto errout;
 		}
 	}
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
-		return err;
+		goto errout;
 	/* first mark the extent as unwritten */
 	ext4_ext_mark_unwritten(ex);
 
@@ -3895,7 +3890,7 @@ convert_initialized_extent(handle_t *handle, struct inode *inode,
 	/* Mark modified extent as dirty */
 	err = ext4_ext_dirty(handle, inode, path + path->p_depth);
 	if (err)
-		return err;
+		goto errout;
 	ext4_ext_show_leaf(inode, path);
 
 	ext4_update_inode_fsync_trans(handle, inode, 1);
@@ -3904,7 +3899,11 @@ convert_initialized_extent(handle_t *handle, struct inode *inode,
 	if (*allocated > map->m_len)
 		*allocated = map->m_len;
 	map->m_len = *allocated;
-	return 0;
+	return path;
+
+errout:
+	ext4_free_ext_path(path);
+	return ERR_PTR(err);
 }
 
 static struct ext4_ext_path *
@@ -4271,8 +4270,10 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			 */
 			if ((!ext4_ext_is_unwritten(ex)) &&
 			    (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN)) {
-				err = convert_initialized_extent(handle,
-					inode, map, &path, &allocated);
+				path = convert_initialized_extent(handle,
+					inode, map, path, &allocated);
+				if (IS_ERR(path))
+					err = PTR_ERR(path);
 				goto out;
 			} else if (!ext4_ext_is_unwritten(ex)) {
 				map->m_flags |= EXT4_MAP_MAPPED;
-- 
2.39.2

