Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C183C584E;
	Tue, 23 Jun 2026 08:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782204815; cv=none; b=kmnf7llTFbIAAeP9Ep9Kmax5vrqHs6SBTTI1fExWk41Zjd0VjeawIbRumj1+X+9x3Nbmoh3847l818h0m1G0Iy5fmdiTbwmKhv1rJZ3YqAAoZiMovuGoGBEE5Bb3ucgDwpp662KURV84HrFMO4qj3gtNYjKuN4QZE6ToazggQmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782204815; c=relaxed/simple;
	bh=hrNDtYJvFo5NCCI75gbqt1lUEoxaKnppvuLqRJePoG8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OdsROgCQ3R+Rk5JU8UEs36tCNBlmEu3koJV+1cfx7ommFv+0LDH/d0w+/cZT1Lo1IqzkAXNqoRnH6arg5EBXCp0921aNSfzMCGObE+uWvkH6Ao0jlfHCV/AWXXKrpozji/cA/zeaDuiQ7m/2hyg0ceunER0yFAim6c9Vjqo2moM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=ZP3I0zuG; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="ZP3I0zuG"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N6k8DL3332013;
	Tue, 23 Jun 2026 08:52:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=qAXOZZNUoNqluU9bxZHSfFR1s1COk1/+U7dYLUznGXw=; b=
	ZP3I0zuGfRx60jgKDllEd8Fp3SyelLjqXCqk6mDlLOUrPUkuildSjGsTKOj0B0Il
	27v8aDEEjVRZTShAIbdbixXEeQr+ikc4Pg3uOxBVneZWBkvBwCX9MMxqLF3x+3Np
	rkR8ZjGDVrrdSCW7/SbyJKeUOTcAcS1Ma7jJIzHib/ttDd2dF6yyfMUR8dvid4WN
	iaKhBFuVG3/U7MzE8/SRBvkf34dE9VNvYlqs1HOLUtNrSfN1v1z9njWkwxjqDPXe
	CrbPENbUmxYE8Mn4HfPeAVdEpvrIv3oAVqumuKu5clCQHzjJ86WYdZSYTU6foTI7
	65lbdiaP8coZfBGUY0dZIg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wu86a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 23 Jun 2026 08:52:55 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 23 Jun 2026 01:52:53 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 23 Jun 2026 01:52:50 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yun.zhou@windriver.com>
