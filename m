Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689DC2F7F0F;
	Mon, 15 Jun 2026 11:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781524440; cv=none; b=TcdPTx+IoBMTZqjhndom6RnewR+ReUNolYN58oMOR5gJr6EW+aQDqi0DRQNAUSmVeBngSnhpmms31jV+m0pT22dG7+E98Q0E2HsfD6JXOx9H0LhAlbmEW9+yxINCqizMIcHEF9YEZvgTVGew9oX+nueneY/+SSlesYvzJQD77Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781524440; c=relaxed/simple;
	bh=jap9lariMroBLDgi+WzL4gTf3f3ATDEwf66pybdhn3w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kyc12akcORLZ91JtzTWqvnNSvWi97+mNxYfLLuc8weTsdkpjdljTLTjzHlIy0Muo00XCzvkMxyKJwof49hr7GE/j26EC1MZV+k6n6kDHn1zX75met0ypFXWyNYXmbcjXM5iAX6Ugiyahd3lvJdxUbGCWFIpZggS80xsEIUzDwqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=crYKDC0a; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="crYKDC0a"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FArk241063605;
	Mon, 15 Jun 2026 04:53:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=YkBQ7TDa+khvf7FIwfISqxWgV6Zg+qvUfbXAHdJQFdY=; b=
	crYKDC0aeY2XlsLkbS6vDQj+MoEES1lVOS3+qKST+qtqxYY9yGpZV6DKBHXPxE4J
	Ro2bh/V8TkQ7jlsQf6LIm4vhrf/kls/gk40YUDpyP/5KUoIOxoFIy7aAr2G9qh9U
	a4S8CPjHaiEAz2O5hWYGxLTwN/14IlLhbkS9XI/yuMqKdwByd551u842rT6cgX7v
	7dzdolfie/qcgPUpy4Suhliom7XGRE3RH1FGBHhMJEjaoBT9e8P7MrZ73XzT73/e
	ZQGeKRC3KTolaS3F97xtb/trccY63LbMD1GgPY6gGJ/bvb3T+o4BJiZi17786W9/
	hWFOsVAX7TYLa0yOh569pQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es6qdt4hk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 15 Jun 2026 04:53:30 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 15 Jun 2026 04:53:30 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 15 Jun 2026 04:53:27 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 3/3] ext4: defer iput() on ea_inodes to reduce lock holding scope
Date: Mon, 15 Jun 2026 19:53:17 +0800
Message-ID: <20260615115317.3549469-4-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260615115317.3549469-1-yun.zhou@windriver.com>
References: <20260615115317.3549469-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DLq/JSNb c=1 sm=1 tr=0 ts=6a2fe7ba cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8 a=ThDSICPUTf-vwvjNNp8A:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: IWEq7eUxldTLSDW3cgQYiKmYjMhKBXvi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDEyNSBTYWx0ZWRfXyqQaUb+W6WTU
 exLXcxBqnZwYHKO97g7DKwOt9PhxbDc7NY6lZujeQ7rEEYBCcbdzoWDnJDmWnabv11B2kX4laSz
 cVPBmFCQhKTLeZ3RKl1iXzMB1rNCrzmWoOMlq0+/NwxFUnEySDSvmJPSAh2bRsdo8mqwOZ3Zw89
 JsA8K4DW+/OgC5vLO+5Os4bQUwV15l49gIPcRemP4Dye9zGQkjTS15FEYH2kG4BGBPhNB1luQik
 iG0yzs2S/q5JaLKTId3WwNMBk2LtRCuNCBqgjO8ylLKyS4bDf5JfcyDptzbOHOgahLA+DsAMmiY
 wNbuHjYUTPutTEIxJwhrC3Cb/09duI/z9VI0RFOUc13tXMnnq7pKSMoWO9ZM+eNM+mC/niGNSZ4
 baB8reABNFDCODwFhGMu3EcI64LYN5oBQVXTKBk6BsfVPpssqnaLgAamO665RGVoJ9eahmI1Yw8
 ibNgDRj8syIX7EzEUpA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDEyNSBTYWx0ZWRfXxm1rgoCpaueu
 vznExdCmp3fYa+cbp1VIocBdipilUu5HKE1vk70YXDPdUJyOnMXD0A58GlO9zJ6Ow/zo+H13273
 ghMRF+ZuMOthLsIMoZtZlgIUrjre46CnWAOYt9vE+HjHjjyohkqk
X-Proofpoint-ORIG-GUID: IWEq7eUxldTLSDW3cgQYiKmYjMhKBXvi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_03,2026-06-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150125

ext4_xattr_block_set(), ext4_xattr_ibody_set() and ext4_xattr_set_entry()
call iput() on ea_inodes while xattr_sem and a jbd2 handle are held.
This creates an unnecessarily wide lock scope and, without the preceding
!SB_ACTIVE guard, could trigger write_inode_now() -> s_writepages_rwsem
creating a circular dependency.

Structurally eliminate iput-under-xattr_sem by collecting ea_inodes into
a deferred-iput array and releasing them after locks are dropped:

1. Convert all iput(ea_inode) calls within ext4_xattr_set_entry(),
   ext4_xattr_ibody_set(), and ext4_xattr_block_set() to deferred iput
   via ext4_expand_inode_array().  Thread the ea_inode_array through
   ext4_xattr_set_handle(), ext4_xattr_move_to_block(), and
   ext4_expand_extra_isize_ea() as an output parameter.

2. Callers that own the journal handle (ext4_xattr_set,
   ext4_expand_extra_isize) free the array AFTER ext4_journal_stop().
   For ext4_try_to_expand_extra_isize (called from __ext4_mark_inode_dirty
   with the caller's handle), free after xattr_sem release -- safe
   because the preceding patches block the !SB_ACTIVE path.

3. Callers that cannot control the handle lifetime (ext4_initxattrs,
   __ext4_set_acl, ext4_set_context, inline data ops) pass NULL.
   ext4_expand_inode_array() falls back to synchronous iput() when
   ea_inode_array is NULL -- safe because these callers only run with
   SB_ACTIVE where iput cannot trigger write_inode_now().

4. Use __GFP_NOFAIL in ext4_expand_inode_array() to guarantee the
   deferred-iput array never fails to grow, eliminating any fallback
   to synchronous iput() under locks.

5. Pass ea_inode_array directly to ext4_xattr_release_block() in
   ext4_xattr_block_set() instead of using a local array freed
   synchronously under xattr_sem.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/acl.c            |  2 +-
 fs/ext4/crypto.c         |  4 +-
 fs/ext4/inline.c         |  8 ++--
 fs/ext4/inode.c          | 16 +++++--
 fs/ext4/xattr.c          | 93 ++++++++++++++++++++++++----------------
 fs/ext4/xattr.h          | 10 +++--
 fs/ext4/xattr_security.c |  3 +-
 7 files changed, 85 insertions(+), 51 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 3bffe862f954..21de8276b558 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -215,7 +215,7 @@ __ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 	}
 
 	error = ext4_xattr_set_handle(handle, inode, name_index, "",
-				      value, size, xattr_flags);
+				      value, size, xattr_flags, NULL);
 
 	kfree(value);
 	if (!error)
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index f41f320f4437..bca760751c1d 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -173,7 +173,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 		res = ext4_xattr_set_handle(handle, inode,
 					    EXT4_XATTR_INDEX_ENCRYPTION,
 					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
-					    ctx, len, XATTR_CREATE);
+					    ctx, len, XATTR_CREATE, NULL);
 		if (!res) {
 			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
 			ext4_clear_inode_state(inode,
@@ -202,7 +202,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 
 	res = ext4_xattr_set_handle(handle, inode, EXT4_XATTR_INDEX_ENCRYPTION,
 				    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
-				    ctx, len, 0);
+				    ctx, len, 0, NULL);
 	if (!res) {
 		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
 		/*
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..2bf2b771929d 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -309,7 +309,7 @@ static int ext4_create_inline_data(handle_t *handle,
 		goto out;
 	}
 
-	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is, NULL);
 	if (error) {
 		if (error == -ENOSPC)
 			ext4_clear_inode_state(inode,
@@ -386,7 +386,7 @@ static int ext4_update_inline_data(handle_t *handle, struct inode *inode,
 	i.value = value;
 	i.value_len = len;
 
-	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is, NULL);
 	if (error)
 		goto out;
 
@@ -469,7 +469,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 	if (error)
 		goto out;
 
-	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is, NULL);
 	if (error)
 		goto out;
 
@@ -1917,7 +1917,7 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 			i.value = value;
 			i.value_len = i_size > EXT4_MIN_INLINE_DATA_SIZE ?
 					i_size - EXT4_MIN_INLINE_DATA_SIZE : 0;
-			err = ext4_xattr_ibody_set(handle, inode, &i, &is);
+			err = ext4_xattr_ibody_set(handle, inode, &i, &is, NULL);
 			if (err)
 				goto out_error;
 		}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 60c91c098fa0..a1b0f47f8f4f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6409,7 +6409,8 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
 static int __ext4_expand_extra_isize(struct inode *inode,
 				     unsigned int new_extra_isize,
 				     struct ext4_iloc *iloc,
-				     handle_t *handle, int *no_expand)
+				     handle_t *handle, int *no_expand,
+				     struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
@@ -6454,7 +6455,7 @@ static int __ext4_expand_extra_isize(struct inode *inode,
 
 	/* try to expand with EAs present */
 	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
-					   raw_inode, handle);
+					   raw_inode, handle, ea_inode_array);
 	if (error) {
 		/*
 		 * Inode size expansion failed; don't try again
@@ -6476,6 +6477,7 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 {
 	int no_expand;
 	int error;
+	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 
 	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND))
 		return -EOVERFLOW;
@@ -6507,8 +6509,11 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 		return -EBUSY;
 
 	error = __ext4_expand_extra_isize(inode, new_extra_isize, &iloc,
-					  handle, &no_expand);
+					  handle, &no_expand,
+					  &ea_inode_array);
 	ext4_write_unlock_xattr(inode, &no_expand);
+	/* Safe with caller's handle active: !SB_ACTIVE is blocked above */
+	ext4_xattr_inode_array_free(ea_inode_array);
 
 	return error;
 }
@@ -6520,6 +6525,7 @@ int ext4_expand_extra_isize(struct inode *inode,
 	handle_t *handle;
 	int no_expand;
 	int error, rc;
+	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 
 	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
 		brelse(iloc->bh);
@@ -6545,7 +6551,8 @@ int ext4_expand_extra_isize(struct inode *inode,
 	}
 
 	error = __ext4_expand_extra_isize(inode, new_extra_isize, iloc,
-					  handle, &no_expand);
+					  handle, &no_expand,
+					  &ea_inode_array);
 
 	rc = ext4_mark_iloc_dirty(handle, inode, iloc);
 	if (!error)
@@ -6554,6 +6561,7 @@ int ext4_expand_extra_isize(struct inode *inode,
 out_unlock:
 	ext4_write_unlock_xattr(inode, &no_expand);
 	ext4_journal_stop(handle);
+	ext4_xattr_inode_array_free(ea_inode_array);
 	return error;
 }
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..4eb83917e6b4 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1630,7 +1630,8 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 				struct ext4_xattr_search *s,
 				handle_t *handle, struct inode *inode,
 				struct inode *new_ea_inode,
-				bool is_block)
+				bool is_block,
+				struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_entry *last, *next;
 	struct ext4_xattr_entry *here = s->here;
