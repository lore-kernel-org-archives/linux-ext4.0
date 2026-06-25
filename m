Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8800231A41;
	Thu, 25 Jun 2026 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782401423; cv=none; b=Rpi4oWLs1IebtHcRnQsA1teiutkakV6nrQ7aYtAX4sEZ8BG+LsvxNkY9XgXv+EkwnjMof8fPiNZ1x5bdQ7BcTBX1jqdJVtH3J3R98SLPCjnFzCs6+hNQAZ1A0hjW/+81LETsqqPgt5dsp64ilWrIudEVImb59VZ2zHw6oIzPvZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782401423; c=relaxed/simple;
	bh=9uzkUog+OkO9/EyICCbM0CkiIRtnV67QXMvBrcAtBDY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j5WIngrdeEd+NavoOeIcvYrcqTpgcVYwdPfhJURVXoCtZFoiZNRXSn8zkwpIOv/D307NrYBLO263P7sM2FOv+3rzxn4r8U+9kLrtZsi+laG3msqYeq1ODVOB7FRH8dAH3c7htET5BJiZLdiVlgqe8/opX2wWaGlgkb9ph7PV7rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=fnF2Njot; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="fnF2Njot"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65P4qI4J454569;
	Thu, 25 Jun 2026 15:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=8MFF4zp91y5T6SOhebpDreZs319n4a7u6sUrxBnuoMw=; b=
	fnF2NjotEJ5W7SwH1EJnV73KXY8WYKGTFd7pqAV3gNZy9bR1k1kaiefe2q48gFJ/
	NABo16kBIxN0I7g5VWQfZph7fBh0MGLwpqPcn1nLJW2CpMLlIpgzwvXPqPnGfWGD
	GIN4kJY7+t5aN0kcrSqG9X4MGjNlmdQXKajklcAwtDIJRa4dMqzxXHWCXkfgp2lj
	m8QxL5YJ4o+DBYq3RVcqpEWE0AJQWc7Eb+3k6PWOwEfjT2FlvKGqdniXe5bQqO3N
	a1/kG3BBHQCcgDj7m/YNbh7juS1lgKhmHzCJS68JqgCtnxXTPjXhEtqdkBPS4b4B
	DXjMPPAuAGxFPNRVZyoMbQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f0t5dgv8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 25 Jun 2026 15:29:54 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 25 Jun 2026 08:29:52 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 25 Jun 2026 08:29:49 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v10 2/5] ext4: introduce ext4_put_ea_inode() for safe deferred iput
Date: Thu, 25 Jun 2026 23:29:38 +0800
Message-ID: <20260625152941.24788-3-yun.zhou@windriver.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDEzMyBTYWx0ZWRfX6RfvhP/hJWqf
 s/vyo3HA4Ag1x0hdDOcJWhdGH5AhYUBitayyk7DQraAfOBMBbOeV4LkCv92A3RUjhlOH3g5T9Qp
 +38SKsiJNpyFI8hA2u6iDf7IJYJhiNdGl4O8GpcFhTmcSaDJGHVC
X-Authority-Analysis: v=2.4 cv=HOvz0Itv c=1 sm=1 tr=0 ts=6a3d4972 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=t7CeM3EgAAAA:8 a=4Ta5HVQVmfPmxTEC2QIA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: 1qVSOyJruWt7IQg6YIjiFPzLAubLk3OC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDEzMyBTYWx0ZWRfX8A5N/CYG/7r5
 Uu884rJde1PVT5YsgVPRDuv+4f2L6Z+8ZRhY0n/dk3Y0U0haMblrFvAK14sywjM5i2j0sJvNR0j
 LZyf1QHhSgO1EL4izNMKhARuxKpRDsiZlERlllPOKd/f337f92jkarsBY15d4NZY2oCWbquL2ms
 t8loPJDxkzFKvUlf4F0HysJ9HRasqx7zcp7iY4+90sPreysnqFF1OODQYgz4gmA30+1o14XlaiN
 r0RA564NQHnJiBCSB5CmAAmeyoHAZztcmsDlePXNk6z+rVDx6T5/5MzvSYWECVkQZvRA5vZCk3M
 7B1MNL5G9WqAIM7OFcpZREzDCJRKW+KIQvXy3hxTIUQx8I9Bj78uZVqsvbA+2TcL3gQUJWkyNSH
 4eDzDZm+0whne+bf7fgiAc4Nu4n/W5dNolOnvdgX93lfAf3oGwGw6bS8xGEMMYNztg+GkPZgFHu
 Wg1L/UiPFM3Wf5kDCxg==
X-Proofpoint-ORIG-GUID: 1qVSOyJruWt7IQg6YIjiFPzLAubLk3OC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_01,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606250133

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
inodes).  Initialization is placed before journal loading since fast
commit replay may trigger evictions that call ext4_put_ea_inode().

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Suggested-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  | 13 ++++++++-
 fs/ext4/super.c | 19 ++++++++++++-
 fs/ext4/xattr.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/xattr.h | 14 ++++++++++
 4 files changed, 116 insertions(+), 3 deletions(-)

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
index 245f67d10ded..ed1d0cad2bc2 100644
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
@@ -5497,6 +5505,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 			  ext4_has_feature_orphan_present(sb) ||
 			  ext4_has_feature_journal_needs_recovery(sb));
 
+	ext4_init_ea_inode_work(sbi);
+
 	if (ext4_has_feature_mmp(sb) && !sb_rdonly(sb)) {
 		err = ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block));
 		if (err)
@@ -5508,6 +5518,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	 * The first inode we look at is the journal inode.  Don't try
 	 * root first: it may be modified in the journal!
 	 */
+
 	if (!test_opt(sb, NOLOAD) && ext4_has_feature_journal(sb)) {
 		err = ext4_load_and_init_journal(sb, es, ctx);
 		if (err)
@@ -5747,6 +5758,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	return 0;
 
 failed_mount9:
+	/* Drain deferred EA inode iputs before quota shutdown */
+	ext4_drain_ea_inode_work(sbi);
 	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
 failed_mount8: __maybe_unused
 	ext4_release_orphan_info(sb);
@@ -5767,6 +5780,8 @@ failed_mount8: __maybe_unused
 	if (EXT4_SB(sb)->rsv_conversion_wq)
 		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
 failed_mount_wq:
+	/* Drain deferred EA inode iputs before freeing structures */
+	ext4_drain_ea_inode_work(sbi);
 	ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
 	sbi->s_ea_inode_cache = NULL;
 
@@ -5777,6 +5792,8 @@ failed_mount8: __maybe_unused
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

