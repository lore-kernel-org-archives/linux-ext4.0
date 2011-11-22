From: Jan Kara <jack@suse.cz>
Subject: Support for ext4 hidden quota inodes in quota-tools
Date: Tue, 22 Nov 2011 21:12:06 +0100
Message-ID: <20111122201206.GA5029@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, tytso@mit.edu, dmonakhov@openvz.org,
	linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab1KVUMI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Nov 2011 15:12:08 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  this is just a heads up that I've modified quota tools to handle
quota files in hidden inodes for ext4. Current source code can be pulled
from git repository at sf.net: linuxquota.git.sourceforge.net

For quota tools to recognize whether hidden inodes are used for quota or
not a patch below is needed. I plan to merge it in the next merge window.
When Aditya sends new version of the patch, I'll test whether everything
works together as expected...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---
>From e99ea5683c1c5604369ef8b01e2bcaaee532691e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 16 Nov 2011 15:03:59 +0100
Subject: [PATCH] quota: Pass information that quota is stored in system file to userspace

Quota tools need to know whether quota is stored in a system file or in
classical aquota.{user|group} files. So pass this information as a flag
in GETINFO quotactl.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c      |    8 +++++---
 include/linux/quota.h |    6 +++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 5b572c8..3f70d70 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2126,6 +2126,8 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		mutex_unlock(&dqopt->dqio_mutex);
 		goto out_file_init;
 	}
+	if (dqopt->flags & DQUOT_QUOTA_SYS_FILE)
+		dqopt->info[type].dqi_flags |= DQF_SYS_FILE;
 	mutex_unlock(&dqopt->dqio_mutex);
 	spin_lock(&dq_state_lock);
 	dqopt->flags |= dquot_state_flag(flags, type);
@@ -2465,7 +2467,7 @@ int dquot_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
 	spin_lock(&dq_data_lock);
 	ii->dqi_bgrace = mi->dqi_bgrace;
 	ii->dqi_igrace = mi->dqi_igrace;
-	ii->dqi_flags = mi->dqi_flags & DQF_MASK;
+	ii->dqi_flags = mi->dqi_flags & DQF_GETINFO_MASK;
 	ii->dqi_valid = IIF_ALL;
 	spin_unlock(&dq_data_lock);
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
@@ -2491,8 +2493,8 @@ int dquot_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
 	if (ii->dqi_valid & IIF_IGRACE)
 		mi->dqi_igrace = ii->dqi_igrace;
 	if (ii->dqi_valid & IIF_FLAGS)
-		mi->dqi_flags = (mi->dqi_flags & ~DQF_MASK) |
-				(ii->dqi_flags & DQF_MASK);
+		mi->dqi_flags = (mi->dqi_flags & ~DQF_SETINFO_MASK) |
+				(ii->dqi_flags & DQF_SETINFO_MASK);
 	spin_unlock(&dq_data_lock);
 	mark_info_dirty(sb, type);
 	/* Force write to disk */
diff --git a/include/linux/quota.h b/include/linux/quota.h
index cb78556..c09fa04 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -230,7 +230,11 @@ struct mem_dqinfo {
 struct super_block;
 
 #define DQF_MASK 0xffff		/* Mask for format specific flags */
-#define DQF_INFO_DIRTY_B 16
+#define DQF_GETINFO_MASK 0x1ffff	/* Mask for flags passed to userspace */
+#define DQF_SETINFO_MASK 0xffff		/* Mask for flags modifiable from userspace */
+#define DQF_SYS_FILE_B		16
+#define DQF_SYS_FILE (1 << DQF_SYS_FILE_B)	/* Quota file stored as system file */
+#define DQF_INFO_DIRTY_B	31
 #define DQF_INFO_DIRTY (1 << DQF_INFO_DIRTY_B)	/* Is info dirty? */
 
 extern void mark_info_dirty(struct super_block *sb, int type);
-- 
1.7.1

