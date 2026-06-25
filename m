Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5995A175A66;
	Thu, 25 Jun 2026 15:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782401734; cv=none; b=PD5IBgumIWQpzkofDgDEieNoEeHQoxt3AXTmn6eRfXG4at9IUoRsWvL+NeIcMyCyXYZJtwe5UI+IIaNKzOED5IPguUTS+X9r/QrWo9nYjM5EyIj0lbaFLfiJne7c86CqsvmpDeZQOxHl4kxiS35RLcZBVES94EWCxA2RI4/JWnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782401734; c=relaxed/simple;
	bh=Et3TtpFrHjQI7w8PIYbEUEZyW2HwUqHqRZ8Hvnf2DzY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NVOCJus5vdQ4nJiQ1Nx4ksqo/xKWV22rNqdch3TLyo4k80IzvbtIv+rJ60Nvllda2qMiohS+qV3VDvylyfd70MfATmgZ1eVR67snEdRAtszFKDeaYpJYSzhjIJ12JXffld6ldrwhmzcbDpF9Q9QhPT8dcnfuBF+WdqUsp8DPJgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=ee9dOO5a; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="ee9dOO5a"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65P4qur2465947;
	Thu, 25 Jun 2026 15:30:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=py38bHvAHJvAeiZv/r40O8xm67xMaIUVLj0j0lC+WNE=; b=
	ee9dOO5aqTAFMZ38+j2NGw9SCpF0viKxPi1QeWvDe1Ac4GyrRaMiOdsQYYVTyntx
	39KtG/HDc7bb78EQc4yj2/4LuMzmU1Tn5WQTPaM6LXYTfeeP9dCHFJj5LgUXOg0Y
	2BUTL+ivia5XIRZKPq3RgcayIF8W/RcwmFgikt09lqcUpMsmTqvQ9taOydXCEoIP
	aJ1BNflbgCjKlAGNn54iwpssVlkakGR8E7Gu7+rqGwRt4oOIIux5lQ46Z3W2i2Ly
	p1XSB60EXZ1Ju67CD/CiV5unO3S4Q+rz25N1QCYA4hn6KpBAGVN1lALkAUoTyVR7
	I146YoHh8vAxN8mTZtLhKw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f0t2c8vam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 25 Jun 2026 15:30:07 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 25 Jun 2026 08:30:03 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 25 Jun 2026 08:30:00 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v10 5/5] ext4: prevent deadlock from duplicate EA inode references on corrupted fs
Date: Thu, 25 Jun 2026 23:29:41 +0800
Message-ID: <20260625152941.24788-6-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625152941.24788-1-yun.zhou@windriver.com>
References: <20260625152941.24788-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDEzMyBTYWx0ZWRfXwQawlRtnLqa9
 uhql1phXjdkmsTTi3NLI066J/XtGZCyXURKCdp7f0P1X0tmz+8LkWtMsw/So7Oe/FqNuwg/I1ZQ
 iB4dtRpPYAGqOIJBfXaYKT/8iz8Soc31vdJx3FYwRjrGzon8A5HlAXn1CeTYAmChX/VRws+dKQT
 f3yh48dE3sln92fxJMOTuentTj1XNM7ioXpPwS97mox3bDbxtWd01lVA0Tp+xyOHIuSjWCK6ISx
 XvWS3meo8iASdrGFQ9TFDaabN96aB4j6fRXaDVBdcSJTOrcRqKml4496g4nwe5b7zEPpgKtIIFv
 vxxvhs4zOh2vDPxSTQSHyEYMJbw94PlrTjCnKOZzo2fFbpdvQE+brqyx2N9jTOaW81Vl3+oTQT7
 8zQnwQzsEav1415jMNaSqQm5BTwqbHgzHTN8EifMJpo8rj6bH3MWmfQxkFeE/LG/WWA5Jh22yZk
 A2X7yN8mfWUp3p0QbZA==
X-Proofpoint-GUID: 6ZKAIyUlbKGfxEiFXSdguEVbusxjO8XB
X-Proofpoint-ORIG-GUID: 6ZKAIyUlbKGfxEiFXSdguEVbusxjO8XB
X-Authority-Analysis: v=2.4 cv=U4Oiy+ru c=1 sm=1 tr=0 ts=6a3d497f cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=Ysc6yqohfg-ZzZjRp7kA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDEzMyBTYWx0ZWRfX2oquDtXCluNa
 IS00Vi4ZjhRl2OlBz+PHeU1NjBn8/A7Z7hpuy1CxigwOHOZdsSPZLaMIeZhBzoe5iTxoEmIk2fu
 XwiwYl1Nd9pOI5W8kFywBAbLq73JQbo1Mq8krdAIH+yYQGpa0GT5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_01,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 adultscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606250133

On a corrupted filesystem, multiple xattr entries may reference the same
EA inode.  When ext4_xattr_inode_dec_ref_all() processes such entries, it
can dec_ref the EA inode (setting nlink=0) and queue it for deferred iput.
If the deferred worker runs before the loop processes the duplicate entry,
the second iget() may block on I_FREEING while the worker's eviction waits
for the caller's transaction to commit -- classic ABBA deadlock.

Fix by tracking successfully processed EA inodes on a per-call llist
(reusing i_ea_iput_node) and skipping any ea_ino already in the list.
This covers both intra-block duplicates and cross ibody/block duplicates
in ext4_xattr_delete_inode().

