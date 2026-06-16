Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6572B43E4A1;
	Tue, 16 Jun 2026 15:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622997; cv=none; b=ELQeHpWzpw1x6nzy0vpwF56qfZHLifX7PpeKwTFBrm+pwGfKv563MX8tCxgRBqD14src90cPsRw8zA8JJ1OuOcdwaUi0xOUdwEvcdetqRRqh4Oe87WPiXYqjr7tnTvrqkTs0GXrXn0nQ5Z0UBfWJB8d3aThBMEB4oZRruEo75d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622997; c=relaxed/simple;
	bh=02TNtAhwn0TAkkU47ceiM0xGD14KSMP6mQzDBg0vOiY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hhZSBVhOPt9w4e8+yT0a6rOawg9EOcXoaCrDdmLGv+FrJRRH1fMCWT0bM/oSqTRX5DjHRrU8v5WWta4VgvOzDSynRtuYvvikJKoJlGEAkuA/2VoRwlh9kEVO2Dry6LpxjA7iNSY533Bm7smsmsFR2zk8wH9VdxRWnXQAFMX2u1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=BxNzEeOu; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="BxNzEeOu"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GDtjTp3673289;
	Tue, 16 Jun 2026 08:16:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=sP3DpRk549RdQNyM3d1yC13h/CMK/HVKTNJTeU8Yt5Y=; b=
	BxNzEeOudUSho4rz0tQ2PxM5qVkN1qZ5KcleVjFO21m3FQO265uuvFNPhigidzJN
	bCzQ/1moh00YoMStZx4c2UHyC+Kq/WI3mNxi2rqBXtOk2SqoL8q5wzt2SG2e1ONn
	oVejvC80hTzwJWn8Qx5/3J+jhpfJ9AH2ZJM4dYHS/Ok2XgLL81v/S62owUduRxbO
	GGUNQibMJo4pN9BTZw1/WCmBQZOidh4Dy5UxkXQoxeqNKQJg4KnZinuFA4iFXvuf
	HmByfnPn+Q+qCrz9Ei6nFBOUgKqugi1+GPMkVQnCiRfgvLrORf+2xSYOSrf2N6F1
	ad6iaAmNtDrujsvzGEoR2A==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es2g0cpmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 16 Jun 2026 08:16:09 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 16 Jun 2026 08:16:08 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 16 Jun 2026 08:16:06 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v7 3/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
Date: Tue, 16 Jun 2026 23:15:57 +0800
Message-ID: <20260616151558.1728881-4-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616151558.1728881-1-yun.zhou@windriver.com>
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ZJ/nX37b c=1 sm=1 tr=0 ts=6a3168b9 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=t7CeM3EgAAAA:8 a=Ky6gILQtogqK_uh6bJ4A:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDE1NiBTYWx0ZWRfX/XY6PV/H8hfG
 UQCUqg5TeOQ3KYbbx6wsvtSP2qUsQDnmMHpUytqaAHf49dB2cHOZCDe4GkuYjghZpZhdFdoTsfH
 OyafL/ytnMXRmPNdvENQ3P3gNpMFaGm+WCYX61pjV7EcezL62pajIix8W1Ue71cdj8qHlj1V2yp
 ZddK3O3YNFpqHzCBLGbdkX817kbJI8tBSUUluHAdu97vCsx8CElFcwVYaSThtOgEaRfo7IfZbAd
 M4FvhA/gVuY50NSjTpcswih3VxxwnHWZ3xbOBZRK/xm/u2Vvaie0WzTh5wYZmWFH+G3P2eO/lhL
 Bji1XyjUEJ2toj8sOZWWQ9YgTldpyXGdUa4Q0ceaEKu5ZvBculOCx80zL+yzCCV8f5053gnE7Sc
 NgRPwZ+dhacxn9cO9PEqITcW+rBFNCf2iWZ58eMi/l32fDt2Z3XRwLDlAAh62P9kD2Ml2ykxSoL
 FczIyWIS93TSLFIxtvA==
X-Proofpoint-ORIG-GUID: 8VhLmauFyIRLyDnKK1Zf9yteJfj-uCoc
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDE1NiBTYWx0ZWRfX03WDIQkMWmon
 ps0b+zDxIOUvaUUpYNcXNDejNwelUNKV7c0cPIqLYywx1WawGNKx9WSBFVRswhdHFMNv+2/UVt6
 reOv7Fbk2szvuonHtl+b0I4htzAdcLuFJFHXEGwBcUs1VuFZ2vUZ
X-Proofpoint-GUID: 8VhLmauFyIRLyDnKK1Zf9yteJfj-uCoc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606160156

Calling iput() on EA inodes while holding xattr_sem or a jbd2 handle
can trigger write_inode_now() -> ext4_writepages() -> s_writepages_rwsem,
creating a lock ordering issue during mount (!SB_ACTIVE).

Add ext4_put_ea_inode() which safely releases EA inode references:
when SB_ACTIVE, it calls iput() directly (write_inode_now cannot be
triggered); during mount (!SB_ACTIVE), it queues the inode on a per-sb
lock-free llist and schedules a worker to call iput() in a clean
context without holding any ext4 locks.

Convert the iput in ext4_xattr_block_set()'s "Drop the previous xattr
block" path to use ext4_xattr_inode_array_free_deferred(), which
releases EA inodes via ext4_put_ea_inode().  This path previously called
ext4_xattr_inode_array_free() (synchronous iput) while holding xattr_sem
and a jbd2 handle.

