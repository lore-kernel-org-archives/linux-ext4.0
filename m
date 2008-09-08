From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] make all feature-related printks KERN_INFO and print barrier
 status as well
Date: Mon, 08 Sep 2008 12:08:30 -0500
Message-ID: <48C55C0E.2050809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36395 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbYIHRJT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Sep 2008 13:09:19 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m88H8h3g028218
	for <linux-ext4@vger.kernel.org>; Mon, 8 Sep 2008 13:09:04 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88H8WUq024105
	for <linux-ext4@vger.kernel.org>; Mon, 8 Sep 2008 13:08:32 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m88H8VLv004194
	for <linux-ext4@vger.kernel.org>; Mon, 8 Sep 2008 13:08:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A very trivial little tidy-up patch.

This slightly duplicates a little of patches/ext4_fix_printk_checkpatch_issues
but just in one hunk, easily fixed up.

Various feature printk's come out at different levels, so for example
at my default logging level I see mballoc & extents messages, but
not delalloc, even though they are all on.

Also, since default barrier behavior has changed, I thought perhaps always
printing the barrier state might be a good idea.

Seems ok?

Thanks,
-Eric

------------------------

Make extents, mballoc, and delalloc feature printks all at log level KERN_INFO.

Also print barrier status, whether on or off, since the defaults recently changed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/extents.c
===================================================================
--- linux-2.6.orig/fs/ext4/extents.c	2008-09-07 19:43:35.979702421 -0500
+++ linux-2.6/fs/ext4/extents.c	2008-09-08 12:02:58.580702852 -0500
@@ -2142,7 +2142,7 @@ void ext4_ext_init(struct super_block *s
 	 */
 
 	if (test_opt(sb, EXTENTS)) {
-		printk("EXT4-fs: file extents enabled");
+		printk(KERN_INFO "EXT4-fs: file extents enabled");
 #ifdef AGGRESSIVE_TEST
 		printk(", aggressive tests");
 #endif
Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c	2008-09-07 19:43:36.813639634 -0500
+++ linux-2.6/fs/ext4/mballoc.c	2008-09-08 12:03:00.807640535 -0500
@@ -2560,7 +2560,7 @@ int ext4_mb_init(struct super_block *sb,
 	ext4_mb_init_per_dev_proc(sb);
 	ext4_mb_history_init(sb);
 
-	printk("EXT4-fs: mballoc enabled\n");
+	printk(KERN_INFO "EXT4-fs: mballoc enabled\n");
 	return 0;
 }
 
Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c	2008-09-07 19:43:36.603640074 -0500
+++ linux-2.6/fs/ext4/super.c	2008-09-08 12:03:00.266640232 -0500
@@ -2715,6 +2715,11 @@ static int ext4_load_journal(struct supe
 			return -EINVAL;
 	}
 
+	if (journal->j_flags & JBD2_BARRIER)
+		printk(KERN_INFO "EXT4-fs: barriers enabled\n");
+	else
+		printk(KERN_INFO "EXT4-fs: barriers disabled\n");
+
 	if (!really_read_only && test_opt(sb, UPDATE_JOURNAL)) {
 		err = jbd2_journal_update_format(journal);
 		if (err)  {