The actual ext4_put_ea_inode() is deferred until after the processing
loop completes (ext4_put_ea_inode_llist), ensuring no EA inode is queued
for eviction while the loop is still iterating.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/xattr.c | 68 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 61 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7f334349bd4f..5c929043e44a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1152,11 +1152,41 @@ static int ext4_xattr_restart_fn(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
+/* Check if an EA inode number is already in the processed llist. */
+static bool ext4_ea_ino_in_llist(unsigned int ea_ino,
+				 struct llist_head *processed)
+{
+	struct ext4_inode_info *ei;
+
+	llist_for_each_entry(ei, processed->first, i_ea_iput_node) {
+		if (ei->vfs_inode.i_ino == ea_ino)
+			return true;
+	}
+	return false;
+}
+
+/* Put all EA inodes on a processed llist via ext4_put_ea_inode. */
+static void ext4_put_ea_inode_llist(struct super_block *sb,
+				    struct llist_head *processed)
+{
+	struct llist_node *node = llist_del_all(processed);
+	struct llist_node *next;
+
+	while (node) {
+		struct ext4_inode_info *ei = container_of(node,
+				struct ext4_inode_info, i_ea_iput_node);
+		next = node->next;
+		ext4_put_ea_inode(sb, &ei->vfs_inode);
+		node = next;
+	}
+}
+
 static void
 ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 			     struct buffer_head *bh,
 			     struct ext4_xattr_entry *first, bool block_csum,
-			     int extra_credits, bool skip_quota)
+			     int extra_credits, bool skip_quota,
+			     struct llist_head *processed)
 {
 	struct inode *ea_inode;
 	struct ext4_xattr_entry *entry;
@@ -1186,6 +1216,11 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (!entry->e_value_inum)
 			continue;
 		ea_ino = le32_to_cpu(entry->e_value_inum);
+
+		/* Skip if already processed (duplicate on corrupted fs) */
+		if (ext4_ea_ino_in_llist(ea_ino, processed))
+			continue;
+
 		err = ext4_xattr_inode_iget(parent, ea_ino,
 					    le32_to_cpu(entry->e_hash),
 					    &ea_inode);
@@ -1235,7 +1270,12 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		entry->e_value_inum = 0;
 		entry->e_value_size = 0;
 
-		ext4_put_ea_inode(parent->i_sb, ea_inode);
+		/*
+		 * Collect processed EA inodes for dedup and deferred iput.
+		 * ext4_put_ea_inode_llist() handles the actual release
+		 * after the loop, preventing iget deadlocks on duplicates.
+		 */
+		llist_add(&EXT4_I(ea_inode)->i_ea_iput_node, processed);
 		dirty = true;
 	}
 
@@ -1262,7 +1302,8 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 static void
 ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 			 struct buffer_head *bh,
-			 int extra_credits)
+			 int extra_credits,
+			 struct llist_head *processed)
 {
 	struct mb_cache *ea_block_cache = EA_BLOCK_CACHE(inode);
 	u32 hash, ref;
@@ -1304,7 +1345,8 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 						     BFIRST(bh),
 						     true /* block_csum */,
 						     extra_credits,
-						     true /* skip_quota */);
+						     true /* skip_quota */,
+						     processed);
 		ext4_free_blocks(handle, inode, bh, 0, 1,
 				 EXT4_FREE_BLOCKS_METADATA |
 				 EXT4_FREE_BLOCKS_FORGET);
@@ -2171,8 +2213,12 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 	/* Drop the previous xattr block. */
 	if (bs->bh && bs->bh != new_bh) {
+		LLIST_HEAD(processed);
+
 		ext4_xattr_release_block(handle, inode, bs->bh,
-					 0 /* extra_credits */);
+					 0 /* extra_credits */,
+					 &processed);
+		ext4_put_ea_inode_llist(inode->i_sb, &processed);
 	}
 	error = 0;
 
@@ -2866,6 +2912,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 	struct ext4_xattr_entry *entry;
 	struct inode *ea_inode;
 	int error;
+	LLIST_HEAD(processed);
 
 	error = ext4_journal_ensure_credits(handle, extra_credits,
 			ext4_free_metadata_revoke_credits(inode->i_sb, 1));
@@ -2897,7 +2944,8 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 						     IFIRST(header),
 						     false /* block_csum */,
 						     extra_credits,
-						     false /* skip_quota */);
+						     false /* skip_quota */,
+						     &processed);
 	}
 
 	if (EXT4_I(inode)->i_file_acl) {
@@ -2921,6 +2969,11 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 			     entry = EXT4_XATTR_NEXT(entry)) {
 				if (!entry->e_value_inum)
 					continue;
+				/* Skip EA inodes already dec_ref'd from ibody */
+				if (ext4_ea_ino_in_llist(
+					    le32_to_cpu(entry->e_value_inum),
+					    &processed))
+					continue;
 				error = ext4_xattr_inode_iget(inode,
 					      le32_to_cpu(entry->e_value_inum),
 					      le32_to_cpu(entry->e_hash),
@@ -2935,7 +2988,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 		}
 
 		ext4_xattr_release_block(handle, inode, bh,
-					 extra_credits);
+					 extra_credits, &processed);
 		/*
 		 * Update i_file_acl value in the same transaction that releases
 		 * block.
@@ -2951,6 +3004,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 	}
 	error = 0;
 cleanup:
+	ext4_put_ea_inode_llist(inode->i_sb, &processed);
 	brelse(iloc.bh);
 	brelse(bh);
 	return error;
-- 
2.43.0

