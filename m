Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903403921C3;
	Fri, 12 Jun 2026 09:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258371; cv=none; b=qKgjaglOXoNL4pjREqAypmiZUQ+Z9geHLaaZmQAXBnFxrH4JlfpqSYdoM9jw5WMrYX2xoXcBRObFQ0kMTr1OVoCrVEXTxfNbzUwfqnYsAC12UIq4pH0EVXS3DiRR7ez2qS6r33GH3Tem2MIM/Joqt9p00a4wv8SC5Gc8dXTmitw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258371; c=relaxed/simple;
	bh=13vxhwqJcX1uKgFcyt3Iy276lLlyTk79lwT/j0jiyTY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g+f7dqm4CF9fn4QCYuPdtyxNjaQtw6eAb0Qx+97f0IZCi4QRBB7Av0/OePw3H1Q19nDHVR743cYjyltoHQdSxlKfx8V6IpdyFiOVQov5+eOD2K5SWRzzqNRjNwRq3dFr5ZpfDvRp7MP91kNUjSqg8I6/bM8qUWl1by7OAGa77DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=N+8CffJI; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="N+8CffJI"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C6LFfQ1428617;
	Fri, 12 Jun 2026 02:58:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=O9tyTaxoqnN+5Q429qLuky6j0nxWGCm9Om6Xe/aRxyM=; b=
	N+8CffJI9Dl8eOT3nZdrb6Vq27YbMg84PsnzaJGyXz+WTM+6DMopUBHE5YS6KIK0
	VEwZWAx9zm8DIZbebwef6aU1Wy4dRiudMKdFkX7cH573z9Fxiw/mIb0DPtf2zQa5
	eDIXSh9+X6tBEqZy1zghuFm+jsDNN7Kr0aZHc/HnBl17FTog/m3K/xgQBh1y9eAr
	1zR30dBQH9ajR4ORdhcigAByPw9b/0CmT6Wp9xBiaTJrxyaVhlOHmZ+9nyMwDbIj
	kYj1ylUKx1dvo2mZHEE8NtmhAB7GtseLK1cTT+GUaHm7M9VmToYlFq0a4XvBgFNR
	AGBwQztImKZss0afh0UnHw==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4eqe7sajyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 12 Jun 2026 02:58:50 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 12 Jun 2026 02:58:49 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 12 Jun 2026 02:58:46 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ext4: defer iput() in ext4_xattr_block_set() to avoid deadlock with writepages
Date: Fri, 12 Jun 2026 17:58:46 +0800
Message-ID: <20260612095846.1024470-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260611124555.1541195-1-yun.zhou@windriver.com>
References: <20260611124555.1541195-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX3zUYnf77lgad
 uqBP0NiJc6EQiycRFdbwyKrbyHMwwO/PWYeJmLi/NBXIqwRe57+RcY1YR/i4lQ88v5tC0Dx7l77
 99MZVbOaFCn5ujRxaS2/ku34+FJsY7QkwUPjUBM8l+0cQfU4LIqt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX0xW3h3gEtWaI
 q0qUu9s7Pcj7CssgL0iRg+M2Ud81ikrehxoobGtdcitZ2jmObe0V7ttdOm55uxpoCo8UJzwpBO5
 a0nbPTWJthVhODAxu96eNkBiOwhgeW8JfSSZbWYy+jUHZ6Kb6nSQN599IPlo/sGHAalFPeyKe5C
 LDQXfjPqfh1U3RaehmNXM0Fx/Nv/g6A6qRqeztXdJFBbHaEjVDmcnoBRn+hUJSfII6Xdh1M8/wt
 XSD56X90RgtAICf0MNCwMMUwWzHvRUrBVXvoRgEg6rcqpPl2AYiuE+Gef26rL7yx+xIGTNcra2d
 h3FxJdWAmYE+QV2xBVGlD/50D5ABoppsv+bW1btwd2uXhUgex0IYxPjmSdhFVWGf9/0z84WmvNG
 SQxf6deV7mII2QTugZMAgsqgGKZnJ4qpCgAnOl+aA2kz2U0M+vlzSbM86CjsC4F439FEaXQYdih
 YYeoUAVsdoPQdmAEEGQ==
X-Authority-Analysis: v=2.4 cv=XujK/1F9 c=1 sm=1 tr=0 ts=6a2bd85a cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=uJOgC8jJ3zKllYyqe90A:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: OeNCcewcyosxBjmHcpqsYK1Qc8aih_7u
X-Proofpoint-ORIG-GUID: OeNCcewcyosxBjmHcpqsYK1Qc8aih_7u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606120089

