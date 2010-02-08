From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 03/11] quota: sb_quota state flags cleanup
Date: Mon, 08 Feb 2010 16:28:05 +0300
Message-ID: <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33218 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab0BHO21 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:27 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:01 +0300 (MSK)
In-reply-to: <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- remove hardcoded USRQUOTA/GRPQUOTA flags
- convert int to bool for appropriate functions

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 include/linux/quota.h    |   15 +++++++--------
 include/linux/quotaops.h |   31 +++++++++++++++++--------------
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/include/linux/quota.h b/include/linux/quota.h
index a6861f1..1f1a3a1 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -357,26 +357,25 @@ enum {
 #define DQUOT_STATE_FLAGS	(DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED | \
 				 DQUOT_SUSPENDED)
 /* Other quota flags */
-#define DQUOT_QUOTA_SYS_FILE	(1 << 6)	/* Quota file is a special
+#define DQUOT_STATE_LAST	(_DQUOT_STATE_FLAGS * MAXQUOTAS)
+#define DQUOT_QUOTA_SYS_FILE	(1 << DQUOT_STATE_LAST)
+						/* Quota file is a special
 						 * system file and user cannot
 						 * touch it. Filesystem is
 						 * responsible for setting
 						 * S_NOQUOTA, S_NOATIME flags
 						 */
-#define DQUOT_NEGATIVE_USAGE	(1 << 7)	/* Allow negative quota usage */
+#define DQUOT_NEGATIVE_USAGE	(1 << (DQUOT_STATE_LAST + 1))
+					       /* Allow negative quota usage */
 
 static inline unsigned int dquot_state_flag(unsigned int flags, int type)
 {
-	if (type == USRQUOTA)
-		return flags;
-	return flags << _DQUOT_STATE_FLAGS;
+	return flags << _DQUOT_STATE_FLAGS * type;
 }
 
 static inline unsigned int dquot_generic_flag(unsigned int flags, int type)
 {
-	if (type == USRQUOTA)
-		return flags;
-	return flags >> _DQUOT_STATE_FLAGS;
+	return (flags >> _DQUOT_STATE_FLAGS * type) & DQUOT_STATE_FLAGS;
 }
 
 #ifdef CONFIG_QUOTA_NETLINK_INTERFACE
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 3ebb231..70de499 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -83,53 +83,56 @@ static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
  * Functions for checking status of quota
  */
 
-static inline int sb_has_quota_usage_enabled(struct super_block *sb, int type)
+static inline bool sb_has_quota_usage_enabled(struct super_block *sb, int type)
 {
 	return sb_dqopt(sb)->flags &
 				dquot_state_flag(DQUOT_USAGE_ENABLED, type);
 }
 
-static inline int sb_has_quota_limits_enabled(struct super_block *sb, int type)
+static inline bool sb_has_quota_limits_enabled(struct super_block *sb, int type)
 {
 	return sb_dqopt(sb)->flags &
 				dquot_state_flag(DQUOT_LIMITS_ENABLED, type);
 }
 
-static inline int sb_has_quota_suspended(struct super_block *sb, int type)
+static inline bool sb_has_quota_suspended(struct super_block *sb, int type)
 {
 	return sb_dqopt(sb)->flags &
 				dquot_state_flag(DQUOT_SUSPENDED, type);
 }
 
-static inline int sb_any_quota_suspended(struct super_block *sb)
+static inline unsigned sb_any_quota_suspended(struct super_block *sb)
 {
-	return sb_has_quota_suspended(sb, USRQUOTA) ||
-		sb_has_quota_suspended(sb, GRPQUOTA);
+	unsigned type, tmsk = 0;
+	for (type = 0; type < MAXQUOTAS; type++)
+		tmsk |= sb_has_quota_suspended(sb, type) << type;
+	return tmsk;
 }
 
 /* Does kernel know about any quota information for given sb + type? */
-static inline int sb_has_quota_loaded(struct super_block *sb, int type)
+static inline bool sb_has_quota_loaded(struct super_block *sb, int type)
 {
 	/* Currently if anything is on, then quota usage is on as well */
 	return sb_has_quota_usage_enabled(sb, type);
 }
 
-static inline int sb_any_quota_loaded(struct super_block *sb)
+static inline unsigned sb_any_quota_loaded(struct super_block *sb)
 {
-	return sb_has_quota_loaded(sb, USRQUOTA) ||
-		sb_has_quota_loaded(sb, GRPQUOTA);
+	unsigned type, tmsk = 0;
+	for (type = 0; type < MAXQUOTAS; type++)
+		tmsk |= sb_has_quota_loaded(sb, type) << type;
+	return	tmsk;
 }
 
-static inline int sb_has_quota_active(struct super_block *sb, int type)
+static inline bool sb_has_quota_active(struct super_block *sb, int type)
 {
 	return sb_has_quota_loaded(sb, type) &&
 	       !sb_has_quota_suspended(sb, type);
 }
 
-static inline int sb_any_quota_active(struct super_block *sb)
+static inline unsigned sb_any_quota_active(struct super_block *sb)
 {
-	return sb_has_quota_active(sb, USRQUOTA) ||
-	       sb_has_quota_active(sb, GRPQUOTA);
+	return sb_any_quota_loaded(sb) & ~sb_any_quota_suspended(sb);
 }
 
 /*
-- 
1.6.3.3

