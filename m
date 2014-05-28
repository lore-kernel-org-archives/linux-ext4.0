From: Niu Yawei <yawei.niu@gmail.com>
Subject: [PATCH 1/3 v2] quota: protect Q_GETFMT by dqonoff_mutex
Date: Wed, 28 May 2014 09:52:19 +0800
Message-ID: <53854153.40601@gmail.com>
References: <537DD5BA.1050105@gmail.com> <538464AD.6050407@gmail.com> <20140527101219.GA28035@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, lai.siyao@intel.com
To: Christoph Hellwig <hch@infradead.org>, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33426 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaE1BwM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 May 2014 21:52:12 -0400
In-Reply-To: <20140527101219.GA28035@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove dqptr_sem to make quota code scalable: Protect the
Q_GETFMT by dqonoff_mutex instead of dqptr_sem.

Signed-off-by: Lai Siyao <lai.siyao@intel.com>
Signed-off-by: Niu Yawei <yawei.niu@intel.com>
---
 fs/quota/quota.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 2b363e2..e4851cb 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -79,13 +79,13 @@ static int quota_getfmt(struct super_block *sb, int type, void __user *addr)
 {
 	__u32 fmt;
 
-	down_read(&sb_dqopt(sb)->dqptr_sem);
+	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
 	if (!sb_has_quota_active(sb, type)) {
-		up_read(&sb_dqopt(sb)->dqptr_sem);
+		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 		return -ESRCH;
 	}
 	fmt = sb_dqopt(sb)->info[type].dqi_format->qf_fmt_id;
-	up_read(&sb_dqopt(sb)->dqptr_sem);
+	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	if (copy_to_user(addr, &fmt, sizeof(fmt)))
 		return -EFAULT;
 	return 0;
-- 
1.7.1


