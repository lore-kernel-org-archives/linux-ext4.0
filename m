From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3] quota: use flags interface for dquot alloc/free space
Date: Wed, 07 Apr 2010 16:49:05 -0500
Message-ID: <4BBCFDD1.30505@redhat.com>
References: <4BBCFD10.3030504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab0DGVtM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 17:49:12 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o37LnC9N031851
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Apr 2010 17:49:12 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o37Ln5tF012635
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Apr 2010 17:49:11 -0400
In-Reply-To: <4BBCFD10.3030504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Switch __dquot_alloc_space and __dquot_free_space to take flags
to indicate whether to warn and/or to reserve (or free reserve).

This is slightly more readable at the callpoints, and makes it
cleaner to add a "nofail" option in the next patch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index e0b870f..8436d9b 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1484,11 +1484,12 @@ static void inode_decr_space(struct inode *inode, qsize_t number, int reserve)
 /*
  * This operation can block, but only after everything is updated
  */
-int __dquot_alloc_space(struct inode *inode, qsize_t number,
-		int warn, int reserve)
+int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 {
 	int cnt, ret = 0;
 	char warntype[MAXQUOTAS];
+	int warn = flags & DQUOT_SPACE_WARN;
+	int reserve = flags & DQUOT_SPACE_RESERVE;
 
 	/*
 	 * First test before acquiring mutex - solves deadlocks when we
@@ -1608,10 +1609,11 @@ EXPORT_SYMBOL(dquot_claim_space_nodirty);
 /*
  * This operation can block, but only after everything is updated
  */
-void __dquot_free_space(struct inode *inode, qsize_t number, int reserve)
+void __dquot_free_space(struct inode *inode, qsize_t number, int flags)
 {
 	unsigned int cnt;
 	char warntype[MAXQUOTAS];
+	int reserve = flags & DQUOT_SPACE_RESERVE;
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index e6fa7ac..daa106f 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -14,6 +14,9 @@ static inline struct quota_info *sb_dqopt(struct super_block *sb)
 	return &sb->s_dquot;
 }
 
+#define DQUOT_SPACE_WARN	0x1
+#define DQUOT_SPACE_RESERVE	0x2
+
 #if defined(CONFIG_QUOTA)
 
 /*
@@ -33,9 +36,8 @@ int dquot_scan_active(struct super_block *sb,
 struct dquot *dquot_alloc(struct super_block *sb, int type);
 void dquot_destroy(struct dquot *dquot);
 
-int __dquot_alloc_space(struct inode *inode, qsize_t number,
-		int warn, int reserve);
-void __dquot_free_space(struct inode *inode, qsize_t number, int reserve);
+int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags);
+void __dquot_free_space(struct inode *inode, qsize_t number, int flags);
 
 int dquot_alloc_inode(const struct inode *inode);
 
@@ -231,17 +233,17 @@ static inline int dquot_transfer(struct inode *inode, struct iattr *iattr)
 }
 
 static inline int __dquot_alloc_space(struct inode *inode, qsize_t number,
-		int warn, int reserve)
+		int flags)
 {
-	if (!reserve)
+	if (!(flags & DQUOT_SPACE_RESERVE))
 		inode_add_bytes(inode, number);
 	return 0;
 }
 
 static inline void __dquot_free_space(struct inode *inode, qsize_t number,
-		int reserve)
+		int flags)
 {
-	if (!reserve)
+	if (!(flags & DQUOT_SPACE_RESERVE))
 		inode_sub_bytes(inode, number);
 }
 
@@ -257,7 +259,7 @@ static inline int dquot_claim_space_nodirty(struct inode *inode, qsize_t number)
 
 static inline int dquot_alloc_space_nodirty(struct inode *inode, qsize_t nr)
 {
-	return __dquot_alloc_space(inode, nr, 1, 0);
+	return __dquot_alloc_space(inode, nr, DQUOT_SPACE_WARN);
 }
 
 static inline int dquot_alloc_space(struct inode *inode, qsize_t nr)
@@ -282,7 +284,7 @@ static inline int dquot_alloc_block(struct inode *inode, qsize_t nr)
 
 static inline int dquot_prealloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	return __dquot_alloc_space(inode, nr << inode->i_blkbits, 0, 0);
+	return __dquot_alloc_space(inode, nr << inode->i_blkbits, 0);
 }
 
 static inline int dquot_prealloc_block(struct inode *inode, qsize_t nr)
@@ -297,7 +299,8 @@ static inline int dquot_prealloc_block(struct inode *inode, qsize_t nr)
 
 static inline int dquot_reserve_block(struct inode *inode, qsize_t nr)
 {
-	return __dquot_alloc_space(inode, nr << inode->i_blkbits, 1, 1);
+	return __dquot_alloc_space(inode, nr << inode->i_blkbits,
+				DQUOT_SPACE_WARN|DQUOT_SPACE_RESERVE);
 }
 
 static inline int dquot_claim_block(struct inode *inode, qsize_t nr)
@@ -334,7 +337,7 @@ static inline void dquot_free_block(struct inode *inode, qsize_t nr)
 static inline void dquot_release_reservation_block(struct inode *inode,
 		qsize_t nr)
 {
-	__dquot_free_space(inode, nr << inode->i_blkbits, 1);
+	__dquot_free_space(inode, nr << inode->i_blkbits, DQUOT_SPACE_RESERVE);
 }
 
 #endif /* _LINUX_QUOTAOPS_ */

