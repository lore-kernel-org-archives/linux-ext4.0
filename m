Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90663EC2F5;
	Tue, 30 Jun 2026 10:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814161; cv=none; b=DAvSXYk2nVM85M9iJhKfoaXooubQ7B3QHLGefYCMY8jbKZddZLRYyHS0oC80/1NVOx1CsTTc8S1AjV+jvwELCzPStj12oWMTu1dxXo0D9TXwUp1O0PT2cGkj7u39z7E4/FDQIl/ZzrmfB6ZPd5VoI+kJ1j6ZC8EuMS4nZFkU6tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814161; c=relaxed/simple;
	bh=SOf7QzaOdKb5UDC5ib22qQNoRljcias0Iyk9mez5TlU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKaXRUaKDNp2tLvbIKP+MR5eALe8QmVouxTutw7kbg8lWHop7pP94a+BLoRZATlz5psNvtx3mYusbgA6+PoSh+1fZ8TGCUYfqb5sSwPV55/MW1/SZRV92n408hxdERfNq4E5QK+HQh0U9FPPxclDFCgz7DC/YZdz9W8mHwqEuLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=kwSWFV1w; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="kwSWFV1w"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U9ouNK699109;
	Tue, 30 Jun 2026 10:08:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=49PQtnUUgJMDnBTi8inNSLjUToxTS2gPArRnSjk6vds=; b=
	kwSWFV1wa2JHv87fcdgJAWfJv80aI/Ed/U5meTIv077LzBImrhNCHaFhlxiVIk+U
	1RCx3vzWl5JlTfb3S5mdlPvpqnSW5J71rff/EQ31ALJrg2NTKMQq7DD2mwJcNnZJ
	DoZgN+7cwhv5qWHceyPCleN1OqFnsu9BY5k7cp2l4BXtskWTZikyBe3rJBuIfXm/
	9wTokDXCJqymHvLP8IPHcIIg+On0SJVbJkK0fB3YM/EVdNxAa+5wCId+dJkZS1qY
	+9ievjtSwijsMRjqkU+MYYBcWAlOJv5mIlyncMxMqigaGKEvLl1vkE59bZGCBa+Z
	gZ5s8jK5WYzRvNbrSlub7w==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f25g5knsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 30 Jun 2026 10:08:48 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 30 Jun 2026 03:08:46 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 30 Jun 2026 03:08:43 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v12 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()
Date: Tue, 30 Jun 2026 18:08:29 +0800
Message-ID: <20260630100829.1257618-5-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630100829.1257618-1-yun.zhou@windriver.com>
References: <20260630100829.1257618-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDA5MSBTYWx0ZWRfXyRL4CMqJKfQ8
 8phiN+bEaJqCJdjPqjstAOLpumTW3DZKUG0bzvlTUaRMrW8z29kgHL9hvRnvxJqnug/bxY64zUA
 iIgCeiMotrY45XK8e95ZqhowL36STeLwwpiS4TWO/eTA0Z5BLsDQ
X-Proofpoint-ORIG-GUID: znh6L-amhI4wgJ3N1guCTuOpGsFQLg7c
X-Proofpoint-GUID: znh6L-amhI4wgJ3N1guCTuOpGsFQLg7c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDA5MSBTYWx0ZWRfX3cBIW/oWuA73
 rXwEdMQyYKA7fgFMqnj/p8cvg+/G6B1IszRO0UJs5bdsWUPy/pRJgbbas/C1lNW9dDToCE3jZ0p
 kG2UkjWJhTY/N1F0tswFKP0+Fx8In50GXE+FK1bNXeJQ3Ogtsxh6tKvqSzo9uy6dicZSjy7af12
 UPAk9lD+DKO64twA8uaJgp4OX6kZg2o3x9m9iWRZKMnIe2woxMq8c4+xKx03gcJcuIfMu1zg6So
 p/iFO5D9QqoB85DJ86W8jMMFIbzU9z3PUBR/kkz/ESIZg/IRpoBGZ4G4LE3wSB2fmP7miBnRJxU
 KTfqFfJJTRwOjc+SzKGexhruRoTPInn4qmTjInLQ8Qsr9v4rkaHbfxj+Aw7saTDf90Woc23plf/
 ksJpkJhSnxUXkY3QwCbnM48Ylo2t3RAL+KdnHY6JvtQTbeKoVDNNCFgpwJrywC5bjSoNI0NlQ32
 n37RCN7hB33gp3XmZhg==
X-Authority-Analysis: v=2.4 cv=TvLWQjXh c=1 sm=1 tr=0 ts=6a4395b0 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=t7CeM3EgAAAA:8 a=EeJwDUQJ61IywSGq5aMA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606300091

Now that ext4_put_ea_inode() handles deferred iput safely for all cases
(using iput_if_not_last + embedded llist_node), the ea_inode_array
mechanism for batching deferred iputs is redundant.

Remove:
- ext4_expand_inode_array() and ext4_xattr_inode_array_free()
- struct ext4_xattr_inode_array and EIA_INCR/EIA_MASK defines
- ea_inode_array parameter from ext4_xattr_inode_dec_ref_all(),
  ext4_xattr_release_block(), and ext4_xattr_delete_inode()
- ea_inode_array variable from ext4_evict_inode()

Instead, ext4_xattr_inode_dec_ref_all() now calls ext4_put_ea_inode()
directly after processing each EA inode.  This simplifies the code
by eliminating multi-layer parameter threading and removes the need
for callers to manage array lifetime.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |  6 +---
 fs/ext4/xattr.c | 80 ++++---------------------------------------------
 fs/ext4/xattr.h |  7 -----
 3 files changed, 6 insertions(+), 87 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0d131371ad3d..6f1b84e46a2e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -176,7 +176,6 @@ void ext4_evict_inode(struct inode *inode)
 	 * (xattr block freeing), bitmap, group descriptor (inode freeing)
 	 */
 	int extra_credits = 6;
-	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 	bool freeze_protected = false;
 
 	trace_ext4_evict_inode(inode);
@@ -282,8 +281,7 @@ void ext4_evict_inode(struct inode *inode)
 	}
 
 	/* Remove xattr references. */
-	err = ext4_xattr_delete_inode(handle, inode, &ea_inode_array,
-				      extra_credits);
+	err = ext4_xattr_delete_inode(handle, inode, extra_credits);
 	if (err) {
 		ext4_warning(inode->i_sb, "xattr delete (err %d)", err);
 stop_handle:
@@ -291,7 +289,6 @@ void ext4_evict_inode(struct inode *inode)
 		ext4_orphan_del(NULL, inode);
 		if (freeze_protected)
 			sb_end_intwrite(inode->i_sb);
-		ext4_xattr_inode_array_free(ea_inode_array);
 		goto no_delete;
 	}
 
@@ -321,7 +318,6 @@ void ext4_evict_inode(struct inode *inode)
 	ext4_journal_stop(handle);
 	if (freeze_protected)
 		sb_end_intwrite(inode->i_sb);
-	ext4_xattr_inode_array_free(ea_inode_array);
 	return;
 no_delete:
 	/*
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 6a1f2bdb6ff8..4ae6ce111566 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -114,10 +114,6 @@ const struct xattr_handler * const ext4_xattr_handlers[] = {
 #define EA_INODE_CACHE(inode)	(((struct ext4_sb_info *) \
 				inode->i_sb->s_fs_info)->s_ea_inode_cache)
 
-static int
-ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
-			struct inode *inode);
-
 #ifdef CONFIG_LOCKDEP
 void ext4_xattr_inode_set_class(struct inode *ea_inode)
 {
@@ -1160,7 +1156,6 @@ static void
 ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 			     struct buffer_head *bh,
 			     struct ext4_xattr_entry *first, bool block_csum,
-			     struct ext4_xattr_inode_array **ea_inode_array,
 			     int extra_credits, bool skip_quota)
 {
 	struct inode *ea_inode;
@@ -1197,14 +1192,6 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err)
 			continue;
 
-		err = ext4_expand_inode_array(ea_inode_array, ea_inode);
-		if (err) {
-			ext4_warning_inode(ea_inode,
-					   "Expand inode array err=%d", err);
-			ext4_put_ea_inode(ea_inode);
-			continue;
-		}
-
 		err = ext4_journal_ensure_credits_fn(handle, credits, credits,
 			ext4_free_metadata_revoke_credits(parent->i_sb, 1),
 			ext4_xattr_restart_fn(handle, parent, bh, block_csum,
@@ -1212,6 +1199,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err < 0) {
 			ext4_warning_inode(ea_inode, "Ensure credits err=%d",
 					   err);
+			ext4_put_ea_inode(ea_inode);
 			continue;
 		}
 		if (err > 0) {
@@ -1221,6 +1209,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 				ext4_warning_inode(ea_inode,
 						"Re-get write access err=%d",
 						err);
+				ext4_put_ea_inode(ea_inode);
 				continue;
 			}
 		}
@@ -1229,6 +1218,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err) {
 			ext4_warning_inode(ea_inode, "ea_inode dec ref err=%d",
 					   err);
+			ext4_put_ea_inode(ea_inode);
 			continue;
 		}
 
@@ -1245,6 +1235,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		entry->e_value_inum = 0;
 		entry->e_value_size = 0;
 
+		ext4_put_ea_inode(ea_inode);
 		dirty = true;
 	}
 
@@ -1271,7 +1262,6 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 static void
 ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 			 struct buffer_head *bh,
-			 struct ext4_xattr_inode_array **ea_inode_array,
 			 int extra_credits)
 {
 	struct mb_cache *ea_block_cache = EA_BLOCK_CACHE(inode);
@@ -1313,7 +1303,6 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_dec_ref_all(handle, inode, bh,
 						     BFIRST(bh),
 						     true /* block_csum */,
