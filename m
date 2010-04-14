From: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 5/5] ext2: Add ext2_sb_info s_lock spinlock
Date: Wed, 14 Apr 2010 10:19:52 +0200
Message-ID: <20100414081952.GR10776@bolzano.suse.de>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de> <1271104905-8804-6-git-send-email-jblunck@suse.de> <20100413190948.GC3250@quack.wifi.zluty.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Andi Kleen <andi@firstfloor.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab0DNITy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 04:19:54 -0400
Content-Disposition: inline
In-Reply-To: <20100413190948.GC3250@quack.wifi.zluty.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 13, Jan Kara wrote:

> On Mon 12-04-10 22:41:45, Jan Blunck wrote:
> > Add a spinlock that protects against concurrent modifications of
> > s_mount_state, s_blocks_last, s_overhead_last and the content of the
> > superblock's buffer pointed to by sbi->s_es. This is a preparation patch
> > for removing the BKL from ext2 in the next patch.
> > 
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> > ---
> >  fs/ext2/inode.c            |    2 ++
> >  fs/ext2/super.c            |   31 +++++++++++++++++++++++++++++--
> >  include/linux/ext2_fs_sb.h |    6 ++++++
> >  3 files changed, 37 insertions(+), 2 deletions(-)
> > 
> >diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> >index fc13cc1..5d15442 100644
> >--- a/fs/ext2/inode.c
> >+++ b/fs/ext2/inode.c
> >@@ -1407,9 +1407,11 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
> >                               * created, add a flag to the superblock.
> >                               */
> >                               lock_kernel();
> >+                              spin_lock(&EXT2_SB(sb)->s_lock);
> >                               ext2_update_dynamic_rev(sb);
> >                               EXT2_SET_RO_COMPAT_FEATURE(sb,
> >                                       EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
> >+                              spin_unlock(&EXT2_SB(sb)->s_lock);
> >                               unlock_kernel();
> >                               ext2_write_super(sb);
> >                       }
>   Looking at this - probably we should protect by this lock also setting of
> a feature in ext2_xattr_update_super_block(). It's an unrelated bugfix but
> when we are already doing the bugfixing & cleanups in this area...
> 
> > diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> > index b01c491..34d7a62 100644
> > --- a/fs/ext2/super.c
> > +++ b/fs/ext2/super.c
> > @@ -209,6 +216,7 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
> >  	struct ext2_super_block *es = sbi->s_es;
> >  	unsigned long def_mount_opts;
> >  
> > +	spin_lock(&sbi->s_lock);
> >  	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
> >  
> >  	if (sbi->s_sb_block != 1)
> > @@ -281,6 +289,7 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
> >  	if (!test_opt(sb, RESERVATION))
> >  		seq_puts(seq, ",noreservation");
> >  
> > +	spin_unlock(&sbi->s_lock);
> >  	return 0;
> >  }
>   Why exactly do you have in the above? Probably because of consistent
> view of mount options? You should comment about that in the changelo and
> especially at the lock declaration in ext2_fs.h.
> 
> > @@ -1158,19 +1173,22 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
> >   * may have been checked while mounted and e2fsck may have
> >   * set s_state to EXT2_VALID_FS after some corrections.
> >   */
> > -
> >  static int ext2_sync_fs(struct super_block *sb, int wait)
> >  {
> > +	struct ext2_sb_info *sbi = EXT2_SB(sb);
> >  	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
> >  	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
> >  
> >  	lock_kernel();
> > +	spin_lock(&sbi->s_lock);
> >  	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
> >  		ext2_debug("setting valid to 0\n");
> >  		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
> > +		spin_unlock(&sbi->s_lock);
> >  		ext2_sync_super(sb, es);
> >  	} else {
> >  		ext2_commit_super(sb, es);
> > +		spin_unlock(&sbi->s_lock);
>   Could you please fold in ext2_commit_super? It's used only here and it's
> name looks a bit scary to be called under the spinlock...

Right. Is there actually a reason why we don't update the s_free_blocks_count
and s_free_inodes_count when we found the filesystem did not have the
EXT2_VALID_FS set? Otherwise I could use ext2_sync_super() in both and make it
honor the wait flag by just calling sync_dirty_buffer() when it is necessary.

What do you think?

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 40fc8d5..8187061 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -39,7 +39,7 @@
 #include "xip.h"
 
 static void ext2_sync_super(struct super_block *sb,
-			    struct ext2_super_block *es);
+			    struct ext2_super_block *es, int wait);
 static int ext2_remount (struct super_block * sb, int * flags, char * data);
 static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf);
 static int ext2_sync_fs(struct super_block *sb, int wait);
@@ -54,7 +54,7 @@ void ext2_error (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		sbi->s_mount_state |= EXT2_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
-		ext2_sync_super(sb, es);
+		ext2_sync_super(sb, es, 1);
 	}
 
 	va_start(args, fmt);
@@ -125,7 +125,7 @@ static void ext2_put_super (struct super_block * sb)
 		struct ext2_super_block *es = sbi->s_es;
 
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
-		ext2_sync_super(sb, es);
+		ext2_sync_super(sb, es, 1);
 	}
 	db_count = sbi->s_gdb_count;
 	for (i = 0; i < db_count; i++)
@@ -1127,23 +1127,16 @@ static void ext2_clear_super_error(struct super_block *sb)
 	}
 }
 
-static void ext2_commit_super (struct super_block * sb,
-			       struct ext2_super_block * es)
-{
-	ext2_clear_super_error(sb);
-	es->s_wtime = cpu_to_le32(get_seconds());
-	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
-	sb->s_dirt = 0;
-}
-
-static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
+static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
+			    int wait)
 {
 	ext2_clear_super_error(sb);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 	es->s_wtime = cpu_to_le32(get_seconds());
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
-	sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
+	if (wait)
+		sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
 	sb->s_dirt = 0;
 }
 
@@ -1167,11 +1160,8 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
 		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
-		ext2_sync_super(sb, es);
-	} else {
-		ext2_commit_super(sb, es);
 	}
-	sb->s_dirt = 0;
+	ext2_sync_super(sb, es, wait);
 	unlock_kernel();
 
 	return 0;
@@ -1269,7 +1259,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		if (!ext2_setup_super (sb, es, 0))
 			sb->s_flags &= ~MS_RDONLY;
 	}
-	ext2_sync_super(sb, es);
+	ext2_sync_super(sb, es, 1);
 	unlock_kernel();
 	return 0;
 restore_opts:
