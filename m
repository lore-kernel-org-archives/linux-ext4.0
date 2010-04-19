From: Jan Kara <jack@suse.cz>
Subject: Re: quota reservation fixes for -stable?
Date: Tue, 20 Apr 2010 00:52:10 +0200
Message-ID: <20100419225209.GK5439@quack.suse.cz>
References: <4BB36BEC.2000207@redhat.com>
 <20100401082334.GD3322@quack.suse.cz>
 <4BC8CA8F.1030708@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0DSWwH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 18:52:07 -0400
Content-Disposition: inline
In-Reply-To: <4BC8CA8F.1030708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 16-04-10 15:37:35, Eric Sandeen wrote:
> On 04/01/2010 03:23 AM, Jan Kara wrote:
> 
> >   Ah, I'm testing quotas on non-root fs so I was wondering how come people
> > hit the warning so often. Now I understand :) For root filesystem on ext4
> > we don't have a chance to not see this warning. That being said the warning
> > is pretty useless for ordinary users so I guess we should just hide it
> > behind #ifdef __DQUOT_PARANOIA and use it for debugging purposes only.
> >   If noone objects soon, I'll do the change.
> > 
> > 								Honza
> 
> Hm, I see this in your tree now, but isn't __DQUOT_PARANOIA defined by
> default anyway?
  Ah, good point. Thanks for spotting this. I guess the attached cleanup is
long overdue... Will push it too Linus this week and then to stable if
noone objects.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--tKW2IUtsqtDRztdT
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-quota-Convert-__DQUOT_PARANOIA-symbol-to-standard-co.patch"

>From 320da49e9f6a5e52e944ac238a0ed75e204cce6a Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 19 Apr 2010 16:47:20 +0200
Subject: [PATCH] quota: Convert __DQUOT_PARANOIA symbol to standard config option

Make __DQUOT_PARANOIA define from the old days a standard config option
and turn it off by default.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/Kconfig |    8 ++++++++
 fs/quota/dquot.c |   16 +++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/quota/Kconfig b/fs/quota/Kconfig
index dad7fb2..3e21b1e 100644
--- a/fs/quota/Kconfig
+++ b/fs/quota/Kconfig
@@ -33,6 +33,14 @@ config PRINT_QUOTA_WARNING
 	  Note that this behavior is currently deprecated and may go away in
 	  future. Please use notification via netlink socket instead.
 
+config QUOTA_DEBUG
+	bool "Additional quota sanity checks"
+	depends on QUOTA
+	default n
+	help
+	  If you say Y here, quota subsystem will perform some additional
+	  sanity checks of quota internal structures. If unsure, say N.
+
 # Generic support for tree structured quota files. Selected when needed.
 config QUOTA_TREE
 	 tristate
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 60e0e08..05c590e 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -80,8 +80,6 @@
 
 #include <asm/uaccess.h>
 
-#define __DQUOT_PARANOIA
-
 /*
  * There are three quota SMP locks. dq_list_lock protects all lists with quotas
  * and quota formats, dqstats structure containing statistics about the lists
@@ -704,7 +702,7 @@ void dqput(struct dquot *dquot)
 
 	if (!dquot)
 		return;
-#ifdef __DQUOT_PARANOIA
+#ifdef CONFIG_QUOTA_DEBUG
 	if (!atomic_read(&dquot->dq_count)) {
 		printk("VFS: dqput: trying to free free dquot\n");
 		printk("VFS: device %s, dquot of %s %d\n",
@@ -757,7 +755,7 @@ we_slept:
 		goto we_slept;
 	}
 	atomic_dec(&dquot->dq_count);
-#ifdef __DQUOT_PARANOIA
+#ifdef CONFIG_QUOTA_DEBUG
 	/* sanity check */
 	BUG_ON(!list_empty(&dquot->dq_free));
 #endif
@@ -854,7 +852,7 @@ we_slept:
 		dquot = NULL;
 		goto out;
 	}
-#ifdef __DQUOT_PARANOIA
+#ifdef CONFIG_QUOTA_DEBUG
 	BUG_ON(!dquot->dq_sb);	/* Has somebody invalidated entry under us? */
 #endif
 out:
@@ -883,7 +881,7 @@ static int dqinit_needed(struct inode *inode, int type)
 static void add_dquot_ref(struct super_block *sb, int type)
 {
 	struct inode *inode, *old_inode = NULL;
-#ifdef __DQUOT_PARANOIA
+#ifdef CONFIG_QUOTA_DEBUG
 	int reserved = 0;
 #endif
 
@@ -891,7 +889,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 			continue;
-#ifdef __DQUOT_PARANOIA
+#ifdef CONFIG_QUOTA_DEBUG
 		if (unlikely(inode_get_rsv_space(inode) > 0))
 			reserved = 1;
 #endif
@@ -916,7 +914,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 
-#ifdef __DQUOT_PARANOIA
+#ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
 		printk(KERN_WARNING "VFS (%s): Writes happened before quota"
 			" was turned on thus quota information is probably "
@@ -949,7 +947,7 @@ static int remove_inode_dquot_ref(struct inode *inode, int type,
 	inode->i_dquot[type] = NULL;
 	if (dquot) {
 		if (dqput_blocks(dquot)) {
-#ifdef __DQUOT_PARANOIA
+#ifdef CONFIG_QUOTA_DEBUG
 			if (atomic_read(&dquot->dq_count) != 1)
 				printk(KERN_WARNING "VFS: Adding dquot with dq_count %d to dispose list.\n", atomic_read(&dquot->dq_count));
 #endif
-- 
1.6.4.2


--tKW2IUtsqtDRztdT--
