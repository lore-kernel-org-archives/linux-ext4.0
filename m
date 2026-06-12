Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240F33EB7F8;
	Fri, 12 Jun 2026 13:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781270386; cv=none; b=haIKyRCtmOPej/cowOZn2+KaT0AP6Hd+abaerlZeraUs+yMExspGVmTIwKRd1HGRZqHGlBLYjjBb7hfbaJnj0MNCVuRONEjvQJZeWNhXBZj11BwAnfUSCmDOOhets2pnhcpKYG38Ylv6fyRlH/qbGNoO9I6gCpEIQaJmKgnAnf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781270386; c=relaxed/simple;
	bh=/dgJ+c6dBf37dQkM0SfMw1ro228XKcS08rBqs7CbOZA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NA5tWnTB3d3iVxWRP4MfO9NhQ5vQXsGrBekxhhENNOg5zIE+5ryIA7zQ6T4dcgkOn6T8fTQLuTEKyylCa58888mkS6v26weP0WV6QCaDvVWLlJ7ubBPAlnys4ZATGn4RVhZqPw0Ab2vfVWxAWAc27nFAZHojkY1Ncb3vZ3vgZsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=iR9tunWi; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="iR9tunWi"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65CBVS6N2143984;
	Fri, 12 Jun 2026 06:19:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=vdTsmrC0ON6MTHsaNyFHQVWGgD4dASWjJO2ORFoojzw=; b=
	iR9tunWipF3ksUL02eLKtJWyjbiK8jBao/k8m4uVmdvxI/mlIxjSA2ipjdLtODBa
	GgycjXjRKlIotJK903ta7ekY56t5/2dC9qfwAWjsi/F9Sf3rr0QOBj8p2GBZu6zh
	66AzIkKDqaC6NB9UEPYJpoRP+hv4zWh6a3HBMGJYevbd7lvO40BqVoUMa4Yl+eQa
	8PhfSNJoFPJSvO8TBLDCVbXLAvX5jDjlWCtWceYStACe2McOPHOxg3XlThONjzED
	oJsQufj2Ysyvhi88bouMYBKst83LN8kbQCS24I1jid5tT0I+SaC1yYkWcQK4dSBq
	rjN9XggIbxMJcTjSm5zmWQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4eqe7ajrw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 12 Jun 2026 06:19:12 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 12 Jun 2026 06:19:12 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 12 Jun 2026 06:19:09 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] ext4: defer iput() in ext4_xattr_block_set() to avoid deadlock with writepages
Date: Fri, 12 Jun 2026 21:19:08 +0800
Message-ID: <20260612131908.2470757-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260612095846.1024470-1-yun.zhou@windriver.com>
References: <20260612095846.1024470-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2CTzwRlT6VwuSrfjawCBVZFlkf4McGAB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDEyMiBTYWx0ZWRfX+ZbAyPfcchBD
 CuDvdPWjd5cG+lcZFpUX7zQ5cRG4kHYvsny0RjJjh/GG3Hy86388d8PLvmS8AzJ8H0jSxdA3q+Q
 JmTRI++4/EuBc7RYb4cTpNJoqkn0dY2xwM8z4wYzxE2ugOIDCJ4S8xDCfrYYBkYrh10MBv/Wzn3
 JQWq05q8iPVksCabEsJeAkY9ZjAt69L/4NyA88nOtQr9wsWjIuvEf5+UfimySaEwpEki4HnzI1J
 097d51IZVA2Mnosd5OlofKlEUNMhMe2nRWMTbMEHaUx9sZ6xxfEH5bvCV+dKdp1P0xyJclqqMmr
 +sOhvLVl2kZIlKMYXoez2NSWGxQ3UiEDLeFdgkeKAWwSZ0qE+Ilr+3Cf34TneS03AO3t//h5gGw
 Ht2BiRXVX9dhvGQPEUVpaOcWZQ+TFUzRTVswFryF3K8cEDNdEiYcmvFUgKugtLk3wmw/5FHM52T
 B54PY74DhTEFMOmPzDw==
