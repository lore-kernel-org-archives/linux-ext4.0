From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: barriers off by default?
Date: Thu, 15 May 2008 15:44:04 -0500
Message-ID: <482CA094.20703@redhat.com>
References: <482868A5.1000102@redhat.com> <20080515144355.GB19325@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbYEOUoN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2008 16:44:13 -0400
In-Reply-To: <20080515144355.GB19325@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:

>> As I look at my shiny new 500G disks with 32MB of cache, I find myself
>> wondering why the default for ext3 and ext4 is to have barriers disabled.
>>
>> This is a pretty dangerous default w.r.t. filesystem integrity on power
>> loss, no?
>>     
>   JFYI: SUSE kernel carries for ages a patch which changes this default.
> I'd be more than happy to drop it ;).
>
> 								Honza
>   
What do folks think of this?

the show_options change is a little funky since jbd may do a test 
write and fail... (actually I was thinking maybe at fill_super we 
should do a test barrier write and get it out of the way early...)

-Eric


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
index fe3119a..d06e0f3 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -555,6 +555,7 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct super_block *sb = vfs->mnt_sb;
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 	struct ext3_super_block *es = sbi->s_es;
+	journal_t *journal = EXT3_SB(sb)->s_journal;
 	unsigned long def_mount_opts;
 
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
@@ -613,8 +614,16 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_printf(seq, ",commit=%u",
 			   (unsigned) (sbi->s_commit_interval / HZ));
 	}
-	if (test_opt(sb, BARRIER))
-		seq_puts(seq, ",barrier=1");
+	if (!test_opt(sb, BARRIER)) {
+		seq_puts(seq, ",barrier=0");
+	} else {
+		/*
+	 	* jbd inherits the barrier flag from ext3, and jbd may actually
+	 	* turn off barriers if a write fails, so it's the real test.
+	 	*/
+		if (journal && !(journal->j_flags & JFS_BARRIER))
+			seq_puts(seq, ",barrier=1(failed)");
+	}
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 
@@ -1589,6 +1598,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
 
 	set_opt(sbi->s_mount_opt, RESERVATION);
+	set_opt(sbi->s_mount_opt, BARRIER);
 
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
 			    NULL, 0))