ext4_xattr_block_set() calls iput() on ea_inode while its callers hold
xattr_sem.  If this iput() drops the last reference, it can trigger
write_inode_now() -> ext4_writepages() -> s_writepages_rwsem, which
violates the lock ordering since ext4_writepages() already establishes
s_writepages_rwsem -> jbd2_handle ordering:

  CPU0 (writeback worker)            CPU1 (file create)
  ----                               ----
  ext4_writepages()
    s_writepages_rwsem (read)        ext4_create()
    ext4_do_writepages()               __ext4_new_inode()
      ext4_journal_start()               [holds jbd2 handle]
        wait_transaction_locked()        ext4_xattr_set_handle()
        [WAIT for jbd2_handle]             xattr_sem (write)

  CPU2 (xattr set or isize expand)
  ----
  ext4_xattr_set_handle() or ext4_try_to_expand_extra_isize()
    xattr_sem (write)
    ext4_xattr_block_set()
      iput(ea_inode)
        write_inode_now()
          ext4_writepages()
            s_writepages_rwsem (read) [DEADLOCK]

This forms a circular dependency on lock classes:

  s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem

Fix by deferring iput() calls inside ext4_xattr_block_set() via the
existing ext4_xattr_inode_array mechanism.  The array is threaded
through the call chain and freed by callers after releasing xattr_sem.

Reported-by: syzbot+5d19358d7eb30ffb0cc5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5
Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v2: Defer iput() in ext4_xattr_block_set() via ea_inode_array,
	freed after xattr_sem is released. Fixes the root cause.

v1: Set EXT4_STATE_NO_EXPAND in ext4_evict_inode() to skip expand
	on inodes being deleted. Only fixes the syzbot reproducer, not
	the underlying lock ordering violation.

 fs/ext4/inode.c | 15 +++++++++++----
 fs/ext4/xattr.c | 40 +++++++++++++++++++++++++---------------
 fs/ext4/xattr.h |  3 ++-
 3 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cd7588a3fa45..c6448a9eb1e7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6408,7 +6408,8 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
 static int __ext4_expand_extra_isize(struct inode *inode,
 				     unsigned int new_extra_isize,
 				     struct ext4_iloc *iloc,
-				     handle_t *handle, int *no_expand)
+				     handle_t *handle, int *no_expand,
+				     struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
@@ -6453,7 +6454,7 @@ static int __ext4_expand_extra_isize(struct inode *inode,
 
 	/* try to expand with EAs present */
 	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
-					   raw_inode, handle);
+					   raw_inode, handle, ea_inode_array);
 	if (error) {
 		/*
 		 * Inode size expansion failed; don't try again
@@ -6475,6 +6476,7 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 {
 	int no_expand;
 	int error;
+	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 
 	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND))
 		return -EOVERFLOW;
@@ -6496,8 +6498,10 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 		return -EBUSY;
 
 	error = __ext4_expand_extra_isize(inode, new_extra_isize, &iloc,
-					  handle, &no_expand);
+					  handle, &no_expand,
+					  &ea_inode_array);
 	ext4_write_unlock_xattr(inode, &no_expand);
+	ext4_xattr_inode_array_free(ea_inode_array);
 
 	return error;
 }
@@ -6509,6 +6513,7 @@ int ext4_expand_extra_isize(struct inode *inode,
 	handle_t *handle;
 	int no_expand;
 	int error, rc;
+	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 
 	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
 		brelse(iloc->bh);
@@ -6534,7 +6539,8 @@ int ext4_expand_extra_isize(struct inode *inode,
 	}
 
 	error = __ext4_expand_extra_isize(inode, new_extra_isize, iloc,
-					  handle, &no_expand);
+					  handle, &no_expand,
+					  &ea_inode_array);
 
 	rc = ext4_mark_iloc_dirty(handle, inode, iloc);
 	if (!error)
@@ -6542,6 +6548,7 @@ int ext4_expand_extra_isize(struct inode *inode,
 
 out_unlock:
 	ext4_write_unlock_xattr(inode, &no_expand);
+	ext4_xattr_inode_array_free(ea_inode_array);
 	ext4_journal_stop(handle);
 	return error;
 }
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e91af66db7a7..bf8424927383 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1906,7 +1906,8 @@ ext4_xattr_block_find(struct inode *inode, struct ext4_xattr_info *i,
 static int
 ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 		     struct ext4_xattr_info *i,
-		     struct ext4_xattr_block_find *bs)
+		     struct ext4_xattr_block_find *bs,
+		     struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *new_bh = NULL;
@@ -2158,7 +2159,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 					ext4_warning_inode(ea_inode,
 							   "dec ref error=%d",
 							   error);
-				iput(ea_inode);
+				ext4_expand_inode_array(ea_inode_array,
+							ea_inode);
 				ea_inode = NULL;
 			}
 
@@ -2190,12 +2192,12 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 	/* Drop the previous xattr block. */
 	if (bs->bh && bs->bh != new_bh) {
-		struct ext4_xattr_inode_array *ea_inode_array = NULL;
+		struct ext4_xattr_inode_array *old_ea_inode_array = NULL;
 
 		ext4_xattr_release_block(handle, inode, bs->bh,
-					 &ea_inode_array,
+					 &old_ea_inode_array,
 					 0 /* extra_credits */);
-		ext4_xattr_inode_array_free(ea_inode_array);
+		ext4_xattr_inode_array_free(old_ea_inode_array);
 	}
 	error = 0;
 
@@ -2211,7 +2213,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
 		}