@@ -1848,7 +1849,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 
 	ret = 0;
 out:
-	iput(old_ea_inode);
+	ext4_expand_inode_array(ea_inode_array, old_ea_inode);
 	return ret;
 }
 
@@ -1898,7 +1899,8 @@ ext4_xattr_block_find(struct inode *inode, struct ext4_xattr_info *i,
 static int
 ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 		     struct ext4_xattr_info *i,
-		     struct ext4_xattr_block_find *bs)
+		     struct ext4_xattr_block_find *bs,
+		     struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *new_bh = NULL;
@@ -1961,7 +1963,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			}
 			ea_bdebug(bs->bh, "modifying in-place");
 			error = ext4_xattr_set_entry(i, s, handle, inode,
-					     ea_inode, true /* is_block */);
+					     ea_inode, true /* is_block */,
+					     ea_inode_array);
 			ext4_xattr_block_csum_set(inode, bs->bh);
 			unlock_buffer(bs->bh);
 			if (error == -EFSCORRUPTED)
@@ -2030,7 +2033,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 	}
 
 	error = ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
-				     true /* is_block */);
+				     true /* is_block */, ea_inode_array);
 	if (error == -EFSCORRUPTED)
 		goto bad_block;
 	if (error)
@@ -2150,7 +2153,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 					ext4_warning_inode(ea_inode,
 							   "dec ref error=%d",
 							   error);
-				iput(ea_inode);
+				ext4_expand_inode_array(ea_inode_array,
+							ea_inode);
 				ea_inode = NULL;
 			}
 
@@ -2182,12 +2186,9 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 	/* Drop the previous xattr block. */
 	if (bs->bh && bs->bh != new_bh) {
-		struct ext4_xattr_inode_array *ea_inode_array = NULL;
-
 		ext4_xattr_release_block(handle, inode, bs->bh,
-					 &ea_inode_array,
+					 ea_inode_array,
 					 0 /* extra_credits */);
-		ext4_xattr_inode_array_free(ea_inode_array);
 	}
 	error = 0;
 
@@ -2203,7 +2204,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
 		}
-		iput(ea_inode);
+		ext4_expand_inode_array(ea_inode_array, ea_inode);
 	}
 	if (ce)
 		mb_cache_entry_put(ea_block_cache, ce);
@@ -2253,7 +2254,8 @@ int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 
 int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 				struct ext4_xattr_info *i,
-				struct ext4_xattr_ibody_find *is)
+				struct ext4_xattr_ibody_find *is,
+				struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_xattr_search *s = &is->s;
@@ -2273,7 +2275,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 			return PTR_ERR(ea_inode);
 	}
 	error = ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
-				     false /* is_block */);
+				     false /* is_block */, ea_inode_array);
 	if (error) {
 		if (ea_inode) {
 			int error2;
@@ -2285,7 +2287,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
-			iput(ea_inode);
+			ext4_expand_inode_array(ea_inode_array, ea_inode);
 		}
 		return error;
 	}
@@ -2297,7 +2299,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 		header->h_magic = cpu_to_le32(0);
 		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
 	}
-	iput(ea_inode);
+	ext4_expand_inode_array(ea_inode_array, ea_inode);
 	return 0;
 }
 
@@ -2348,7 +2350,8 @@ static struct buffer_head *ext4_xattr_get_block(struct inode *inode)
 int
 ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		      const char *name, const void *value, size_t value_len,
-		      int flags)
+		      int flags,
+		      struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_info i = {
 		.name_index = name_index,
@@ -2428,9 +2431,11 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 
 	if (!value) {
 		if (!is.s.not_found)
-			error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+			error = ext4_xattr_ibody_set(handle, inode, &i, &is,
+						     ea_inode_array);
 		else if (!bs.s.not_found)
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs,
+						     ea_inode_array);
 	} else {
 		error = 0;
 		/* Xattr value did not change? Save us some work and bail out */
@@ -2444,10 +2449,12 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 			EXT4_XATTR_MIN_LARGE_EA_SIZE(inode->i_sb->s_blocksize)))
 			i.in_inode = 1;
 retry_inode:
