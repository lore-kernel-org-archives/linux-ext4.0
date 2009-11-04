From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] handle journal checksum errors via ext4_error()
Date: Wed, 04 Nov 2009 11:37:20 -0600
Message-ID: <4AF1BBD0.3050108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424AbZKDRhR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 12:37:17 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA4HbMRL024583
	for <linux-ext4@vger.kernel.org>; Wed, 4 Nov 2009 12:37:22 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nA4HbLLO017385
	for <linux-ext4@vger.kernel.org>; Wed, 4 Nov 2009 12:37:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As the code stands today, journal checksum errors on the root fs,
resulting in only a partial journal replay, result in no kernel
messages and no error condition, because it is all handled under
a "!(sb->s_flags & MS_RDONLY)" test - and the root fs starts out
life in RO mode.

It seems to me that just calling ext4_error() here is almost the
right thing to do; it will unconditionally mark the fs with errors,
and act according to the selected mount -o errors= behavior...

However, for the root fs, ext4_error will be short-circuited because
the root is mounted readonly; and in fact these errors came into
being while we were writing to a read-only fs during journal recovery.
So we won't do a journal_abort or anything like that, and other than
a printk and an error flag, not much action is taken for a
partially-recovered fs.  Does this seem like enough?

Should we just let the root fs carry on if it's been partially-recovered,
and therefore pretty well known to be corrupt?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 312211e..08370ae 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2719,25 +2719,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
 		if (ext4_load_journal(sb, es, journal_devnum))
 			goto failed_mount3;
-		if (!(sb->s_flags & MS_RDONLY) &&
-		    EXT4_SB(sb)->s_journal->j_failed_commit) {
-			ext4_msg(sb, KERN_CRIT, "error: "
-			       "ext4_fill_super: Journal transaction "
-			       "%u is corrupt",
-			       EXT4_SB(sb)->s_journal->j_failed_commit);
-			if (test_opt(sb, ERRORS_RO)) {
-				ext4_msg(sb, KERN_CRIT,
-				       "Mounting filesystem read-only");
-				sb->s_flags |= MS_RDONLY;
-				EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
-				es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
-			}
-			if (test_opt(sb, ERRORS_PANIC)) {
-				EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
-				es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
-				ext4_commit_super(sb, 1);
-				goto failed_mount4;
-			}
+
+		if (EXT4_SB(sb)->s_journal->j_failed_commit) {
+			ext4_error(sb, __func__,
+				   "Journal transaction %u is corrupt, "
+				   "filesystem only partially recovered",
+				    EXT4_SB(sb)->s_journal->j_failed_commit);
 		}
 	} else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&
 	      EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {


