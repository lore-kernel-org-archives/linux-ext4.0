Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874453F39D7;
	Mon, 27 Jul 2026 10:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149748; cv=none; b=GVEc1NgqvFPclTFUlN0pFbgSJLtTeZ936Ig8IEhpN1PTrC0Po6uX4dxf0mz5hV+ty2YWgRB8mOqsVtJkUWl51Txu67HVOkW/geOYPRox1HXiHlI0m/n2eguvFya2stRYQl2gKjBpEhn6g0+acn8cX1y0aTinI4Xh1UT4IEmV++o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149748; c=relaxed/simple;
	bh=sii2WYQE4Uiwcc72+2LzCpg4MXAyox6Spc2KWPFGBqE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PU/SKcKgPD/uowXQ0FOgKhOj4y8E9CWT/a7OWzIdfEsMNC3Tw7rJhdqm07u6uNDF6wCJ4GYk4lPSwUn9KDFLauEG3jXKe8NEqvuwzXmCMmZi+uKeeK1SYTn+DVoVfUZKbWJ9KXdwVhL9mQGLf+T7KSAksISJKEEmjNapov8SxQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=QuLOiYmC; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="QuLOiYmC"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RANign477543;
	Mon, 27 Jul 2026 03:55:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=+IISunam4ZIemVqgX869SC093SFC/giuCEsixB9cjyI=; b=
	QuLOiYmCGDANtptKUXeWFkdR5MH6tejzRJdihcvQJkUMFrgScCjlAoQGaFISdTFU
	PHkVEmcS3NIRAYzobe76RduKRi3gIddiSo1tSKl9isuOT2VhpC6KVZMP8BHtB2H1
	BwC3uzekTzbFL0wnCwLNjJ8E4mjw5OYjcx10Cq97vhBa8u8PMrSYXgnPTVwibiRe
	CRY7FZuj4iFOuLtA6hPAgEV1djHKlYXgPrq+7us5XfknLG1039ojg/fw5CYh0TYt
	oPR68bJOBx9tYwORtsI5i/8QsJ02IbPat2K4jDbL6arSQSSZPFrdLduMw6+Eh/fy
	UZUoBwBq/QIQqvnxzDZc6g==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmvnf1r1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 27 Jul 2026 03:55:02 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 27 Jul 2026 03:55:01 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 27 Jul 2026 03:54:59 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [RFC PATCH 6/9] ext4: allocate block before destroying inline data in conversion
Date: Mon, 27 Jul 2026 18:54:38 +0800
Message-ID: <20260727105441.3213095-7-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727105441.3213095-1-yun.zhou@windriver.com>
References: <20260727105441.3213095-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX48fO6YJ9f1Yp
 ttxbfCIp5494aDPyZG5IOvqskP/7O6yZ9NO6u3dQCxbmcIa9eWldVEDWlwabnqYAgCa8MlgOHvH
 BiprDXB7pqqYwbq7x3v3HL/dOnF/xzmAi6n9Q9OhQrAao4Vfcn63
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfXynwUitVoKMkf
 Qa6wtabe4ltCTlZtIPfO4rrjPJycYk0fVJ7iTa9UgPJ+zjurWW8Zgr/JGjn/HTDv+bF6axEim6T
 V4aPBi5eI0q02z2eyypMb6fACyZMTstl/28a0/bFiOxsngJ0++cC91LBR8LrdezGHGY7lIwV0UD
 xBMtC9Y9qLEQzWfaQ7ySqY6z7sU0Ih/DPSZzMYbEG37AlTCV/WcroQfj4bZANh3Vr2SeyKrClB4
 lPAJdpDjbDHIHFY28xuDlTv5ZNEnjY23O3DPBJJHAs6+PcZaO1DMJF3bOcz8TXhxB3hQTWddsJL
 RfWR9GOO9lARHEGCfECRRYbGXAAm2EiocLYWeO101F3tsphF5y6MvV43F2DeTAktRI/kG1Wb004
 Hc5BAsZXC/xT2rLsJCTw97Betuq8HffOJi46ZfKJxFB7LM0QuI1sWGR74K1AkTburYxPtRL9L3C
 0h1Upsi/qZw6UNM1qrg==
X-Proofpoint-GUID: 3t00cYJ2OYRIM4AGUFVp-aaoD1fsp_L2
X-Authority-Analysis: v=2.4 cv=M7x97Sws c=1 sm=1 tr=0 ts=6a673906 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8 a=5p5saEN4i-Na5wO2IUIA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: 3t00cYJ2OYRIM4AGUFVp-aaoD1fsp_L2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270106

Rework ext4_convert_inline_data_nolock() to allocate and write the
data block before destroying inline data.  Previously, the function
destroyed inline data first, then tried to allocate a block.  If
allocation failed, it attempted to restore the inline data -- which
could itself fail, leading to data loss or BUG_ON from inconsistent
inode state.

The new approach:
1. Read inline data into a buffer
2. Allocate a physical block (ext4_new_meta_blocks)
3. Write the data to the allocated block
4. Only after success: destroy inline data
5. Insert the pre-allocated block into the extent tree

On failure before destroy, the inline data is untouched and we simply
free the allocated block.  No restore needed.

Remove now-dead code: ext4_restore_inline_data(), ext4_write_inline_data().

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/inline.c | 136 ++++++++++++++++-------------------------------
 1 file changed, 47 insertions(+), 89 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 5c6202add3d8..ebbb9b29e3e1 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -12,6 +12,7 @@
 
 #include "ext4_jbd2.h"
 #include "ext4.h"
+#include "ext4_extents.h"
 #include "xattr.h"
 #include "truncate.h"
 
@@ -218,51 +219,6 @@ static int ext4_read_inline_data(struct inode *inode, void *buffer,
 	return cp_len;
 }
 
-/*
- * write the buffer to the inline inode.
- * If 'create' is set, we don't need to do the extra copy in the xattr
- * value since it is already handled by ext4_xattr_ibody_set.
- * That saves us one memcpy.
- */
-static void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
-				   void *buffer, loff_t pos, unsigned int len)
-{
-	struct ext4_xattr_entry *entry;
-	struct ext4_xattr_ibody_header *header;
-	struct ext4_inode *raw_inode;
-	int cp_len = 0;
-
-	if (unlikely(ext4_emergency_state(inode->i_sb)))
-		return;
-
-	BUG_ON(!EXT4_I(inode)->i_inline_off);
-	BUG_ON(pos + len > EXT4_I(inode)->i_inline_size);
-
-	raw_inode = ext4_raw_inode(iloc);
-	buffer += pos;
-
-	if (pos < EXT4_MIN_INLINE_DATA_SIZE) {
-		cp_len = pos + len > EXT4_MIN_INLINE_DATA_SIZE ?
-			 EXT4_MIN_INLINE_DATA_SIZE - pos : len;
-		memcpy((void *)raw_inode->i_block + pos, buffer, cp_len);
-
-		len -= cp_len;
-		buffer += cp_len;
-		pos += cp_len;
-	}
-
-	if (!len)
-		return;
-
-	pos -= EXT4_MIN_INLINE_DATA_SIZE;
-	header = IHDR(inode, raw_inode);
-	entry = (struct ext4_xattr_entry *)((void *)raw_inode +
-					    EXT4_I(inode)->i_inline_off);
-
-	memcpy((void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs) + pos,
-	       buffer, len);
-}
-
 static int ext4_create_inline_data(handle_t *handle,
 				   struct inode *inode, unsigned len)
 {
@@ -791,23 +747,6 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
 	return 0;
 }
 
-static void ext4_restore_inline_data(handle_t *handle, struct inode *inode,
-				     struct ext4_iloc *iloc,
-				     void *buf, int inline_size)
-{
-	int ret;
-
-	ret = ext4_create_inline_data(handle, inode, inline_size);
-	if (ret) {
-		ext4_msg(inode->i_sb, KERN_EMERG,
-			"error restoring inline_data for inode -- potential data loss! (inode %llu, error %d)",
-			inode->i_ino, ret);
-		return;
-	}
-	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
-	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
-}
-
 static int ext4_convert_inline_data_nolock(handle_t *handle,
 					   struct inode *inode,
 					   struct ext4_iloc *iloc)
@@ -815,7 +754,7 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 	int error;
 	void *buf = NULL;
 	struct buffer_head *data_bh = NULL;