Subject: [PATCH v9 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
Date: Tue, 23 Jun 2026 16:52:41 +0800
Message-ID: <20260623085243.2816425-3-yun.zhou@windriver.com>
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
X-Proofpoint-ORIG-GUID: -FL5dj1LmekrLxs8UAc65vxgcNjKRR2g
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA3MCBTYWx0ZWRfX8LRQi9sdCTLE
 S3VWyvS6628N1kiAGZC/xxtJs9HB/gat5AepvtKBys7KBxvo1h+sp+GAJai+yki5KeENAHkTOIi
 +0LRAPyhu1M73QtZasqIxkYFso5WZNczc+oumjJO3r85J03897as
X-Proofpoint-GUID: -FL5dj1LmekrLxs8UAc65vxgcNjKRR2g
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a3a4967 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=4Ta5HVQVmfPmxTEC2QIA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA3MCBTYWx0ZWRfX518r3SQ+ndJB
 jfdYEYUJbSY7oDR02JmieP2EdKiYzV45fnFfdSOhKa/Ghyx+/0RHMrijF6Y1D857fC7N0Hh3tF0
 WyItXYcGoLCwB6vnmbWvK1zCnv3irbLPl/d4i884XBRnTa0O6KjTUvCDMcrJtyCck+BXOW/uc0o
 ZGXQtsY+W8V1jtA/QMT0+kxlki1DO9Iwr8IIrJ5kyIxhEpCqstCWfsJfPyDPykFD2t8jj6DP7/U
 9b4N2uCKLFqFb1iNSmJ0Lq4ZvlsTqlVepHU1gNPDwubuOUq53IyFF0T2HjxoHepibY6EsuSj2qo
 fr+1n0fTd++l8mw9kn9JcJuBkJdI3TXLax+1lrZRPKc7sNR9LmpxgYKyjPu+GYDF5cqRr/1nSYY
 HPGzjkb4moA/Ky8VAGzYh7Fx7tq8x7nHek4s3644KHkKK3c9O0uIgjq8+b26yE8F6q4mEpBsRJO
 3DwUFgAcUbrkhZw5xEg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230070

Calling iput() on EA inodes while holding xattr_sem or a jbd2 handle
can trigger write_inode_now() -> ext4_writepages() -> s_writepages_rwsem,
creating a lock ordering issue during mount (!SB_ACTIVE).

Add ext4_put_ea_inode() which uses iput_if_not_last() as a fast path.
If this is not the last reference, it is dropped immediately.  If this
is the last reference, the inode is linked onto a per-sb lock-free llist
via i_ea_iput_node (embedded in ext4_inode_info, sharing space with the
unused xattr_sem of EA inodes via a union) and a delayed worker
(1 jiffie) performs the final iput() in a clean context.  This avoids
per-iput memory allocation.

Convert the first call site: ext4_xattr_block_set()'s "Drop the
previous xattr block" path, which previously called
ext4_xattr_inode_array_free() under xattr_sem + jbd2 handle.

The worker is drained in ext4_put_super() before quota shutdown using
a loop to handle re-arming (evicting an EA inode may queue further EA
inodes). Initialization is placed before journal loading since fast
commit replay may trigger evictions that call ext4_put_ea_inode().

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Suggested-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  | 13 ++++++++-
 fs/ext4/super.c | 18 +++++++++++-
 fs/ext4/xattr.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/xattr.h | 14 ++++++++++
 4 files changed, 115 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..b9b0ada7774b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1070,8 +1070,14 @@ struct ext4_inode_info {
 	 * between readers of EAs and writers of regular file data, so
 	 * instead we synchronize on xattr_sem when reading or changing
 	 * EAs.
+	 *
+	 * EA inodes (EXT4_EA_INODE_FL) do not use xattr_sem; they reuse
+	 * the space for deferred iput linkage.
 	 */
-	struct rw_semaphore xattr_sem;
+	union {
+		struct rw_semaphore xattr_sem;
+		struct llist_node i_ea_iput_node;
+	};
 
 	/*
 	 * Inodes with EXT4_STATE_ORPHAN_FILE use i_orphan_idx. Otherwise
@@ -1770,6 +1776,11 @@ struct ext4_sb_info {
 	struct ext4_es_stats s_es_stats;
 	struct mb_cache *s_ea_block_cache;
 	struct mb_cache *s_ea_inode_cache;
+
+	/* Deferred iput for EA inodes to avoid lock ordering issues */
+	struct llist_head s_ea_inode_to_free;
+	struct delayed_work s_ea_inode_work;
+
 	spinlock_t s_es_lock ____cacheline_aligned_in_smp;
 
 	/* Journal triggers for checksum computation */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 245f67d10ded..97f0e7c1b254 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1303,6 +1303,8 @@ static void ext4_put_super(struct super_block *sb)
 			 &sb->s_uuid);
 
 	ext4_unregister_li_request(sb);
+	/* Drain deferred EA inode iputs while quota is still active. */
+	ext4_drain_ea_inode_work(sbi);
 	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
 
 	destroy_workqueue(sbi->rsv_conversion_wq);
@@ -1423,6 +1425,13 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
 	ei->jinode = NULL;
+	/*
+	 * Reinitialize xattr_sem every allocation because EA inodes
+	 * share this space with i_ea_iput_node (via union) which may
+	 * have overwritten the semaphore when the slab object was
+	 * previously used as an EA inode.
+	 */
+	init_rwsem(&ei->xattr_sem);
 	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
 	spin_lock_init(&ei->i_completed_io_lock);
 	ei->i_sync_tid = 0;
@@ -1488,7 +1497,6 @@ static void init_once(void *foo)
 	struct ext4_inode_info *ei = foo;
 
 	INIT_LIST_HEAD(&ei->i_orphan);
-	init_rwsem(&ei->xattr_sem);
 	init_rwsem(&ei->i_data_sem);
 	inode_init_once(&ei->vfs_inode);
 	ext4_fc_init_inode(&ei->vfs_inode);
@@ -5508,6 +5516,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	 * The first inode we look at is the journal inode.  Don't try
 	 * root first: it may be modified in the journal!
 	 */
+	ext4_init_ea_inode_work(sbi);
+
 	if (!test_opt(sb, NOLOAD) && ext4_has_feature_journal(sb)) {
 		err = ext4_load_and_init_journal(sb, es, ctx);
 		if (err)
@@ -5747,6 +5757,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	return 0;
 
 failed_mount9:
+	/* Drain deferred EA inode iputs before quota shutdown */
+	ext4_drain_ea_inode_work(sbi);
 	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
 failed_mount8: __maybe_unused
 	ext4_release_orphan_info(sb);
@@ -5767,6 +5779,8 @@ failed_mount8: __maybe_unused
 	if (EXT4_SB(sb)->rsv_conversion_wq)
 		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
 failed_mount_wq:
+	/* Drain deferred EA inode iputs before freeing structures */
+	ext4_drain_ea_inode_work(sbi);
 	ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
 	sbi->s_ea_inode_cache = NULL;
 
@@ -5777,6 +5791,8 @@ failed_mount8: __maybe_unused
 		ext4_journal_destroy(sbi, sbi->s_journal);
 	}
 failed_mount3a:
+	/* Drain deferred EA inode iputs from journal replay */
+	ext4_drain_ea_inode_work(sbi);
 	ext4_es_unregister_shrinker(sbi);
 failed_mount3:
 	/* flush s_sb_upd_work before sbi destroy */
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..ecdad5920b14 100644
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
+/*
+ * Worker function for deferred EA inode iput.  Processes all inodes queued
+ * on s_ea_inode_to_free in a context free of xattr_sem/jbd2 handle locks.
+ */
+static void ext4_ea_inode_work(struct work_struct *work)
+{
+	struct ext4_sb_info *sbi = container_of(to_delayed_work(work),
+						struct ext4_sb_info,
+						s_ea_inode_work);
+	struct llist_node *node = llist_del_all(&sbi->s_ea_inode_to_free);
+	struct llist_node *next;
+
+	while (node) {
+		struct ext4_inode_info *ei = container_of(node,
+					struct ext4_inode_info, i_ea_iput_node);
+		next = node->next;
+		iput(&ei->vfs_inode);
+		node = next;
+	}
+}
+
+/*
+ * Release a VFS reference on an EA inode.  Must be used instead of iput()
+ * in any context where xattr_sem or a jbd2 handle is held.
+ *
+ * If this is not the last reference, drops it immediately via
+ * iput_if_not_last() with no further action needed.
+ *
+ * If this is the last reference, the inode is linked onto a per-sb
+ * llist via i_ea_iput_node (embedded in ext4_inode_info, sharing space
+ * with the unused xattr_sem) and a delayed worker performs the final
+ * iput() in a clean context.
+ */
+void ext4_put_ea_inode(struct super_block *sb, struct inode *inode)
+{
+	if (!inode)
+		return;
+	WARN_ON_ONCE(!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL));
+	if (iput_if_not_last(inode))
+		return;
+	llist_add(&EXT4_I(inode)->i_ea_iput_node,
+		  &EXT4_SB(sb)->s_ea_inode_to_free);
+	/*
+	 * Use a short delay to allow multiple EA inodes to accumulate,
+	 * reducing workqueue wakeups when several are released together.
+	 */
+	schedule_delayed_work(&EXT4_SB(sb)->s_ea_inode_work, 1);
+}
+
+void ext4_init_ea_inode_work(struct ext4_sb_info *sbi)
+{
+	init_llist_head(&sbi->s_ea_inode_to_free);
+	INIT_DELAYED_WORK(&sbi->s_ea_inode_work, ext4_ea_inode_work);
+}
+
 /*
  * ext4_xattr_block_cache_insert()
  *
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 1fedf44d4fb6..9883ba5569a1 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -190,6 +190,20 @@ extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 				   struct ext4_xattr_inode_array **array,
 				   int extra_credits);
 extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
+extern void ext4_init_ea_inode_work(struct ext4_sb_info *sbi);
+extern void ext4_put_ea_inode(struct super_block *sb, struct inode *inode);
+
+/*
+ * Drain all pending deferred EA inode iputs.  Must be called before
+ * freeing resources that eviction depends on (quota, block allocator).
+ * Loops because worker iput may trigger eviction that re-queues.
+ */
+static inline void ext4_drain_ea_inode_work(struct ext4_sb_info *sbi)
+{
+	while (flush_delayed_work(&sbi->s_ea_inode_work) ||
+	       !llist_empty(&sbi->s_ea_inode_to_free))
+		;
+}
 
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			    struct ext4_inode *raw_inode, handle_t *handle);
-- 
2.43.0

