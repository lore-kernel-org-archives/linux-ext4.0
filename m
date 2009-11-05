From: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 05/27] BKL: Remove BKL from ext2 filesystem
Date: Thu, 5 Nov 2009 14:06:35 +0100
Message-ID: <20091105130635.GE21750@bolzano.suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-6-git-send-email-jblunck@suse.de> <20091105124111.GC12770@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbZKENGc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2009 08:06:32 -0500
Content-Disposition: inline
In-Reply-To: <20091105124111.GC12770@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 05, Jan Kara wrote:

> On Mon 02-11-09 11:04:45, Jan Blunck wrote:
> > The BKL is still used in ext2_put_super(), ext2_fill_super(), ext2_sync_fs()
> > ext2_remount() and ext2_write_inode(). From these calls ext2_put_super(),
> > ext2_fill_super() and ext2_remount() are protected against each other by
> > the struct super_block s_umount rw semaphore. The call in ext2_write_inode()
> > could only protect the modification of the ext2_sb_info through
> > ext2_update_dynamic_rev() against concurrent ext2_sync_fs() or ext2_remount().
> > ext2_fill_super() and ext2_put_super() can be left out because you need a
> > valid filesystem reference in all three cases, which you do not have when
> > you are one of these functions.
>   This is not quite true. Actually, ext2_sync_fs() is called also with
> s_umount held (for reading) so it cannot race with any of the mounting /
> umounting functions. But it should probably be guarded against running two
> instances of ext2_sync_fs() in parallel.
>   Looking into the code, we probably have a race in ext2_write_inode that
> two threads can write one inode in parallel. But that's a separe issue from
> BKL removal.

Have you actually seen that the previous patch introduces s_mutex? Meanwhile
that mutex has been replaced by a spinlock due to Andy's feedback.

Anyway, thanks for the review.

Cheers,
	Jan


> 								Honza 
> 
> > diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> > index 057074e..8b51416 100644
> > --- a/fs/ext2/inode.c
> > +++ b/fs/ext2/inode.c
> > @@ -22,7 +22,6 @@
> >   *  Assorted race fixes, rewrite of ext2_get_block() by Al Viro, 2000
> >   */
> >  
> > -#include <linux/smp_lock.h>
> >  #include <linux/time.h>
> >  #include <linux/highuid.h>
> >  #include <linux/pagemap.h>
> > @@ -1400,13 +1399,11 @@ int ext2_write_inode(struct inode *inode, int do_sync)
> >  			       /* If this is the first large file
> >  				* created, add a flag to the superblock.
> >  				*/
> > -				lock_kernel();
> >  				mutex_lock(&EXT2_SB(sb)->s_mutex);
> >  				ext2_update_dynamic_rev(sb);
> >  				EXT2_SET_RO_COMPAT_FEATURE(sb,
> >  					EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
> >  				mutex_unlock(&EXT2_SB(sb)->s_mutex);
> > -				unlock_kernel();
> >  				ext2_write_super(sb);
> >  			}
> >  		}
> > diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> > index d610eb9..7e819ac 100644
> > --- a/fs/ext2/super.c
> > +++ b/fs/ext2/super.c
> > @@ -26,7 +26,6 @@
> >  #include <linux/random.h>
> >  #include <linux/buffer_head.h>
> >  #include <linux/exportfs.h>
> > -#include <linux/smp_lock.h>
> >  #include <linux/vfs.h>
> >  #include <linux/seq_file.h>
> >  #include <linux/mount.h>
> > @@ -118,8 +117,6 @@ static void ext2_put_super (struct super_block * sb)
> >  	int i;
> >  	struct ext2_sb_info *sbi = EXT2_SB(sb);
> >  
> > -	lock_kernel();
> > -
> >  	if (sb->s_dirt && !(sb->s_flags & MS_RDONLY))
> >  		ext2_sync_fs(sb, 1);
> >  
> > @@ -143,8 +140,6 @@ static void ext2_put_super (struct super_block * sb)
> >  	sb->s_fs_info = NULL;
> >  	kfree(sbi->s_blockgroup_lock);
> >  	kfree(sbi);
> > -
> > -	unlock_kernel();
> >  }
> >  
> >  static struct kmem_cache * ext2_inode_cachep;
> > @@ -750,8 +745,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
> >  	__le32 features;
> >  	int err;
> >  
> > -	lock_kernel();
> > -
> >  	err = -ENOMEM;
> >  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
> >  	if (!sbi)
> > @@ -1077,7 +1070,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
> >  		ext2_warning(sb, __func__,
> >  			"mounting ext3 filesystem as ext2");
> >  	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
> > -	unlock_kernel();
> >  	return 0;
> >  
> >  cantfind_ext2:
> > @@ -1102,7 +1094,6 @@ failed_sbi:
> >  	kfree(sbi->s_blockgroup_lock);
> >  	kfree(sbi);
> >  failed_unlock:
> > -	unlock_kernel();
> >  	return ret;
> >  }
> >  
> > @@ -1140,7 +1131,6 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
> >  {
> >  	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
> >  
> > -	lock_kernel();
> >  	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
> >  		ext2_debug("setting valid to 0\n");
> >  		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
> > @@ -1154,7 +1144,6 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
> >  		ext2_commit_super(sb, es);
> >  	}
> >  	sb->s_dirt = 0;
> > -	unlock_kernel();
> >  
> >  	return 0;
> >  }
> > @@ -1181,7 +1170,6 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
> >  	unsigned long old_sb_flags;
> >  	int err;
> >  
> > -	lock_kernel();
> >  	mutex_lock(&sbi->s_mutex);
> >  
> >  	/* Store the old options */
> > @@ -1221,14 +1209,12 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
> >  	}
> >  	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
> >  		mutex_unlock(&sbi->s_mutex);
> > -		unlock_kernel();
> >  		return 0;
> >  	}
> >  	if (*flags & MS_RDONLY) {
> >  		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
> >  		    !(sbi->s_mount_state & EXT2_VALID_FS)) {
> >  			mutex_unlock(&sbi->s_mutex);
> > -			unlock_kernel();
> >  			return 0;
> >  		}
> >  		/*
> > @@ -1258,7 +1244,6 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
> >  	}
> >  	ext2_sync_super(sb, es);
> >  	mutex_unlock(&sbi->s_mutex);
> > -	unlock_kernel();
> >  	return 0;
> >  restore_opts:
> >  	sbi->s_mount_opt = old_opts.s_mount_opt;
> > @@ -1266,7 +1251,6 @@ restore_opts:
> >  	sbi->s_resgid = old_opts.s_resgid;
> >  	sb->s_flags = old_sb_flags;
> >  	mutex_unlock(&sbi->s_mutex);
> > -	unlock_kernel();
> >  	return err;
> >  }
> >  
> > -- 
> > 1.6.4.2
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