-		error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+		error = ext4_xattr_ibody_set(handle, inode, &i, &is,
+					     ea_inode_array);
 		if (!error && !bs.s.not_found) {
 			i.value = NULL;
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs,
+						     ea_inode_array);
 		} else if (error == -ENOSPC) {
 			if (EXT4_I(inode)->i_file_acl && !bs.s.base) {
 				brelse(bs.bh);
@@ -2456,11 +2463,12 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 				if (error)
 					goto cleanup;
 			}
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs,
+						     ea_inode_array);
 			if (!error && !is.s.not_found) {
 				i.value = NULL;
 				error = ext4_xattr_ibody_set(handle, inode, &i,
-							     &is);
+							     &is, ea_inode_array);
 			} else if (error == -ENOSPC) {
 				/*
 				 * Xattr does not fit in the block, store at
@@ -2539,6 +2547,7 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 {
 	handle_t *handle;
 	struct super_block *sb = inode->i_sb;
+	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 	int error, retries = 0;
 	int credits;
 
@@ -2559,10 +2568,13 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 		int error2;
 
 		error = ext4_xattr_set_handle(handle, inode, name_index, name,
-					      value, value_len, flags);
+					      value, value_len, flags,
+					      &ea_inode_array);
 		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR,
 					handle);
 		error2 = ext4_journal_stop(handle);
+		ext4_xattr_inode_array_free(ea_inode_array);
+		ea_inode_array = NULL;
 		if (error == -ENOSPC &&
 		    ext4_should_retry_alloc(sb, &retries))
 			goto retry;
@@ -2604,7 +2616,8 @@ static void ext4_xattr_shift_entries(struct ext4_xattr_entry *entry,
  */
 static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 				    struct ext4_inode *raw_inode,
-				    struct ext4_xattr_entry *entry)
+				    struct ext4_xattr_entry *entry,
+				    struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_ibody_find *is = NULL;
 	struct ext4_xattr_block_find *bs = NULL;
@@ -2668,14 +2681,14 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 		goto out;
 
 	/* Move ea entry from the inode into the block */
-	error = ext4_xattr_block_set(handle, inode, &i, bs);
+	error = ext4_xattr_block_set(handle, inode, &i, bs, ea_inode_array);
 	if (error)
 		goto out;
 
 	/* Remove the chosen entry from the inode */
 	i.value = NULL;
 	i.value_len = 0;
-	error = ext4_xattr_ibody_set(handle, inode, &i, is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, is, ea_inode_array);
 
 out:
 	kfree(b_entry_name);
@@ -2694,7 +2707,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
 				       struct ext4_inode *raw_inode,
 				       int isize_diff, size_t ifree,
-				       size_t bfree, int *total_ino)
+				       size_t bfree, int *total_ino,
+				       struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_ibody_header *header = IHDR(inode, raw_inode);
 	struct ext4_xattr_entry *small_entry;
@@ -2744,7 +2758,7 @@ static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
 			total_size += EXT4_XATTR_SIZE(
 					      le32_to_cpu(entry->e_value_size));
 		error = ext4_xattr_move_to_block(handle, inode, raw_inode,
-						 entry);
+						 entry, ea_inode_array);
 		if (error)
 			return error;
 
@@ -2761,7 +2775,8 @@ static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
  * Returns 0 on success or negative error number on failure.
  */
 int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
