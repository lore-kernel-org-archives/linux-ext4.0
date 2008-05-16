From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/4] ext3: enable barriers by default
Date: Fri, 16 May 2008 09:37:19 -0500
Message-ID: <1210948642-12171-2-git-send-email-sandeen__16232.0313429975$1210950069$gmane$org@redhat.com>
References: <1210948642-12171-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760683AbYEPO4X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2008 10:56:23 -0400
In-Reply-To: <1210948642-12171-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I can't think of any valid reason for ext3 to not use barriers when
they are available;  I believe this is necessary for filesystem
integrity in the face of a volatile write cache on storage.

An administrator who trusts that the cache is sufficiently battery-
backed (and power supplies are sufficiently redundant, etc...)
can always turn it back off again.

SuSE has carried such a patch for quite some time now.

Also document the mount option while we're at it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 Documentation/filesystems/ext3.txt |   12 ++++++++++--
 fs/ext3/super.c                    |   11 +++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index b45f3c1..daab1f5 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -52,8 +52,16 @@ commit=nrsec	(*)	Ext3 can be told to sync all its data and metadata
 			Setting it to very large values will improve
 			performance.
 
-barrier=1		This enables/disables barriers.  barrier=0 disables
-			it, barrier=1 enables it.
+barrier=<0|1(*)>	This enables/disables the use of write barriers in
+			the jbd code.  barrier=0 disables, barrier=1 enables.
+			This also requires an IO stack which can support
+			barriers, and if jbd gets an error on a barrier
+			write, it will disable again with a warning.
+			Write barriers enforce proper on-disk ordering
+			of journal commits, making volatile disk write caches
+			safe to use, at some performance penalty.  If
+			your disks are battery-backed in one way or another,
+			disabling barriers may safely improve performance.
 
 orlov		(*)	This enables the new Orlov block allocator. It is
 			enabled by default.
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fe3119a..9c30dc7 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -555,6 +555,7 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct super_block *sb = vfs->mnt_sb;
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 	struct ext3_super_block *es = sbi->s_es;
+	journal_t *journal = sbi->s_journal;
 	unsigned long def_mount_opts;
 
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
@@ -613,8 +614,13 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_printf(seq, ",commit=%u",
 			   (unsigned) (sbi->s_commit_interval / HZ));
 	}
-	if (test_opt(sb, BARRIER))
-		seq_puts(seq, ",barrier=1");
+	/*
+ 	 * jbd inherits the barrier flag from ext3, and may actually
+ 	 * turn off barriers if a write fails, so it's the real test.
+ 	 */
+	if (!test_opt(sb, BARRIER) ||
+	    (journal && !(journal->j_flags & JFS_BARRIER)))
+		seq_puts(seq, ",barrier=0");
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 
@@ -1589,6 +1595,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
 
 	set_opt(sbi->s_mount_opt, RESERVATION);
+	set_opt(sbi->s_mount_opt, BARRIER);
 
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
 			    NULL, 0))
-- 
1.5.3.6