The worker is flushed in ext4_put_super() before journal destruction to
ensure all pending EA inode cleanup completes while the journal is still
available.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/ext4.h  |  5 ++++
 fs/ext4/super.c |  6 ++++
 fs/ext4/xattr.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/xattr.h |  2 ++
 4 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..690202303269 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1706,6 +1706,11 @@ struct ext4_sb_info {
 	struct ext4_es_stats s_es_stats;
 	struct mb_cache *s_ea_block_cache;
 	struct mb_cache *s_ea_inode_cache;
+
+	/* Deferred iput for EA inodes to avoid lock ordering issues */
+	struct llist_head s_ea_inode_to_free;
+	struct work_struct s_ea_inode_work;
+
 	spinlock_t s_es_lock ____cacheline_aligned_in_smp;
 
 	/* Journal triggers for checksum computation */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..b777bb0a81ea 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1308,6 +1308,9 @@ static void ext4_put_super(struct super_block *sb)
 	destroy_workqueue(sbi->rsv_conversion_wq);
 	ext4_release_orphan_info(sb);
 
+	/* Flush deferred EA inode iputs before destroying journal */
+	flush_work(&sbi->s_ea_inode_work);
+
 	if (sbi->s_journal) {
 		aborted = is_journal_aborted(sbi->s_journal);
 		err = ext4_journal_destroy(sbi, sbi->s_journal);
@@ -5535,6 +5538,9 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		needs_recovery = 0;
 	}
 
+	init_llist_head(&sbi->s_ea_inode_to_free);
+	INIT_WORK(&sbi->s_ea_inode_work, ext4_ea_inode_work);
+
 	if (!test_opt(sb, NO_MBCACHE)) {
 		sbi->s_ea_block_cache = ext4_xattr_create_cache();
 		if (!sbi->s_ea_block_cache) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..04e7f674340d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -117,6 +117,8 @@ const struct xattr_handler * const ext4_xattr_handlers[] = {
 static int
 ext4_expand_inode_array(struct ext4_xattr_inode_array **ea_inode_array,
 			struct inode *inode);
+static void ext4_xattr_inode_array_free_deferred(struct super_block *sb,
+				struct ext4_xattr_inode_array *array);
 
 #ifdef CONFIG_LOCKDEP
 void ext4_xattr_inode_set_class(struct inode *ea_inode)
@@ -2187,7 +2189,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 		ext4_xattr_release_block(handle, inode, bs->bh,
 					 &ea_inode_array,
 					 0 /* extra_credits */);
-		ext4_xattr_inode_array_free(ea_inode_array);
+		ext4_xattr_inode_array_free_deferred(inode->i_sb,
+						     ea_inode_array);
 	}
 	error = 0;
 
@@ -3025,6 +3028,74 @@ void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *ea_inode_array)
 	kfree(ea_inode_array);
 }
 
+static void ext4_xattr_inode_array_free_deferred(struct super_block *sb,
+				struct ext4_xattr_inode_array *array)
+{
+	int idx;
+
+	if (array == NULL)
+		return;
+
+	for (idx = 0; idx < array->count; ++idx)
+		ext4_put_ea_inode(sb, array->inodes[idx]);
+	kfree(array);
+}
+
+struct ext4_ea_iput_entry {
+	struct llist_node node;
+	struct inode *inode;
+};
+
+/*
+ * Worker function for deferred EA inode iput.  Processes all inodes queued
+ * on s_ea_inode_to_free in a context free of xattr_sem/jbd2 handle locks.
+ */
+void ext4_ea_inode_work(struct work_struct *work)
+{
+	struct ext4_sb_info *sbi = container_of(work, struct ext4_sb_info,
+						s_ea_inode_work);
+	struct llist_node *node = llist_del_all(&sbi->s_ea_inode_to_free);
+	struct llist_node *next;
+
+	while (node) {
+		struct ext4_ea_iput_entry *entry = container_of(node,
+				struct ext4_ea_iput_entry, node);
+		next = node->next;
+		iput(entry->inode);
+		kfree(entry);
+		node = next;
+	}
+}
+
+/*
+ * Release a VFS reference on an EA inode after ext4_xattr_inode_dec_ref()
+ * may have set i_nlink=0.  Must be used instead of iput() in any context
+ * where xattr_sem or a jbd2 handle is held, because eviction of a nlink=0
+ * inode can acquire those same locks.
+ *
+ * When SB_ACTIVE, eviction does not call write_inode_now() so direct
+ * iput() is safe.  During mount (!SB_ACTIVE), defer to a workqueue.
+ *
+ * For EA inode references dropped without a preceding dec_ref (e.g.,
+ * lookup-only paths where nlink remains >= 1), plain iput() is safe
+ * and preferred.
+ */
+void ext4_put_ea_inode(struct super_block *sb, struct inode *inode)
+{
+	struct ext4_ea_iput_entry *entry;
+
+	if (!inode)
+		return;
+	if (sb->s_flags & SB_ACTIVE) {
+		iput(inode);
+		return;
+	}
+	entry = kmalloc(sizeof(*entry), GFP_NOFS | __GFP_NOFAIL);
+	entry->inode = inode;
+	llist_add(&entry->node, &EXT4_SB(sb)->s_ea_inode_to_free);
+	schedule_work(&EXT4_SB(sb)->s_ea_inode_work);
+}
+
 /*
  * ext4_xattr_block_cache_insert()
  *
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 1fedf44d4fb6..52074537dce5 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -190,6 +190,8 @@ extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 				   struct ext4_xattr_inode_array **array,
 				   int extra_credits);
 extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
+extern void ext4_ea_inode_work(struct work_struct *work);
+extern void ext4_put_ea_inode(struct super_block *sb, struct inode *inode);
 
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			    struct ext4_inode *raw_inode, handle_t *handle);
-- 
2.43.0

