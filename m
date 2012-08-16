From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: [PATCH 4/8] ext4: remove lock/unlock super
Date: Thu, 16 Aug 2012 12:02:21 +0200
Message-ID: <502CC52D.20003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, tytso@mit.edu,
	hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	dushistov@mail.ru, osd-dev@open-osd.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41094 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab2HPKIu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 06:08:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Marco Stornelli <marco.stornelli@gmail.com>

Replaced lock and unlock super with a new fs mutex s_lock.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -Nurp linux-3.6-rc1-orig/fs/ext4/ext4.h linux-3.6-rc1/fs/ext4/ext4.h
--- linux-3.6-rc1-orig/fs/ext4/ext4.h	2012-08-16 09:37:31.000000000 +0200
+++ linux-3.6-rc1/fs/ext4/ext4.h	2012-08-16 09:50:40.000000000 +0200
@@ -1293,6 +1293,8 @@ struct ext4_sb_info {
 	/* Reference to checksum algorithm driver via cryptoapi */
 	struct crypto_shash *s_chksum_driver;
 
+	struct mutex s_lock;
+
 	/* Precomputed FS UUID checksum for seeding other checksums */
 	__u32 s_csum_seed;
 };
diff -Nurp linux-3.6-rc1-orig/fs/ext4/super.c linux-3.6-rc1/fs/ext4/super.c
--- linux-3.6-rc1-orig/fs/ext4/super.c	2012-08-16 09:37:32.000000000 +0200
+++ linux-3.6-rc1/fs/ext4/super.c	2012-08-16 09:54:30.000000000 +0200
@@ -861,7 +861,7 @@ static void ext4_put_super(struct super_
 	flush_workqueue(sbi->dio_unwritten_wq);
 	destroy_workqueue(sbi->dio_unwritten_wq);
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	if (sbi->s_journal) {
 		err = jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
@@ -928,7 +928,7 @@ static void ext4_put_super(struct super_
 	 * Now that we are completely done shutting down the
 	 * superblock, we need to actually destroy the kobject.
 	 */
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	kobject_put(&sbi->s_kobj);
 	wait_for_completion(&sbi->s_kobj_unregister);
 	if (sbi->s_chksum_driver)
@@ -3718,6 +3718,7 @@ static int ext4_fill_super(struct super_
 	sbi->s_gdb_count = db_count;
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);
+	mutex_init(&sbi->s_lock);
 
 	init_timer(&sbi->s_err_report);
 	sbi->s_err_report.function = print_daily_error_info;
@@ -4519,11 +4520,11 @@ static int ext4_unfreeze(struct super_bl
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-	lock_super(sb);
+	mutex_lock(&EXT4_SB(sb)->s_lock);
 	/* Reset the needs_recovery flag before the fs is unlocked. */
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	ext4_commit_super(sb, 1);
-	unlock_super(sb);
+	mutex_unlock(&EXT4_SB(sb)->s_lock);
 	return 0;
 }
 
@@ -4559,7 +4560,7 @@ static int ext4_remount(struct super_blo
 	char *orig_data = kstrdup(data, GFP_KERNEL);
 
 	/* Store the original options */
-	lock_super(sb);
+	mutex_lock(&sbi->s_lock);
 	old_sb_flags = sb->s_flags;
 	old_opts.s_mount_opt = sbi->s_mount_opt;
 	old_opts.s_mount_opt2 = sbi->s_mount_opt2;
@@ -4701,7 +4702,7 @@ static int ext4_remount(struct super_blo
 	if (sbi->s_journal == NULL)
 		ext4_commit_super(sb, 1);
 
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 #ifdef CONFIG_QUOTA
 	/* Release old quota file names */
 	for (i = 0; i < MAXQUOTAS; i++)
@@ -4715,7 +4716,7 @@ static int ext4_remount(struct super_blo
 					EXT4_FEATURE_RO_COMPAT_QUOTA)) {
 			err = ext4_enable_quotas(sb);
 			if (err) {
-				lock_super(sb);
+				mutex_lock(&sbi->s_lock);
 				goto restore_opts;
 			}
 		}
@@ -4744,7 +4745,7 @@ restore_opts:
 		sbi->s_qf_names[i] = old_opts.s_qf_names[i];
 	}
 #endif
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_lock);
 	kfree(orig_data);
 	return err;
 }


