From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/4] ext4: enable barriers by default
Date: Fri, 16 May 2008 14:08:56 -0500
Message-ID: <482DDBC8.50505@redhat.com>
References: <482DDA56.6000301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jamie Lokier <jamie@shareable.org>
To: ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbYEPTJe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2008 15:09:34 -0400
In-Reply-To: <482DDA56.6000301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I can't think of any valid reason for ext4 to not use barriers when
they are available;  I believe this is necessary for filesystem
integrity in the face of a volatile write cache on storage.

An administrator who trusts that the cache is sufficiently battery-
backed (and power supplies are sufficiently redundant, etc...)
can always turn it back off again.

SuSE has carried such a patch for ext3 for quite some time now.

Also document the mount option while we're at it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 Documentation/filesystems/ext4.txt |   12 ++++++++++--
 fs/ext4/super.c                    |   11 +++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 560f88d..0c5086d 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -139,8 +139,16 @@ commit=nrsec	(*)	Ext4 can be told to sync all its data and metadata
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
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 52dd067..77b036a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -671,6 +671,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	unsigned long def_mount_opts;
 	struct super_block *sb = vfs->mnt_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	journal_t *journal = sbi->s_journal;
 	struct ext4_super_block *es = sbi->s_es;
 
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
@@ -729,8 +730,13 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_printf(seq, ",commit=%u",
 			   (unsigned) (sbi->s_commit_interval / HZ));
 	}
-	if (test_opt(sb, BARRIER))
-		seq_puts(seq, ",barrier=1");
+	/*
+	 * jbd2 inherits the barrier flag from ext4, and may actually
+	 * turn off barriers if a write fails, so it's the real test.
+	 */
+	if (!test_opt(sb, BARRIER) ||
+	    (journal && !(journal->j_flags & JBD2_BARRIER)))
+		seq_puts(seq, ",barrier=0");
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 	if (!test_opt(sb, EXTENTS))
@@ -1890,6 +1896,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
 
 	set_opt(sbi->s_mount_opt, RESERVATION);
+	set_opt(sbi->s_mount_opt, BARRIER);
 
 	/*
 	 * turn on extents feature by default in ext4 filesystem
-- 1.5.3.6

