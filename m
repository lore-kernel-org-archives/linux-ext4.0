Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20963CF207;
	Tue, 23 Jun 2026 08:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782204813; cv=none; b=Eb2GwL2iyE8G5t8QRUF8UNYFido1T1FSa33NRokZF0uCD5N4ZxXFh+nJBz8gw/9TrVWGgWdP9qsgP21FKAnMimHeLJ5sxUkgIvodLjAMb1TyOou56ZbrdW8TynLNazVoaH+TNwXG6OEHitQkgIrxS6VH+PEXWODWlrZ/kbcwVI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782204813; c=relaxed/simple;
	bh=Oxkhy3YsiODoXLhVxfcpaI5I5l5sMPy/erQ5NMoFIYI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AyYvRCMtDAdTlTeyC7zZeIvUS8OLQ9Rat7n6ukM9nwFUJ2vHEIeNeIMGr6Gz6oc63R6rvfAEIdrbiEjQiZLgQyJryxJ5/TvLuSnIsKWEN6O7nWmGUGgf7+ArIeoazp4V+1lbFhfbuaJU1uF5uoQBPFGUp+POKYb+QhxU1q1kbrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=KlZ7dP1w; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="KlZ7dP1w"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N6kgfJ3332862;
	Tue, 23 Jun 2026 08:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=DtNbKaD2b2jujnKV7hbUi1BS3lYR7NNecpqJg17zR8Q=; b=
	KlZ7dP1wwAYfEHmBAXE5OZc7zZXQ+fg0pKwKmxP5G5XlnFsuEsg+notnNKssePzL
	zSFtKgBko66ho1A+iC/OSIQs/hylgObNwRqlPtft3HDlfYPLCV9HxlLrMDJ1t/C6
	A20kQB6UFwsJZJeoXeJQgM/IR/gV9GWXxZMSCrvQoOXBrkSXMdt9mujiyL/b4VKO
	rg34/1mNuuF+eB43CYldcNlVi8s3WgCw9B/EBLQ46uaHWtr5dT0MJ77/prx+1yj/
	fWQ3z+3BOa22R/5SR6O+CvxEAeisCSoVfqN1TyRWZfNtu0OXwV3m27Yt1q3aOosw
	yKiT+Af8cS8C+MOJZn5cKA==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wu86d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 23 Jun 2026 08:53:01 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 23 Jun 2026 01:53:00 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 23 Jun 2026 01:52:57 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yun.zhou@windriver.com>
Subject: [PATCH v9 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()
Date: Tue, 23 Jun 2026 16:52:43 +0800
Message-ID: <20260623085243.2816425-5-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623085243.2816425-1-yun.zhou@windriver.com>
References: <20260623083540.2744885-5-yun.zhou@windriver.com>
 <20260623085243.2816425-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: oKcbog36E7oUL5w2OZwt_HO5e7YpqCpG
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a3a496e cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=9aDgUxOzpnIOwVdy1lkA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: oKcbog36E7oUL5w2OZwt_HO5e7YpqCpG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA3MCBTYWx0ZWRfX5p78IDGvNZxx
 3GeQCEURSXG8KU2ZprGVdPMoBwWV3cKZcduGZpsC+nFDY0mOHrLL7gq6b+7SvZCkXgLACIobpBV
 BncEa9ROsR+EmZm//h8tbxCtZkIr1+XjlScs14jF0mO6TVrr4L5t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA3MCBTYWx0ZWRfX8L7Nrv43NvNx
 BGgdAHQ1+NYrwnEK9LK7yDg4EQWmj/3wSnd3f5TgRV0QqovNnyzgt8rVqkbomd7zXrEz38F/FXX
 fg9bPpJwEF0ytKVeSbbDhPosP0RGTw42mJfE0XxCvZ/gm8mr6K4PhZMe/xRcugdVTogMWhJ7q/q
 /sY1Hi7s1TCmAoIVhT4Bnj048l/MJ0fPn5eTL0xvjSxUXIYH/Y+4+BrlHAmfKbXPLM1v79SPp8S
 1QqlHi9K+PxX6zzJQYZElK+OGTRdRvp2TKd0rc9Sxcyhipm43k9H+ER+BHIA2xfZkHhy/nIGa6/
 oiudhc7GFQdmFZUPpOXdOA3BgyAKIXbC+oVYj8qBcHO7PpqRPtu+b+bdqkicJQPcVbFL+6bziYX
 M++JY1OFnlRSDokxOgLHe/9/NEPrXg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 classifier=typeunknown authscore=0 authtc=
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.22.0-2606150000 definitions=main-2606230070

Now that ext4_put_ea_inode() handles deferred iput safely for all cases
(using iput_if_not_last + embedded llist_node), the ea_inode_array
mechanism for batching deferred iputs is redundant.

Remove:
- ext4_expand_inode_array() and ext4_xattr_inode_array_free()
- ext4_xattr_inode_array_free_deferred()
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
---
 fs/ext4/inode.c |  6 +---
 fs/ext4/xattr.c | 95 +++----------------------------------------------
 fs/ext4/xattr.h |  7 ----
 3 files changed, 6 insertions(+), 102 deletions(-)

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
index 90b693b78a45..7f334349bd4f 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -114,12 +114,6 @@ const struct xattr_handler * const ext4_xattr_handlers[] = {
 #define EA_INODE_CACHE(inode)	(((struct ext4_sb_info *) \
 				inode->i_sb->s_fs_info)->s_ea_inode_cache)
 
