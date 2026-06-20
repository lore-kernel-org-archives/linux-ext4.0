Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213D91898FB;
	Sat, 20 Jun 2026 01:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781919624; cv=none; b=rxGVtTHpnTGK+jeKVLDjHVDvAZkQm0NniBHbvfJ8qvOr1WFEfZx3mSfq6dSIr32uICSF06g9qmMZRtDSRk30d6RnoLe35vGOgAAhzpxSdgf7AHtBEAb5FuS6ibr3s7RC7dnDOn395ZLYQjNrd+DiU4MaWVn2W1ZZxoSFeak4qPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781919624; c=relaxed/simple;
	bh=AhF7UtnzUt7YC173cyifMQsKtLZ6SZ32VCqSdhm2xT4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DABG3GfR73UyF8M5ov/DvFsycu8TLZo1gL20T1CMAymOg30ybqHE/+5pPpCS6fzF+IMKvl8xTS43VJ5AW+VOzb74sm3cnRmlguTmFmt3dPsfU/MwvRq7Z/pJtPkB4bD2RoUyxvGKY57NpeugjegYTSB8An16MqJ+4XWBRFTtYm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=CHRqvz0t; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="CHRqvz0t"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65K1X0J03345508;
	Sat, 20 Jun 2026 01:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=jLu8x/kEHKiUmqYhWkkmiBvShKMcs1Lwvvc+/XrWRLs=; b=
	CHRqvz0tyTku0B4COjOKf89I9A5s4lf3ne7l/bPh9GG0r5jtOENAMoRmhSPc4llR
	qxQIgAbSANSOP+BvMGueBB8gpUku4sGDbHoPoy/xZf/Of+IAfe4DH1UqM4R9hdH6
	jyLyJtsnBqJhErmo8HlKeaRwNEu6az8gOjnFvFAEM7fZq+lXyE83lMYQMSbAL5Dw
	g7Uxs2TMd8J4cye0Rr1XwuAy2xignHpvsZ5YI6kNvI5XZ9g4SKWXxLmfgS5iTATj
	nO/OkMi9pNMtfbl5Cw5QrkR0QxGNtlSs2xfUmoppkK5hE9P5RqyfoCWxUQi4x+/p
	RFgzi9HhQZynp7uyZKOSkg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4euef856fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 20 Jun 2026 01:39:50 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 19 Jun 2026 18:39:49 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 19 Jun 2026 18:39:46 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v8 3/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
Date: Sat, 20 Jun 2026 09:39:36 +0800
Message-ID: <20260620013937.2564269-4-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260620013937.2564269-1-yun.zhou@windriver.com>
References: <20260620013937.2564269-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PxTjUjPUAWEs5PU4hIO_DAd6QfsYYlSP
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIwMDAxNCBTYWx0ZWRfX3O5Kx6wI+zcD
 yI2+fJW1xDnC66qjkG8vkVGWGHKbqHEWvNrMgtdy8YXB3Yaq07rhQWjuL0uK0EcvRyoqRqcouz9
 Utqaf7+54a5MU0UO0sIBPrh04LOGnycbeeTKeMEg0KoCmqHWaWaC
X-Authority-Analysis: v=2.4 cv=auCCzyZV c=1 sm=1 tr=0 ts=6a35ef66 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=t7CeM3EgAAAA:8 a=Ky6gILQtogqK_uh6bJ4A:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: PxTjUjPUAWEs5PU4hIO_DAd6QfsYYlSP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIwMDAxNCBTYWx0ZWRfX8kxmUJRiy0k4
 4ltcxXrUtYeQhZrXnpxdqODfgI9+qxxvukuj22ZCebrVOsaejXu0rpSz6pRCOXv0mDl8fs383qa
 9bvfsxVY7BI3V7M3iyr84Le8fY2T2ewQD2By7N1ShKSf1qyvJO/oHrAEiWSNryAcx11t17mo6yy
 z741RWdgQnIZnKYQtA3J1DfQiB0k/JLMwOdeOwzsZGbsbWeR6UYQbfJINFpvT+H1mjRw+dU4lu2
 uRuXAMrXofdeU6xUxj3hW5nHU1kEDWDMTRBlJB/6YkH3XuSSiaYAsRslChgvZDdqSykQETjqxob
 r3qCxsVDaqJ4/Y7ou6/2CQOVemFAoGzXNgidHud2N34LSeU0uZec/3bOsF8k9V+9+3b4hqgw0Hp
 jwF1E44CwVbSDFv/dyI7gWq6le5yscmeU2qNf+8GIrOXNK3M5LeRMenu34BeJ6TNI18b/2OZB2q
 HHbTOOtC8OkLFKCVSmw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_05,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606200014

Calling iput() on EA inodes while holding xattr_sem or a jbd2 handle
can trigger write_inode_now() -> ext4_writepages() -> s_writepages_rwsem,
creating a lock ordering issue during mount (!SB_ACTIVE).

Add ext4_put_ea_inode() which safely releases EA inode references:
when SB_ACTIVE, it calls iput() directly (write_inode_now cannot be
triggered); during mount (!SB_ACTIVE), it queues the inode on a per-sb
lock-free llist and schedules a delayed worker (1 jiffie) to call iput()
in a clean context without holding any ext4 locks.  The delay allows
multiple inodes to accumulate before the worker runs, reducing context
switches.

Convert the iput in ext4_xattr_block_set()'s "Drop the previous xattr
block" path to use ext4_xattr_inode_array_free_deferred(), which
releases EA inodes via ext4_put_ea_inode().  This path previously called
ext4_xattr_inode_array_free() (synchronous iput) while holding xattr_sem
and a jbd2 handle.

The worker is flushed in ext4_put_super() before quota shutdown to
ensure all pending EA inode cleanup completes while quota accounting
is still active.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/ext4.h  |  5 ++++
 fs/ext4/super.c |  6 ++++
 fs/ext4/xattr.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/xattr.h |  2 ++
 4 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..e31d60f82a63 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1706,6 +1706,11 @@ struct ext4_sb_info {
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
index 6a77db4d3124..5dd7c29a70bc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1303,6 +1303,8 @@ static void ext4_put_super(struct super_block *sb)
 			 &sb->s_uuid);
 
 	ext4_unregister_li_request(sb);
+	/* Flush deferred EA inode iputs while quota is still active */
+	flush_delayed_work(&sbi->s_ea_inode_work);
 	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
 
 	destroy_workqueue(sbi->rsv_conversion_wq);
@@ -5535,6 +5537,9 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		needs_recovery = 0;
 	}
 
+	init_llist_head(&sbi->s_ea_inode_to_free);
+	INIT_DELAYED_WORK(&sbi->s_ea_inode_work, ext4_ea_inode_work);
+
 	if (!test_opt(sb, NO_MBCACHE)) {
 		sbi->s_ea_block_cache = ext4_xattr_create_cache();
 		if (!sbi->s_ea_block_cache) {
@@ -5763,6 +5768,7 @@ failed_mount8: __maybe_unused
 	if (EXT4_SB(sb)->rsv_conversion_wq)
 		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
 failed_mount_wq:
+	flush_delayed_work(&sbi->s_ea_inode_work);
 	ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
 	sbi->s_ea_inode_cache = NULL;
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..79de182e22e6 100644
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
 
@@ -3025,6 +3028,75 @@ void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *ea_inode_array)
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
+	struct ext4_sb_info *sbi = container_of(to_delayed_work(work),
+						struct ext4_sb_info,
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
+	schedule_delayed_work(&EXT4_SB(sb)->s_ea_inode_work, 1);
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

