From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/3] quota: add the option to not fail with EDQUOT in block
 allocation
Date: Wed, 07 Apr 2010 16:52:28 -0500
Message-ID: <4BBCFE9C.4070302@redhat.com>
References: <4BBCFD10.3030504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123Ab0DGVw6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 17:52:58 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o37Lqvw8018997
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Apr 2010 17:52:58 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o37LqStR006399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Apr 2010 17:52:57 -0400
In-Reply-To: <4BBCFD10.3030504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To simplify metadata tracking for delalloc writes, ext4
will simply claim metadata blocks at allocation time, without
first speculatively reserving the worst case and then freeing
what was not used.

To do this, we need a mechanism to track allocations in
the quota subsystem, but potentially allow that allocation
to actually go over quota.

This patch adds a DQUOT_SPACE_NOFAIL flag and function
variants for this purpose.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 8436d9b..c38b137 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1490,6 +1490,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 	char warntype[MAXQUOTAS];
 	int warn = flags & DQUOT_SPACE_WARN;
 	int reserve = flags & DQUOT_SPACE_RESERVE;
+	int nofail = flags & DQUOT_SPACE_NOFAIL;
 
 	/*
 	 * First test before acquiring mutex - solves deadlocks when we
@@ -1510,7 +1511,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 			continue;
 		ret = check_bdq(inode->i_dquot[cnt], number, !warn,
 				warntype+cnt);
-		if (ret) {
+		if (ret && !nofail) {
 			spin_unlock(&dq_data_lock);
 			goto out_flush_warn;
 		}
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index daa106f..8f858ce 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -16,6 +16,7 @@ static inline struct quota_info *sb_dqopt(struct super_block *sb)
 
 #define DQUOT_SPACE_WARN	0x1
 #define DQUOT_SPACE_RESERVE	0x2
+#define DQUOT_SPACE_NOFAIL	0x4
 
 #if defined(CONFIG_QUOTA)
 
@@ -262,6 +263,12 @@ static inline int dquot_alloc_space_nodirty(struct inode *inode, qsize_t nr)
 	return __dquot_alloc_space(inode, nr, DQUOT_SPACE_WARN);
 }
 
+static inline void dquot_alloc_space_nofail(struct inode *inode, qsize_t nr)
+{
+	__dquot_alloc_space(inode, nr, DQUOT_SPACE_WARN|DQUOT_SPACE_NOFAIL);
+	mark_inode_dirty(inode);
+}
+
 static inline int dquot_alloc_space(struct inode *inode, qsize_t nr)
 {
 	int ret;
@@ -277,6 +284,11 @@ static inline int dquot_alloc_block_nodirty(struct inode *inode, qsize_t nr)
 	return dquot_alloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
+static inline void dquot_alloc_block_nofail(struct inode *inode, qsize_t nr)
+{
+	dquot_alloc_space_nofail(inode, nr << inode->i_blkbits);
+}
+
 static inline int dquot_alloc_block(struct inode *inode, qsize_t nr)
 {
 	return dquot_alloc_space(inode, nr << inode->i_blkbits);

