From: Niu Yawei <yawei.niu@gmail.com>
Subject: [PATCH 2/5] quota: avoid unnecessary dqget()/dqput() calls
Date: Wed, 04 Jun 2014 12:20:30 +0800
Message-ID: <538E9E8E.4060903@gmail.com>
References: <537DD5BA.1050105@gmail.com> <538464AD.6050407@gmail.com> <20140527101219.GA28035@infradead.org> <538541FE.3070203@gmail.com> <20140602083436.GC3224@quack.suse.cz> <538D9AB0.9090607@gmail.com> <20140603154301.GE30706@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, lai.siyao@intel.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140603154301.GE30706@quack.suse.cz>
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
index 9cd5f63..a00201d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1400,7 +1400,7 @@ static int dquot_active(const struct inode *inode)
  */
 static void __dquot_initialize(struct inode *inode, int type)
 {
-	int cnt;
+	int cnt, init_needed = 0;
 	struct dquot *got[MAXQUOTAS];
 	struct super_block *sb = inode->i_sb;
 	qsize_t rsv;
@@ -1416,6 +1416,13 @@ static void __dquot_initialize(struct inode *inode, int type)
 		got[cnt] = NULL;
 		if (type != -1 && cnt != type)
 			continue;
+		/* The i_dquot should have been initialized in most cases,
+		 * we check it without locking here to avoid unnecessary
+		 * dqget()/dqput() calls. */
+		if (inode->i_dquot[cnt])
+			continue;
+		init_needed = 1;
+
 		switch (cnt) {
 		case USRQUOTA:
 			qid = make_kqid_uid(inode->i_uid);
@@ -1427,6 +1434,10 @@ static void __dquot_initialize(struct inode *inode, int type)
 		got[cnt] = dqget(sb, qid);
 	}
 
+	/* All required i_dquot has been initialized */
+	if (!init_needed)
+		return;
+
 	down_write(&sb_dqopt(sb)->dqptr_sem);
 	if (IS_NOQUOTA(inode))
 		goto out_err;
-- 
1.7.1


