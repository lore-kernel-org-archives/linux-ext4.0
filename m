From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/4] ext3: ext3_mark_recovery_complete() doesn't need to use
 lock_super
Date: Mon, 14 Dec 2009 12:59:59 -0600
Message-ID: <4B268B2F.9050507@redhat.com>
References: <4B268A3C.8060708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbZLNS7z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 13:59:55 -0500
In-Reply-To: <4B268A3C.8060708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Theodore Ts'o <tytso@mit.edu>

The function ext3_mark_recovery_complete() is called from two call
paths: either (a) while mounting the filesystem, in which case there's
no danger of any other CPU calling write_super() until the mount is
completed, and (b) while remounting the filesystem read-write, in
which case the fs core has already locked the superblock.  This also
allows us to take out a very vile unlock_super()/lock_super() pair in
ext3_remount().

Crossport of a63c9eb2ce6f5028da90f282798232c4f398ceb8

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext3/super.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index bed624c..602b308 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2352,13 +2352,11 @@ static void ext3_mark_recovery_complete(struct super_block * sb,
 	if (journal_flush(journal) < 0)
 		goto out;
 
-	lock_super(sb);
 	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		ext3_commit_super(sb, es, 1);
 	}
-	unlock_super(sb);
 
 out:
 	journal_unlock_updates(journal);
@@ -2550,13 +2548,7 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			    (sbi->s_mount_state & EXT3_VALID_FS))
 				es->s_state = cpu_to_le16(sbi->s_mount_state);
 
-			/*
-			 * We have to unlock super so that we can wait for
-			 * transactions.
-			 */
-			unlock_super(sb);
 			ext3_mark_recovery_complete(sb, es);
-			lock_super(sb);
 		} else {
 			__le32 ret;
 			if ((ret = EXT3_HAS_RO_COMPAT_FEATURE(sb,
-- 1.6.0.6