-		iput(ea_inode);
+		ext4_expand_inode_array(ea_inode_array, ea_inode);
 	}
 	if (ce)
 		mb_cache_entry_put(ea_block_cache, ce);
@@ -2371,6 +2373,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	struct ext4_xattr_block_find bs = {
 		.s = { .not_found = -ENODATA, },
 	};
+	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 	int no_expand;
 	int error;
 
@@ -2438,7 +2441,8 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		if (!is.s.not_found)
 			error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 		else if (!bs.s.not_found)
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs,
+						     &ea_inode_array);
 	} else {
 		error = 0;
 		/* Xattr value did not change? Save us some work and bail out */
@@ -2455,7 +2459,8 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 		if (!error && !bs.s.not_found) {
 			i.value = NULL;
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs,
+						     &ea_inode_array);
 		} else if (error == -ENOSPC) {
 			if (EXT4_I(inode)->i_file_acl && !bs.s.base) {
 				brelse(bs.bh);
@@ -2464,7 +2469,8 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 				if (error)
 					goto cleanup;
 			}
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs,
+						     &ea_inode_array);
 			if (!error && !is.s.not_found) {
 				i.value = NULL;
 				error = ext4_xattr_ibody_set(handle, inode, &i,
@@ -2503,6 +2509,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	brelse(is.iloc.bh);
 	brelse(bs.bh);
 	ext4_write_unlock_xattr(inode, &no_expand);
+	ext4_xattr_inode_array_free(ea_inode_array);
 	return error;
 }
 
@@ -2612,7 +2619,8 @@ static void ext4_xattr_shift_entries(struct ext4_xattr_entry *entry,
  */
 static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 				    struct ext4_inode *raw_inode,
-				    struct ext4_xattr_entry *entry)
+				    struct ext4_xattr_entry *entry,
+				    struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_ibody_find *is = NULL;
 	struct ext4_xattr_block_find *bs = NULL;
@@ -2676,7 +2684,7 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 		goto out;
 
 	/* Move ea entry from the inode into the block */
-	error = ext4_xattr_block_set(handle, inode, &i, bs);
+	error = ext4_xattr_block_set(handle, inode, &i, bs, ea_inode_array);
 	if (error)
 		goto out;
 
@@ -2702,7 +2710,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
 				       struct ext4_inode *raw_inode,
 				       int isize_diff, size_t ifree,
-				       size_t bfree, int *total_ino)
+				       size_t bfree, int *total_ino,
+				       struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_ibody_header *header = IHDR(inode, raw_inode);
 	struct ext4_xattr_entry *small_entry;
@@ -2752,7 +2761,7 @@ static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
 			total_size += EXT4_XATTR_SIZE(
 					      le32_to_cpu(entry->e_value_size));
 		error = ext4_xattr_move_to_block(handle, inode, raw_inode,
-						 entry);
+						 entry, ea_inode_array);
 		if (error)
 			return error;
 
@@ -2769,7 +2778,8 @@ static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
  * Returns 0 on success or negative error number on failure.
  */
 int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
-			       struct ext4_inode *raw_inode, handle_t *handle)
+			       struct ext4_inode *raw_inode, handle_t *handle,
+			       struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -2841,7 +2851,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 
 	error = ext4_xattr_make_inode_space(handle, inode, raw_inode,
 					    isize_diff, ifree, bfree,
-					    &total_ino);
+					    &total_ino, ea_inode_array);
 	if (error) {
 		if (error == -ENOSPC && !tried_min_extra_isize &&
 		    s_min_extra_isize) {
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 1fedf44d4fb6..02a172515193 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -192,7 +192,8 @@ extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
 
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
-			    struct ext4_inode *raw_inode, handle_t *handle);
+			    struct ext4_inode *raw_inode, handle_t *handle,
+			    struct ext4_xattr_inode_array **ea_inode_array);
 extern void ext4_evict_ea_inode(struct inode *inode);
 
 extern const struct xattr_handler * const ext4_xattr_handlers[];
-- 
2.43.0

