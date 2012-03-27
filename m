From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Tue, 27 Mar 2012 22:14:01 +0200
Message-ID: <20120327201401.GF5020@quack.suse.cz>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <20120322095342.GC14485@quack.suse.cz>
 <1332410747.18717.12.camel@sauron.fi.intel.com>
 <20120322103309.GA14484@quack.suse.cz>
 <1332854998.31549.40.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1332854998.31549.40.camel@sauron.fi.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 27-03-12 16:29:58, Artem Bityutskiy wrote:
> On Thu, 2012-03-22 at 11:33 +0100, Jan Kara wrote:
> >   Then we have ext4_mark_super_dirty() call from 4 places - I forgot about
> > these originally... I kind of miss their purpose. Originally they were used
> > so that we write total number of free blocks and inodes in the superblock
> > but when we do not maintain them in the journal mode I don't see a reason
> > to periodically sync them in no-journal mode. Ted, what is the purpose of
> > these calls?
> 
> I do not understand what's the fundamental difference between journal
> and non-journal mode. Why when we do have the journal we do not mark the
> super-block as dirty in many places (e.g., in 'ext4_file_open()' - if we
> do have the journal, when do we make sure we save the mount point path
> change?).
  We write it at least during ext4_put_super().

> May be it has something to do with behaving like the ext2 driver when
> mounting ext2-formatted media with the the ext4 driver?
  I'm not really sure about this...

> Jan, since Ted did not answer, may be you can figure out the reasons
> from this commit message, which actually introduced the
> 'ext4_mark_super_dirty()' function?
  Anyway, attached are two patches which you can include in your series
and which should make your cleanups simpler.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--LZvS9be/3tNcYl/X
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Remove-useless-marking-of-superblock-dirty.patch"

>From b66c62b32485ad708d91e03ebc66f618d4c9add4 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 27 Mar 2012 21:43:09 +0200
Subject: [PATCH 1/2] ext4: Remove useless marking of superblock dirty

Commit a0375156 properly notes that superblock doesn't need to be marked
as dirty when only number of free inodes / blocks / number of directories
changes since that is recomputed on each mount anyway. However that comment
leaves some unnecessary markings as dirty in place. Remove these.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ialloc.c  |    2 --
 fs/ext4/mballoc.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 25d8c97..f0a17c3 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -284,7 +284,6 @@ out:
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!fatal)
 			fatal = err;
-		ext4_mark_super_dirty(sb);
 	} else
 		ext4_error(sb, "bit already cleared for inode %lu", ino);
 
@@ -846,7 +845,6 @@ got:
 	percpu_counter_dec(&sbi->s_freeinodes_counter);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
-	ext4_mark_super_dirty(sb);
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cb990b2..7daea1f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2875,7 +2875,6 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
-	ext4_mark_super_dirty(sb);
 	brelse(bitmap_bh);
 	return err;
 }
@@ -4749,7 +4748,6 @@ do_more:
 		put_bh(bitmap_bh);
 		goto do_more;
 	}
-	ext4_mark_super_dirty(sb);
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
-- 
1.7.1


--LZvS9be/3tNcYl/X
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-ext4-Convert-last-user-of-ext4_mark_super_dirty-to-e.patch"

>From 7d49e3df08597241677feaadbb8463758d6e282b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 27 Mar 2012 22:05:18 +0200
Subject: [PATCH 2/2] ext4: Convert last user of ext4_mark_super_dirty() to ext4_handle_dirty_super()

The last user of ext4_mark_super_dirty() in ext4_file_open() is so rare it
can well be modifying the superblock properly by journalling the change.
Change it and get rid of ext4_mark_super_dirty() as it's not needed anymore.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h |    6 ------
 fs/ext4/file.c |   15 ++++++++++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 513004f..4764d1e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2204,12 +2204,6 @@ static inline void ext4_unlock_group(struct super_block *sb,
 	spin_unlock(ext4_group_lock_ptr(sb, group));
 }
 
-static inline void ext4_mark_super_dirty(struct super_block *sb)
-{
-	if (EXT4_SB(sb)->s_journal == NULL)
-		sb->s_dirt =1;
-}
-
 /*
  * Block validity checking
  */
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cb70f18..d7a858c 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -181,9 +181,22 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		path.dentry = mnt->mnt_root;
 		cp = d_path(&path, buf, sizeof(buf));
 		if (!IS_ERR(cp)) {
+			handle_t *handle;
+			int err;
+
+			handle = ext4_journal_start_sb(sb, 1);
+			if (IS_ERR(handle))
+				return PTR_ERR(handle);
+			err = ext4_journal_get_write_access(handle,
+							    EXT4_SB(sb)->s_sbh);
+			if (err) {
+				ext4_journal_stop(sb);
+				return err;
+			}
 			strlcpy(sbi->s_es->s_last_mounted, cp,
 				sizeof(sbi->s_es->s_last_mounted));
-			ext4_mark_super_dirty(sb);
+			ext4_handle_dirty_super(handle, sb);
+			ext4_journal_stop(handle);
 		}
 	}
 	/*
-- 
1.7.1


--LZvS9be/3tNcYl/X--