-			       struct ext4_inode *raw_inode, handle_t *handle)
+			       struct ext4_inode *raw_inode, handle_t *handle,
+			       struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -2833,7 +2848,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 
 	error = ext4_xattr_make_inode_space(handle, inode, raw_inode,
 					    isize_diff, ifree, bfree,
-					    &total_ino);
+					    &total_ino, ea_inode_array);
 	if (error) {
 		if (error == -ENOSPC && !tried_min_extra_isize &&
 		    s_min_extra_isize) {
@@ -2869,19 +2884,27 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 /* Add the large xattr @inode into @ea_inode_array for deferred iput().
  * If @ea_inode_array is new or full it will be grown and the old
  * contents copied over.
+ *
+ * If @inode is NULL this is a no-op.  If @ea_inode_array is NULL the
+ * caller guarantees SB_ACTIVE so synchronous iput is safe.
  */
 static int
 ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
 			struct inode *inode)
 {
+	if (!inode)
+		return 0;
+	if (!ea_inode_array) {
+		iput(inode);
+		return 0;
+	}
 	if (*ea_inode_array == NULL) {
 		/*
 		 * Start with 15 inodes, so it fits into a power-of-two size.
 		 */
 		(*ea_inode_array) = kmalloc_flex(**ea_inode_array, inodes,
-						 EIA_MASK, GFP_NOFS);
-		if (*ea_inode_array == NULL)
-			return -ENOMEM;
+						 EIA_MASK,
+						 GFP_NOFS | __GFP_NOFAIL);
 		(*ea_inode_array)->count = 0;
 	} else if (((*ea_inode_array)->count & EIA_MASK) == EIA_MASK) {
 		/* expand the array once all 15 + n * 16 slots are full */
@@ -2889,9 +2912,7 @@ ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
 
 		new_array = kmalloc_flex(**ea_inode_array, inodes,
 					 (*ea_inode_array)->count + EIA_INCR,
-					 GFP_NOFS);
-		if (new_array == NULL)
-			return -ENOMEM;
+					 GFP_NOFS | __GFP_NOFAIL);
 		memcpy(new_array, *ea_inode_array,
 		       struct_size(*ea_inode_array, inodes,
 				   (*ea_inode_array)->count));
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 1fedf44d4fb6..6771d00d3fa4 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -179,7 +179,9 @@ extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
-extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
+extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *,
+		const void *, size_t, int,
+		struct ext4_xattr_inode_array **ea_inode_array);
 extern int ext4_xattr_set_credits(struct inode *inode, size_t value_len,
 				  bool is_create, int *credits);
 extern int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
@@ -192,7 +194,8 @@ extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
 
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
-			    struct ext4_inode *raw_inode, handle_t *handle);
+			    struct ext4_inode *raw_inode, handle_t *handle,
+			    struct ext4_xattr_inode_array **ea_inode_array);
 extern void ext4_evict_ea_inode(struct inode *inode);
 
 extern const struct xattr_handler * const ext4_xattr_handlers[];
@@ -204,7 +207,8 @@ extern int ext4_xattr_ibody_get(struct inode *inode, int name_index,
 				void *buffer, size_t buffer_size);
 extern int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 				struct ext4_xattr_info *i,
-				struct ext4_xattr_ibody_find *is);
+				struct ext4_xattr_ibody_find *is,
+				struct ext4_xattr_inode_array **ea_inode_array);
 
 extern struct mb_cache *ext4_xattr_create_cache(void);
 extern void ext4_xattr_destroy_cache(struct mb_cache *);
diff --git a/fs/ext4/xattr_security.c b/fs/ext4/xattr_security.c
index 776cf11d24ca..6b7ab6e703ad 100644
--- a/fs/ext4/xattr_security.c
+++ b/fs/ext4/xattr_security.c
@@ -44,7 +44,8 @@ ext4_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		err = ext4_xattr_set_handle(handle, inode,
 					    EXT4_XATTR_INDEX_SECURITY,
 					    xattr->name, xattr->value,
-					    xattr->value_len, XATTR_CREATE);
+					    xattr->value_len, XATTR_CREATE,
+					    NULL);
 		if (err < 0)
 			break;
 	}
-- 
2.43.0

