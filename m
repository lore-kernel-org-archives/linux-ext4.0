From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 25/29] ext4: Use generic_file_fsync() in
 ext4_file_fsync() in nojournal mode
Date: Wed, 8 May 2013 13:29:41 +0200
Message-ID: <20130508112941.GD30550@quack.suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-26-git-send-email-jack@suse.cz>
 <20130508073734.GB32600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab3EHL3o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 May 2013 07:29:44 -0400
Content-Disposition: inline
In-Reply-To: <20130508073734.GB32600@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 08-05-13 15:37:34, Zheng Liu wrote:
> On Mon, Apr 08, 2013 at 11:32:30PM +0200, Jan Kara wrote:
> > Just use the generic function instead of duplicating it. We only need
> > to reshuffle the read-only check a bit (which is there to prevent
> > writing to a filesystem which has been remounted read-only after error
> > I assume).
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> A minor nit below.  Otherwise the patch looks good to me.
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> > ---
> >  fs/ext4/fsync.c |   45 ++++++++++-----------------------------------
> >  1 files changed, 10 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> > index e02ba1b..1c08780 100644
> > --- a/fs/ext4/fsync.c
> > +++ b/fs/ext4/fsync.c
> > @@ -73,32 +73,6 @@ static int ext4_sync_parent(struct inode *inode)
> >  	return ret;
> >  }
> >  
> > -/**
> > - * __sync_file - generic_file_fsync without the locking and filemap_write
> > - * @inode:	inode to sync
> > - * @datasync:	only sync essential metadata if true
> > - *
> > - * This is just generic_file_fsync without the locking.  This is needed for
> > - * nojournal mode to make sure this inodes data/metadata makes it to disk
> > - * properly.  The i_mutex should be held already.
> > - */
> > -static int __sync_inode(struct inode *inode, int datasync)
> > -{
> > -	int err;
> > -	int ret;
> > -
> > -	ret = sync_mapping_buffers(inode->i_mapping);
> > -	if (!(inode->i_state & I_DIRTY))
> > -		return ret;
> > -	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> > -		return ret;
> > -
> > -	err = sync_inode_metadata(inode, 1);
> > -	if (ret == 0)
> > -		ret = err;
> > -	return ret;
> > -}
> > -
> >  /*
> >   * akpm: A new design for ext4_sync_file().
> >   *
> > @@ -116,7 +90,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >  	struct inode *inode = file->f_mapping->host;
> >  	struct ext4_inode_info *ei = EXT4_I(inode);
> >  	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
> > -	int ret, err;
> > +	int ret = 0, err;
> >  	tid_t commit_tid;
> >  	bool needs_barrier = false;
> >  
> > @@ -124,21 +98,21 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >  
> >  	trace_ext4_sync_file_enter(file, datasync);
> >  
> > -	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
> > -	if (ret)
> > -		return ret;
> > -	mutex_lock(&inode->i_mutex);
> > -
> >  	if (inode->i_sb->s_flags & MS_RDONLY)
> > -		goto out;
> > +		goto out_trace;
> >  
> >  	if (!journal) {
> > -		ret = __sync_inode(inode, datasync);
> > +		ret = generic_file_fsync(file, start, end, datasync);
> >  		if (!ret && !hlist_empty(&inode->i_dentry))
> >  			ret = ext4_sync_parent(inode);
> >  		goto out;
>                      ^^^^
>                 goto out_trace;
> Otherwise we will unlock i_mutex that we haven't take it.
  Ha, good spotting! The following patch will fix this but nevertheless
it's good to fix the breakage here. Thanks for review.

								Honza

> >  	}
> >  
> > +	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
> > +	if (ret)
> > +		return ret;
> > +	mutex_lock(&inode->i_mutex);
> > +
> >  	/*
> >  	 * data=writeback,ordered:
> >  	 *  The caller's filemap_fdatawrite()/wait will sync the data.
> > @@ -169,8 +143,9 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >  		if (!ret)
> >  			ret = err;
> >  	}
> > - out:
> > +out:
> >  	mutex_unlock(&inode->i_mutex);
> > +out_trace:
> >  	trace_ext4_sync_file_exit(inode, ret);
> >  	return ret;
> >  }
> > -- 
> > 1.7.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