X-Proofpoint-GUID: 2CTzwRlT6VwuSrfjawCBVZFlkf4McGAB
X-Authority-Analysis: v=2.4 cv=P+cKQCAu c=1 sm=1 tr=0 ts=6a2c0751 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=N8XA07ESJKoyqESaXDYA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDEyMiBTYWx0ZWRfX9S75pZ24kJkh
 QC6YVq2Br6veYBLz5QZgz6ePszXp506c02qbVcHr+pGA6ZwftWW2HfYUAko3xidqGZEOslKiuCs
 2gtzkEcZQH+LKNl49n72dKUXgvZsFWFqCqKZQ8kf4peimIpYBhQO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606120122

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
v3: Address AI review feedback on v2:
  - Check ext4_expand_inode_array() return value; fallback to
    direct iput() on ENOMEM to prevent inode leak.
  - Make ext4_xattr_set_handle() take an optional ea_inode_array
    output parameter so callers can free after ext4_journal_stop(),
	avoiding the jbd2_handle vs s_writepages_rwsem AB-BA.
  - Pass ea_inode_array directly to ext4_xattr_release_block()
    instead of using a local array freed under xattr_sem.
  - Move ext4_xattr_inode_array_free() after ext4_journal_stop()

v2: Defer iput() in ext4_xattr_block_set() via ea_inode_array,
	freed after xattr_sem is released. Fixes the root cause.

v1: Set EXT4_STATE_NO_EXPAND in ext4_evict_inode() to skip expand
	on inodes being deleted. Only fixes the syzbot reproducer, not
	the underlying lock ordering violation.

 fs/ext4/acl.c            |  2 +-
 fs/ext4/crypto.c         |  4 ++--
 fs/ext4/inode.c          | 13 ++++++----
 fs/ext4/xattr.c          | 51 ++++++++++++++++++++++++++--------------
 fs/ext4/xattr.h          |  6 +++--
 fs/ext4/xattr_security.c |  3 ++-
 6 files changed, 51 insertions(+), 28 deletions(-)

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
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cd7588a3fa45..2cf68d27e896 100644
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
@@ -6496,8 +6498,9 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 		return -EBUSY;
 
 	error = __ext4_expand_extra_isize(inode, new_extra_isize, &iloc,
-					  handle, &no_expand);
+					  handle, &no_expand, &ea_inode_array);
 	ext4_write_unlock_xattr(inode, &no_expand);
+	ext4_xattr_inode_array_free(ea_inode_array);
 
 	return error;
 }
@@ -6509,6 +6512,7 @@ int ext4_expand_extra_isize(struct inode *inode,
 	handle_t *handle;
 	int no_expand;
 	int error, rc;
+	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 
 	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
 		brelse(iloc->bh);
@@ -6534,7 +6538,7 @@ int ext4_expand_extra_isize(struct inode *inode,
 	}
 
 	error = __ext4_expand_extra_isize(inode, new_extra_isize, iloc,
-					  handle, &no_expand);
+					  handle, &no_expand, &ea_inode_array);
 
 	rc = ext4_mark_iloc_dirty(handle, inode, iloc);
 	if (!error)
@@ -6543,6 +6547,7 @@ int ext4_expand_extra_isize(struct inode *inode,
 out_unlock:
 	ext4_write_unlock_xattr(inode, &no_expand);
 	ext4_journal_stop(handle);
+	ext4_xattr_inode_array_free(ea_inode_array);
 	return error;
 }
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e91af66db7a7..fa9a16c86fd8 100644
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
+				if (ext4_expand_inode_array(ea_inode_array, ea_inode))
+					iput(ea_inode);
 				ea_inode = NULL;
 			}
 
@@ -2190,12 +2192,9 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
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
 
@@ -2211,7 +2210,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
 		}
-		iput(ea_inode);
+		if (ext4_expand_inode_array(ea_inode_array, ea_inode))
+			iput(ea_inode);
 	}
 	if (ce)
 		mb_cache_entry_put(ea_block_cache, ce);
@@ -2356,7 +2356,7 @@ static struct buffer_head *ext4_xattr_get_block(struct inode *inode)
 int
 ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		      const char *name, const void *value, size_t value_len,