-static int
-ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
-			struct inode *inode);
-static void ext4_xattr_inode_array_free_deferred(struct super_block *sb,
-				struct ext4_xattr_inode_array *array);
-
 #ifdef CONFIG_LOCKDEP
 void ext4_xattr_inode_set_class(struct inode *ea_inode)
 {
@@ -1162,7 +1156,6 @@ static void
 ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 			     struct buffer_head *bh,
 			     struct ext4_xattr_entry *first, bool block_csum,
-			     struct ext4_xattr_inode_array **ea_inode_array,
 			     int extra_credits, bool skip_quota)
 {
 	struct inode *ea_inode;
@@ -1199,14 +1192,6 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err)
 			continue;
 
-		err = ext4_expand_inode_array(ea_inode_array, ea_inode);
-		if (err) {
-			ext4_warning_inode(ea_inode,
-					   "Expand inode array err=%d", err);
-			ext4_put_ea_inode(parent->i_sb, ea_inode);
-			continue;
-		}
-
 		err = ext4_journal_ensure_credits_fn(handle, credits, credits,
 			ext4_free_metadata_revoke_credits(parent->i_sb, 1),
 			ext4_xattr_restart_fn(handle, parent, bh, block_csum,
@@ -1214,6 +1199,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err < 0) {
 			ext4_warning_inode(ea_inode, "Ensure credits err=%d",
 					   err);
+			ext4_put_ea_inode(parent->i_sb, ea_inode);
 			continue;
 		}
 		if (err > 0) {
@@ -1223,6 +1209,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 				ext4_warning_inode(ea_inode,
 						"Re-get write access err=%d",
 						err);
+				ext4_put_ea_inode(parent->i_sb, ea_inode);
 				continue;
 			}
 		}
@@ -1231,6 +1218,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err) {
 			ext4_warning_inode(ea_inode, "ea_inode dec ref err=%d",
 					   err);
+			ext4_put_ea_inode(parent->i_sb, ea_inode);
 			continue;
 		}
 
@@ -1247,6 +1235,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		entry->e_value_inum = 0;
 		entry->e_value_size = 0;
 
+		ext4_put_ea_inode(parent->i_sb, ea_inode);
 		dirty = true;
 	}
 
@@ -1273,7 +1262,6 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 static void
 ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 			 struct buffer_head *bh,
-			 struct ext4_xattr_inode_array **ea_inode_array,
 			 int extra_credits)
 {
 	struct mb_cache *ea_block_cache = EA_BLOCK_CACHE(inode);
@@ -1315,7 +1303,6 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_dec_ref_all(handle, inode, bh,
 						     BFIRST(bh),
 						     true /* block_csum */,
-						     ea_inode_array,
 						     extra_credits,
 						     true /* skip_quota */);
 		ext4_free_blocks(handle, inode, bh, 0, 1,
@@ -2184,13 +2171,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 	/* Drop the previous xattr block. */
 	if (bs->bh && bs->bh != new_bh) {
-		struct ext4_xattr_inode_array *ea_inode_array = NULL;
-
 		ext4_xattr_release_block(handle, inode, bs->bh,
-					 &ea_inode_array,
 					 0 /* extra_credits */);
-		ext4_xattr_inode_array_free_deferred(inode->i_sb,
-						     ea_inode_array);
 	}
 	error = 0;
 
@@ -2866,46 +2848,6 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
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
@@ -2916,7 +2858,6 @@ ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
  * references on xattr block and xattr inodes.
  */
 int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
-			    struct ext4_xattr_inode_array **ea_inode_array,
 			    int extra_credits)
 {
 	struct buffer_head *bh = NULL;
@@ -2955,7 +2896,6 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_dec_ref_all(handle, inode, iloc.bh,
 						     IFIRST(header),
 						     false /* block_csum */,
-						     ea_inode_array,
 						     extra_credits,
 						     false /* skip_quota */);
 	}
@@ -2994,7 +2934,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 
 		}
 
-		ext4_xattr_release_block(handle, inode, bh, ea_inode_array,
+		ext4_xattr_release_block(handle, inode, bh,
 					 extra_credits);
 		/*
 		 * Update i_file_acl value in the same transaction that releases
@@ -3016,31 +2956,6 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
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
-static void ext4_xattr_inode_array_free_deferred(struct super_block *sb,
-				struct ext4_xattr_inode_array *array)
-{
-	int idx;
-
-	if (array == NULL)
-		return;
-
-	for (idx = 0; idx < array->count; ++idx)
-		ext4_put_ea_inode(sb, array->inodes[idx]);
-	kfree(array);
-}
-
 /*
  * Worker function for deferred EA inode iput.  Processes all inodes queued
  * on s_ea_inode_to_free in a context free of xattr_sem/jbd2 handle locks.
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 9883ba5569a1..8214a31fe001 100644
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
 extern void ext4_put_ea_inode(struct super_block *sb, struct inode *inode);
 
-- 
2.43.0

