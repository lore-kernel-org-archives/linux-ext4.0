From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v3] ext4: move ext4_ind_migrate() into migrate.c
Date: Tue, 9 Apr 2013 13:17:09 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1304091316360.22989@localhost>
References: <1365502256-3420-1-git-send-email-lczerner@redhat.com> <20130409110355.GA9108@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab3DILRN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 07:17:13 -0400
In-Reply-To: <20130409110355.GA9108@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 9 Apr 2013, Zheng Liu wrote:

> Date: Tue, 9 Apr 2013 19:03:55 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH v3] ext4: move ext4_ind_migrate() into migrate.c
> 
> On Tue, Apr 09, 2013 at 12:10:56PM +0200, Lukas Czerner wrote:
> > Move ext4_ind_migrate() into migrate.c file since it makes much more
> > sense and ext4_ext_migrate() is there as well.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> The patch looks good to me.  But it seems that you forgot to add
> bigalloc check.  IIRC, that patch hasn't be applied.

right :), I need to resend those as a series.

Thanks!
-Lukas

> 
> Regards,
>                                                 - Zheng
> 
> > ---
> >  fs/ext4/ext4.h    |    2 +-
> >  fs/ext4/extents.c |   59 ----------------------------------------------------
> >  fs/ext4/migrate.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  3 files changed, 60 insertions(+), 61 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index a0637e5..bb56920 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -2131,6 +2131,7 @@ extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
> >  
> >  /* migrate.c */
> >  extern int ext4_ext_migrate(struct inode *);
> > +extern int ext4_ind_migrate(struct inode *inode);
> >  
> >  /* namei.c */
> >  extern int ext4_dirent_csum_verify(struct inode *inode,
> > @@ -2620,7 +2621,6 @@ extern int ext4_find_delalloc_range(struct inode *inode,
> >  extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk);
> >  extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> >  			__u64 start, __u64 len);
> > -extern int ext4_ind_migrate(struct inode *inode);
> >  
> >  
> >  /* move_extent.c */
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 6c5a70a..3645357 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4715,62 +4715,3 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> >  
> >  	return error;
> >  }
> > -
> > -/*
> > - * Migrate a simple extent-based inode to use the i_blocks[] array
> > - */
> > -int ext4_ind_migrate(struct inode *inode)
> > -{
> > -	struct ext4_extent_header	*eh;
> > -	struct ext4_super_block		*es = EXT4_SB(inode->i_sb)->s_es;
> > -	struct ext4_inode_info		*ei = EXT4_I(inode);
> > -	struct ext4_extent		*ex;
> > -	unsigned int			i, len;
> > -	ext4_fsblk_t			blk;
> > -	handle_t			*handle;
> > -	int				ret;
> > -
> > -	if (!EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb,
> > -				       EXT4_FEATURE_INCOMPAT_EXTENTS) ||
> > -	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> > -		return -EINVAL;
> > -
> > -	down_write(&EXT4_I(inode)->i_data_sem);
> > -	ret = ext4_ext_check_inode(inode);
> > -	if (ret)
> > -		goto errout;
> > -
> > -	eh = ext_inode_hdr(inode);
> > -	ex  = EXT_FIRST_EXTENT(eh);
> > -	if (ext4_blocks_count(es) > EXT4_MAX_BLOCK_FILE_PHYS ||
> > -	    eh->eh_depth != 0 || eh->eh_entries > 1) {
> > -		ret = -EOPNOTSUPP;
> > -		goto errout;
> > -	}
> > -	if (eh->eh_entries == 0)
> > -		blk = len = 0;
> > -	else {
> > -		len = le16_to_cpu(ex->ee_len);
> > -		blk = ext4_ext_pblock(ex);
> > -		if (len > EXT4_NDIR_BLOCKS) {
> > -			ret = -EOPNOTSUPP;
> > -			goto errout;
> > -		}
> > -	}
> > -
> > -	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
> > -	if (IS_ERR(handle)) {
> > -		ret = PTR_ERR(handle);
> > -		goto errout;
> > -	}
> > -
> > -	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
> > -	memset(ei->i_data, 0, sizeof(ei->i_data));
> > -	for (i=0; i < len; i++)
> > -		ei->i_data[i] = cpu_to_le32(blk++);
> > -	ext4_mark_inode_dirty(handle, inode);
> > -	ext4_journal_stop(handle);
> > -errout:
> > -	up_write(&EXT4_I(inode)->i_data_sem);
> > -	return ret;
> > -}
> > diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> > index 480acf4..3464604 100644
> > --- a/fs/ext4/migrate.c
> > +++ b/fs/ext4/migrate.c
> > @@ -426,7 +426,6 @@ static int free_ext_block(handle_t *handle, struct inode *inode)
> >  			return retval;
> >  	}
> >  	return retval;
> > -
> >  }
> >  
> >  int ext4_ext_migrate(struct inode *inode)
> > @@ -606,3 +605,62 @@ out:
> >  
> >  	return retval;
> >  }
> > +
> > +/*
> > + * Migrate a simple extent-based inode to use the i_blocks[] array
> > + */
> > +int ext4_ind_migrate(struct inode *inode)
> > +{
> > +	struct ext4_extent_header	*eh;
> > +	struct ext4_super_block		*es = EXT4_SB(inode->i_sb)->s_es;
> > +	struct ext4_inode_info		*ei = EXT4_I(inode);
> > +	struct ext4_extent		*ex;
> > +	unsigned int			i, len;
> > +	ext4_fsblk_t			blk;
> > +	handle_t			*handle;
> > +	int				ret;
> > +
> > +	if (!EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb,
> > +				       EXT4_FEATURE_INCOMPAT_EXTENTS) ||
> > +	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> > +		return -EINVAL;
> > +
> > +	down_write(&EXT4_I(inode)->i_data_sem);
> > +	ret = ext4_ext_check_inode(inode);
> > +	if (ret)
> > +		goto errout;
> > +
> > +	eh = ext_inode_hdr(inode);
> > +	ex  = EXT_FIRST_EXTENT(eh);
> > +	if (ext4_blocks_count(es) > EXT4_MAX_BLOCK_FILE_PHYS ||
> > +	    eh->eh_depth != 0 || eh->eh_entries > 1) {
> > +		ret = -EOPNOTSUPP;
> > +		goto errout;
> > +	}
> > +	if (eh->eh_entries == 0)
> > +		blk = len = 0;
> > +	else {
> > +		len = le16_to_cpu(ex->ee_len);
> > +		blk = ext4_ext_pblock(ex);
> > +		if (len > EXT4_NDIR_BLOCKS) {
> > +			ret = -EOPNOTSUPP;
> > +			goto errout;
> > +		}
> > +	}
> > +
> > +	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
> > +	if (IS_ERR(handle)) {
> > +		ret = PTR_ERR(handle);
> > +		goto errout;
> > +	}
> > +
> > +	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
> > +	memset(ei->i_data, 0, sizeof(ei->i_data));
> > +	for (i = 0; i < len; i++)
> > +		ei->i_data[i] = cpu_to_le32(blk++);
> > +	ext4_mark_inode_dirty(handle, inode);
> > +	ext4_journal_stop(handle);
> > +errout:
> > +	up_write(&EXT4_I(inode)->i_data_sem);
> > +	return ret;
> > +}
> > -- 
> > 1.7.7.6
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
