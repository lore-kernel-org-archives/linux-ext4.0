From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/8] ext3: remove lock/unlock super
Date: Fri, 17 Aug 2012 19:08:20 -0400
Message-ID: <20120817230820.GB573@thunk.org>
References: <502CC4BA.3040702@gmail.com>
 <20120816163904.GA17526@quack.suse.cz>
 <20120816191909.GC31346@thunk.org>
 <502DE8E8.5080000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, dushistov@mail.ru, bharrosh@panasas.com,
	bhalevy@tonian.com, hirofumi@mail.parknet.co.jp,
	mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	osd-dev@open-osd.org, Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45371 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab2HQXIk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 19:08:40 -0400
Content-Disposition: inline
In-Reply-To: <502DE8E8.5080000@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 17, 2012 at 08:47:04AM +0200, Marco Stornelli wrote:
> Great. I'll remove the calls for ext3/ext4 when I'll submit the
> second version of the patch.

FYI, I have the following patch my ext4 tree, so I could do more
intensive testing.  I'll let folks know if anything goes horribly
wrong, but I'm pretty sure this should be safe.

       	   	     	      	   	    - Ted

>From 81f74e743344217487792e4190f9478963d1bb21 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 17 Aug 2012 19:00:34 -0400
Subject: [PATCH] ext4: drop lock_super()/unlock_super()

We don't need lock_super()/unlock_super() any more, since the places
where it is used, we are protected by the s_umount r/w semaphore.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/ext4/super.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ab798d..bae4124 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -861,7 +861,6 @@ static void ext4_put_super(struct super_block *sb)
 	flush_workqueue(sbi->dio_unwritten_wq);
 	destroy_workqueue(sbi->dio_unwritten_wq);
 
-	lock_super(sb);
 	if (sbi->s_journal) {
 		err = jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
@@ -928,7 +927,6 @@ static void ext4_put_super(struct super_block *sb)
 	 * Now that we are completely done shutting down the
 	 * superblock, we need to actually destroy the kobject.
 	 */
-	unlock_super(sb);
 	kobject_put(&sbi->s_kobj);
 	wait_for_completion(&sbi->s_kobj_unregister);
 	if (sbi->s_chksum_driver)
@@ -4535,11 +4533,9 @@ static int ext4_unfreeze(struct super_block *sb)
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-	lock_super(sb);
 	/* Reset the needs_recovery flag before the fs is unlocked. */
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	ext4_commit_super(sb, 1);
-	unlock_super(sb);
 	return 0;
 }
 
@@ -4575,7 +4571,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	char *orig_data = kstrdup(data, GFP_KERNEL);
 
 	/* Store the original options */
-	lock_super(sb);
 	old_sb_flags = sb->s_flags;
 	old_opts.s_mount_opt = sbi->s_mount_opt;
 	old_opts.s_mount_opt2 = sbi->s_mount_opt2;
@@ -4717,7 +4712,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_journal == NULL)
 		ext4_commit_super(sb, 1);
 
-	unlock_super(sb);
 #ifdef CONFIG_QUOTA
 	/* Release old quota file names */
 	for (i = 0; i < MAXQUOTAS; i++)
@@ -4730,10 +4724,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		else if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_QUOTA)) {
 			err = ext4_enable_quotas(sb);
-			if (err) {
-				lock_super(sb);
+			if (err)
 				goto restore_opts;
-			}
 		}
 	}
 #endif
@@ -4760,7 +4752,6 @@ restore_opts:
 		sbi->s_qf_names[i] = old_opts.s_qf_names[i];
 	}
 #endif
-	unlock_super(sb);
 	kfree(orig_data);
 	return err;
 }
-- 
1.7.12.rc0.22.gcdd159b