-		      int flags)
+		      int flags, struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_info i = {
 		.name_index = name_index,
@@ -2371,6 +2371,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	struct ext4_xattr_block_find bs = {
 		.s = { .not_found = -ENODATA, },
 	};
+	struct ext4_xattr_inode_array *local_array = NULL;
 	int no_expand;
 	int error;
 
@@ -2379,6 +2380,9 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	if (strlen(name) > 255)
 		return -ERANGE;
 
+	if (!ea_inode_array)
+		ea_inode_array = &local_array;
+
 	ext4_write_lock_xattr(inode, &no_expand);
 
 	/* Check journal credits under write lock. */
@@ -2438,7 +2442,8 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		if (!is.s.not_found)
 			error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 		else if (!bs.s.not_found)
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs,
+						     ea_inode_array);
 	} else {
 		error = 0;
 		/* Xattr value did not change? Save us some work and bail out */
@@ -2455,7 +2460,8 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 		if (!error && !bs.s.not_found) {
 			i.value = NULL;
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs,
+						     ea_inode_array);
 		} else if (error == -ENOSPC) {
 			if (EXT4_I(inode)->i_file_acl && !bs.s.base) {
 				brelse(bs.bh);
@@ -2464,7 +2470,8 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 				if (error)
 					goto cleanup;
 			}
-			error = ext4_xattr_block_set(handle, inode, &i, &bs);
+			error = ext4_xattr_block_set(handle, inode, &i, &bs,
+						     ea_inode_array);
 			if (!error && !is.s.not_found) {
 				i.value = NULL;
 				error = ext4_xattr_ibody_set(handle, inode, &i,
@@ -2503,6 +2510,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	brelse(is.iloc.bh);
 	brelse(bs.bh);
 	ext4_write_unlock_xattr(inode, &no_expand);
+	ext4_xattr_inode_array_free(local_array);
 	return error;
 }
 
@@ -2547,6 +2555,7 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 {
 	handle_t *handle;
 	struct super_block *sb = inode->i_sb;
+	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 	int error, retries = 0;
 	int credits;
 
@@ -2567,10 +2576,13 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
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
@@ -2612,7 +2624,8 @@ static void ext4_xattr_shift_entries(struct ext4_xattr_entry *entry,
  */
 static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 				    struct ext4_inode *raw_inode,
-				    struct ext4_xattr_entry *entry)
+				    struct ext4_xattr_entry *entry,
+				    struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_ibody_find *is = NULL;
 	struct ext4_xattr_block_find *bs = NULL;
@@ -2676,7 +2689,7 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 		goto out;
 
 	/* Move ea entry from the inode into the block */
-	error = ext4_xattr_block_set(handle, inode, &i, bs);
+	error = ext4_xattr_block_set(handle, inode, &i, bs, ea_inode_array);
 	if (error)
 		goto out;
 
@@ -2702,7 +2715,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
 				       struct ext4_inode *raw_inode,
 				       int isize_diff, size_t ifree,
-				       size_t bfree, int *total_ino)
+				       size_t bfree, int *total_ino,
+				       struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_ibody_header *header = IHDR(inode, raw_inode);
 	struct ext4_xattr_entry *small_entry;
@@ -2752,7 +2766,7 @@ static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
 			total_size += EXT4_XATTR_SIZE(
 					      le32_to_cpu(entry->e_value_size));
 		error = ext4_xattr_move_to_block(handle, inode, raw_inode,
-						 entry);
+						 entry, ea_inode_array);
 		if (error)
 			return error;
 
@@ -2769,7 +2783,8 @@ static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
  * Returns 0 on success or negative error number on failure.
  */
 int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
-			       struct ext4_inode *raw_inode, handle_t *handle)
+			       struct ext4_inode *raw_inode, handle_t *handle,
+			       struct ext4_xattr_inode_array **ea_inode_array)
 {
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -2841,7 +2856,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 
 	error = ext4_xattr_make_inode_space(handle, inode, raw_inode,
 					    isize_diff, ifree, bfree,
-					    &total_ino);
+					    &total_ino, ea_inode_array);
 	if (error) {
 		if (error == -ENOSPC && !tried_min_extra_isize &&
 		    s_min_extra_isize) {
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 1fedf44d4fb6..9c3f1a96895d 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -179,7 +179,8 @@ extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
-extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
+extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *,
+		const void *, size_t, int, struct ext4_xattr_inode_array **);
 extern int ext4_xattr_set_credits(struct inode *inode, size_t value_len,
 				  bool is_create, int *credits);
 extern int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
@@ -192,7 +193,8 @@ extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
 
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
-			    struct ext4_inode *raw_inode, handle_t *handle);
+			    struct ext4_inode *raw_inode, handle_t *handle,
+			    struct ext4_xattr_inode_array **ea_inode_array);
 extern void ext4_evict_ea_inode(struct inode *inode);
 
 extern const struct xattr_handler * const ext4_xattr_handlers[];
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

