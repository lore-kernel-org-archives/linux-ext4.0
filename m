From: Niu Yawei <yawei.niu@gmail.com>
Subject: [PATCH 2/3] quota: avoid unnecessary dqget()/dqput() calls
Date: Tue, 27 May 2014 18:13:48 +0800
Message-ID: <5384655C.9040203@gmail.com>
References: <537DD5BA.1050105@gmail.com> <20140522132556.GE7999@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, lai.siyao@intel.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140522132556.GE7999@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Avoid unnecessary dqget()/dqput() calls in __dquot_initialize(),
that will introduce global lock contention otherwise.

Signed-off-by: Lai Siyao <lai.siyao@intel.com>
Signed-off-by: Niu Yawei <yawei.niu@intel.com>
---
 fs/quota/dquot.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 9cd5f63..dc6f711 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1400,7 +1400,7 @@ static int dquot_active(const struct inode *inode)
  */
 static void __dquot_initialize(struct inode *inode, int type)
 {
-	int cnt;
+	int cnt, dq_get = 0;
 	struct dquot *got[MAXQUOTAS];
 	struct super_block *sb = inode->i_sb;
 	qsize_t rsv;
@@ -1416,6 +1416,13 @@ static void __dquot_initialize(struct inode *inode, int type)
 		got[cnt] = NULL;
 		if (type != -1 && cnt != type)
 			continue;
+		/* the i_dquot should have been initialized in most case,
+		 * we check it without locking here to avoid unnecessary
+		 * dqget()/dqput() calls. */
+		if (inode->i_dquot[cnt])
+			continue;
+		dq_get = 1;
+
 		switch (cnt) {
 		case USRQUOTA:
 			qid = make_kqid_uid(inode->i_uid);
@@ -1427,6 +1434,10 @@ static void __dquot_initialize(struct inode *inode, int type)
 		got[cnt] = dqget(sb, qid);
 	}
 
+	/* all required i_dquot has been initialized */
+	if (!dq_get)
+		return;
+
 	down_write(&sb_dqopt(sb)->dqptr_sem);
 	if (IS_NOQUOTA(inode))
 		goto out_err;
-- 
1.7.1


