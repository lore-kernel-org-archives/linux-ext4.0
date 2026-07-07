Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAF934D911;
	Tue,  7 Jul 2026 02:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783390914; cv=none; b=KtrEGJyYXVLGvpfMhYyf1vtUXoIfcFlzNU2WTQWRUneRMJwjLM+A+HHjekbHEdPgMu424MC/HLvpgQwPQKLZbdkF1z15AlDThZuRKoddLMNSW/tcvy5ktRO3DZcWP9jjlUNnWhfS0TiqTjrBT52FUPtYd8I/QXICdpINkSQx5oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783390914; c=relaxed/simple;
	bh=cTuSqL8CrB/R+YSbgz0+Rn6xYyjRWvBHBJ6B9LYSRfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHOgbs5CPI2TQ9YkqSuN+1E7JR7BmVN+LNYSkD2J7idhIWpR5+OAORuIdqVT/BEbxDXFAQmcCZmol2lnKtKqzmikGFgVreBbt5gv0zxmFrBz0cnAQqMdZCy2qJhuDIQWcj8coBhzmap5dUE/h8ro5H0ok90b0Q6R+hmO/oxY40c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gvQ2R1DMzzKHMMV;
	Tue,  7 Jul 2026 10:21:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id CDA924056B;
	Tue,  7 Jul 2026 10:21:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgA3SHShYkxqYSBRAQ--.61087S10;
	Tue, 07 Jul 2026 10:21:37 +0800 (CST)
From: Zhang Yi <yi.zhang@huawei.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v2 6/6] ext4: protect WRITE_ZEROES written extents with orphan list
Date: Tue,  7 Jul 2026 10:13:38 +0800
Message-ID: <20260707021338.1182268-7-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260707021338.1182268-1-yi.zhang@huawei.com>
References: <20260707021338.1182268-1-yi.zhang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3SHShYkxqYSBRAQ--.61087S10
X-Coremail-Antispam: 1UD129KBjvJXoWxCFWfury8uFW3Xw1ktF4rAFb_yoW5ZryUpa
	yUAr1rGFyrWasa939avF4jvF1Yka48Gw4UZrWfWryjqan8Xr1FkFyaga4FvFWYqrW8XF4Y
	vr4Yy34DGw45ZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHmb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7Cj
	xVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrV
	C2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE
	7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjsIEF7I21c0EjII2zVCS5cI20VAGYxC7M4
	IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48J
	MxAIw28IcVAKzI0EY4vE52x082I5MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	-zstUUUUU==
Sender: yi.zhang@huaweicloud.com
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

In ext4_alloc_file_blocks(), the WRITE_ZEROES path converts unwritten
extents to written in one transaction while i_disksize is updated to
cover them only in a later transaction. A crash in between leaves
written extents beyond i_disksize on disk, which fsck will complain
about this.

Add the inode to the orphan list in the same handle that does the
conversion, and remove it once i_disksize has caught up. Fold
ext4_convert_unwritten_extents() into the same handle so the orphan
add and the conversion are atomic. Also add a check before conversion
to ensure the conversion does not extend beyond the end of the file.

Reported-by: Jan Kara <jack@suse.cz>
Closes: https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c083703bf704..8c7a98405a64 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4585,6 +4585,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	loff_t epos = 0, old_size = i_size_read(inode);
 	unsigned int blkbits = inode->i_blkbits;
 	bool alloc_zero = false;
+	bool orphan = false;
 
 	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
 	map.m_lblk = offset >> blkbits;
@@ -4659,12 +4660,30 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 
 		if (alloc_zero &&
 		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
+			WARN_ON_ONCE(map.m_lblk + map.m_len >
+				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
+
 			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
 						 map.m_len);
-			if (likely(!ret))
-				ret = ext4_convert_unwritten_extents(NULL,
+			if (unlikely(ret))
+				break;
+
+			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
+						    credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				break;
+			}
+
+			ret = ext4_convert_unwritten_extents(handle,
 					inode, (loff_t)map.m_lblk << blkbits,
 					(loff_t)map.m_len << blkbits);
+			if (!ret && new_size) {
+				ret = ext4_orphan_add(handle, inode);
+				orphan = true;
+			}
+			ret2 = ext4_journal_stop(handle);
+			ret = ret ? ret : ret2;
 			if (ret)
 				break;
 		}
@@ -4687,12 +4706,17 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	if (epos > new_size)
 		epos = new_size;
 
-	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
-	if (IS_ERR(handle))
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, 2);
+	if (IS_ERR(handle)) {
+		if (orphan && inode->i_nlink)
+			ext4_orphan_del(NULL, inode);
 		return ret ? ret : PTR_ERR(handle);
+	}
 
 	ext4_update_inode_size(inode, epos);
 	ret2 = ext4_mark_inode_dirty(handle, inode);
+	if (orphan && inode->i_nlink)
+		ext4_orphan_del(handle, inode);
 	ext4_update_inode_fsync_trans(handle, inode, 1);
 	ret3 = ext4_journal_stop(handle);
 	ret2 = ret3 ? ret3 : ret2;
-- 
2.52.0