-	struct ext4_map_blocks map;
+	ext4_fsblk_t pblk;
 	int inline_size;
 
 	inline_size = ext4_get_inline_size(inode);
@@ -841,25 +780,20 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 			goto out;
 	}
 
-	error = ext4_destroy_inline_data_nolock(handle, inode);
+	/*
+	 * Allocate a data block and write the inline data to it before
+	 * destroying the inline data.  This ensures that on failure we
+	 * can simply free the allocated block without needing to restore
+	 * the inline data.
+	 */
+	pblk = ext4_new_meta_blocks(handle, inode, 0, 0, NULL, &error);
 	if (error)
 		goto out;
 
-	map.m_lblk = 0;
-	map.m_len = 1;
-	map.m_flags = 0;
-	error = ext4_map_blocks(handle, inode, &map, EXT4_GET_BLOCKS_CREATE);
-	if (error < 0)
-		goto out_restore;
-	if (!(map.m_flags & EXT4_MAP_MAPPED)) {
-		error = -EIO;
-		goto out_restore;
-	}
-
-	data_bh = sb_getblk(inode->i_sb, map.m_pblk);
+	data_bh = sb_getblk(inode->i_sb, pblk);
 	if (!data_bh) {
 		error = -ENOMEM;
-		goto out_restore;
+		goto out_free_block;
 	}
 
 	lock_buffer(data_bh);
@@ -867,8 +801,7 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 					       EXT4_JTR_NONE);
 	if (error) {
 		unlock_buffer(data_bh);
-		error = -EIO;
-		goto out_restore;
+		goto out_free_block;
 	}
 	memset(data_bh->b_data, 0, inode->i_sb->s_blocksize);
 
@@ -876,26 +809,51 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 		memcpy(data_bh->b_data, buf, inline_size);
 		set_buffer_uptodate(data_bh);
 		unlock_buffer(data_bh);
-		error = ext4_handle_dirty_metadata(handle,
-						   inode, data_bh);
+		error = ext4_handle_dirty_metadata(handle, inode, data_bh);
 	} else {
 		unlock_buffer(data_bh);
-		inode->i_size = inode->i_sb->s_blocksize;
-		i_size_write(inode, inode->i_sb->s_blocksize);
-		EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-
 		error = ext4_init_dirblock(handle, inode, data_bh,
 			  le32_to_cpu(((struct ext4_dir_entry_2 *)buf)->inode),
 			  buf + EXT4_INLINE_DOTDOT_SIZE,
 			  inline_size - EXT4_INLINE_DOTDOT_SIZE);
-		if (!error)
-			error = ext4_mark_inode_dirty(handle, inode);
 	}
+	if (error)
+		goto out_free_block;
 
-out_restore:
+	/*
+	 * Data is safely in the allocated block.  Now destroy the inline
+	 * data (which also initializes the extent tree via
+	 * ext4_ext_tree_init) and then insert the pre-allocated block.
+	 */
+	error = ext4_destroy_inline_data_nolock(handle, inode);
 	if (error)
-		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
+		goto out_free_block;
+
+	if (S_ISDIR(inode->i_mode)) {
+		inode->i_size = inode->i_sb->s_blocksize;
+		i_size_write(inode, inode->i_sb->s_blocksize);
+		EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
+	}
+
+	/* Insert the pre-allocated block into the extent tree */
+	if (ext4_has_feature_extents(inode->i_sb)) {
+		struct ext4_extent_header *eh = ext_inode_hdr(inode);
+		struct ext4_extent *ex = EXT_FIRST_EXTENT(eh);
+
+		ex->ee_block = cpu_to_le32(0);
+		ex->ee_len = cpu_to_le16(1);
+		ext4_ext_store_pblock(ex, pblk);
+		eh->eh_entries = cpu_to_le16(1);
+	} else {
+		/* indirect mapping: set i_data[0] directly */
+		EXT4_I(inode)->i_data[0] = cpu_to_le32(pblk);
+	}
+
+	error = ext4_mark_inode_dirty(handle, inode);
+	goto out;
 
+out_free_block:
+	ext4_free_blocks(handle, inode, NULL, pblk, 1, 0);
 out:
 	brelse(data_bh);
 	kfree(buf);
-- 
2.43.0

