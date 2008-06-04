From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/5] ext4: Set journal pointer to NULL when journal is
	released
Date: Wed, 4 Jun 2008 17:56:10 +0200
Message-ID: <20080604155610.GH16572@duck.suse.cz>
References: <20080604155431.GG16572@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46473 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752427AbYFDP4L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2008 11:56:11 -0400
Received: from duck.suse.cz (duck.suse.cz [10.20.1.74])
	by mail.suse.cz (Postfix) with ESMTP id 629166280DF
	for <linux-ext4@vger.kernel.org>; Wed,  4 Jun 2008 17:56:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20080604155431.GG16572@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>
Date: Wed, 21 May 2008 17:01:22 +0200
Subject: [PATCH] ext4: Set journal pointer to NULL when journal is released

Set sbi->s_journal to NULL after we call journal_destroy(). This
will be later needed because after journal_destroy() is called,
ext4_clear_inode() can still be called for some inodes (e.g. root
inode) and we'll need to detect there that journal doesn't exists
anymore.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Index: linux-2.6-linus/fs/ext4/super.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/super.c
+++ linux-2.6-linus/fs/ext4/super.c
@@ -506,6 +506,7 @@ static void ext4_put_super (struct super
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
 	jbd2_journal_destroy(sbi->s_journal);
+	sbi->s_journal = NULL;
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
@@ -2398,6 +2399,7 @@ cantfind_ext4:
 
 failed_mount4:
 	jbd2_journal_destroy(sbi->s_journal);
+	sbi->s_journal = NULL;
 failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
