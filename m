From: Niu Yawei <yawei.niu@gmail.com>
Subject: [PATCH 1/3] quota: protect Q_GETFMT by dqonoff_mutex
Date: Tue, 27 May 2014 18:10:53 +0800
Message-ID: <538464AD.6050407@gmail.com>
References: <537DD5BA.1050105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: yawei.niu@intel.com, andreas.dilger@intel.com, jack@suse.cz,
	lai.siyao@intel.com
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <537DD5BA.1050105@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Remove dqptr_sem to make quota code scalable (but kept in struct
quota_info to keep kernel ABI unchanged): Protect the Q_GETFMT by
dqonoff_mutex instead of dqptr_sem.

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