-						     ea_inode_array,
 						     extra_credits,
 						     true /* skip_quota */);
 		ext4_free_blocks(handle, inode, bh, 0, 1,
@@ -2182,12 +2171,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 	/* Drop the previous xattr block. */
 	if (bs->bh && bs->bh != new_bh) {
-		struct ext4_xattr_inode_array *ea_inode_array = NULL;
-
 		ext4_xattr_release_block(handle, inode, bs->bh,
-					 &ea_inode_array,
 					 0 /* extra_credits */);
-		ext4_xattr_inode_array_free(ea_inode_array);
 	}
 	error = 0;
 
@@ -2863,46 +2848,6 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	return error;
 }
 
-#define EIA_INCR 16 /* must be 2^n */
-#define EIA_MASK (EIA_INCR - 1)
-
-/* Add the large xattr @inode into @ea_inode_array for deferred iput().
- * If @ea_inode_array is new or full it will be grown and the old
- * contents copied over.
- */
-static int
-ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
-			struct inode *inode)
-{
-	if (*ea_inode_array == NULL) {
-		/*
-		 * Start with 15 inodes, so it fits into a power-of-two size.
-		 */
-		(*ea_inode_array) = kmalloc_flex(**ea_inode_array, inodes,
-						 EIA_MASK, GFP_NOFS);
-		if (*ea_inode_array == NULL)
-			return -ENOMEM;
-		(*ea_inode_array)->count = 0;
-	} else if (((*ea_inode_array)->count & EIA_MASK) == EIA_MASK) {
-		/* expand the array once all 15 + n * 16 slots are full */
-		struct ext4_xattr_inode_array *new_array = NULL;
-
-		new_array = kmalloc_flex(**ea_inode_array, inodes,
-					 (*ea_inode_array)->count + EIA_INCR,
-					 GFP_NOFS);
-		if (new_array == NULL)
-			return -ENOMEM;
-		memcpy(new_array, *ea_inode_array,
-		       struct_size(*ea_inode_array, inodes,
-				   (*ea_inode_array)->count));
-		kfree(*ea_inode_array);
-		*ea_inode_array = new_array;
-	}
-	(*ea_inode_array)->count++;
-	(*ea_inode_array)->inodes[(*ea_inode_array)->count - 1] = inode;
-	return 0;
-}
-
 /*
  * ext4_xattr_delete_inode()
  *
@@ -2913,7 +2858,6 @@ ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
  * references on xattr block and xattr inodes.
  */
 int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
-			    struct ext4_xattr_inode_array **ea_inode_array,
 			    int extra_credits)
 {
 	struct buffer_head *bh = NULL;
@@ -2952,7 +2896,6 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_dec_ref_all(handle, inode, iloc.bh,
 						     IFIRST(header),
 						     false /* block_csum */,
-						     ea_inode_array,
 						     extra_credits,
 						     false /* skip_quota */);
 	}
@@ -2991,7 +2934,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 
 		}
 
-		ext4_xattr_release_block(handle, inode, bh, ea_inode_array,
+		ext4_xattr_release_block(handle, inode, bh,
 					 extra_credits);
 		/*
 		 * Update i_file_acl value in the same transaction that releases
@@ -3013,19 +2956,6 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 	return error;
 }
 
-void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *ea_inode_array)
-{
-	int idx;
-
-	if (ea_inode_array == NULL)
-		return;
-
-	for (idx = 0; idx < ea_inode_array->count; ++idx)
-		iput(ea_inode_array->inodes[idx]);
-	kfree(ea_inode_array);
-}
-
-
 /*
  * Worker function for deferred EA inode iput.  Processes all inodes queued
  * on s_ea_inode_to_free in a context free of xattr_sem/jbd2 handle locks.
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 2ff4b6eccd40..821dc6a50e51 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -131,11 +131,6 @@ struct ext4_xattr_ibody_find {
 	struct ext4_iloc iloc;
 };
 
-struct ext4_xattr_inode_array {
-	unsigned int count;
-	struct inode *inodes[] __counted_by(count);
-};
-
 extern const struct xattr_handler ext4_xattr_user_handler;
 extern const struct xattr_handler ext4_xattr_trusted_handler;
 extern const struct xattr_handler ext4_xattr_security_handler;
@@ -187,9 +182,7 @@ extern int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
 				bool is_create);
 
 extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
-				   struct ext4_xattr_inode_array **array,
 				   int extra_credits);
-extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
 extern void ext4_init_ea_inode_work(struct ext4_sb_info *sbi);
 extern void ext4_put_ea_inode(struct inode *inode);
 
-- 
2.43.0

