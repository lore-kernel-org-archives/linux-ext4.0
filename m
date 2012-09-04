From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: serialize unlocked dio reads with truncate
Date: Tue, 04 Sep 2012 21:15:59 +0400
Message-ID: <87ipbtr9o0.fsf@openvz.org>
References: <1346690448-16917-1-git-send-email-dmonakhov@openvz.org> <20120904135214.GB8656@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55106 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab2IDRQD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 13:16:03 -0400
Received: by lagy9 with SMTP id y9so4330318lag.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Sep 2012 10:16:01 -0700 (PDT)
In-Reply-To: <20120904135214.GB8656@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 4 Sep 2012 15:52:14 +0200, Jan Kara <jack@suse.cz> wrote:
> On Mon 03-09-12 20:40:48, Dmitry Monakhov wrote:
> > Current serialization will works only for DIO which holds
> > i_mutex, but nonlocked DIO following race is possable:
> > 
> > dio_nolock_read_task            truncate_task
> > 				->ext4_setattr()
> > 				 ->inode_dio_wait()
> > ->ext4_ext_direct_IO
> >   ->ext4_ind_direct_IO
> >     ->__blockdev_direct_IO
> >       ->ext4_get_block
> > 				 ->truncate_setsize()
> > 				 ->ext4_truncate()
> > 				 #alloc truncated blocks
> > 				 #to other inode
> >       ->submit_io()
> >      #INFORMATION LEAK
>   Right, that looks like a bug. Just isn't the "unlocked DIO" also
> problematic because if we have enough aggressive readers, callers doing
> inode_dio_wait() are waiting forever (I've just tried that with the value
> of forever == several minutes).
Yep.. you right. I already has patch which allow to disable nonlock DIO read
optimization on per inode basis which is reasonable for truncate.
> 
>   Also there is similar data exposure possible when direct IO read races
> with block allocation, isn't it?
> 
>   Hum, and there seems to be also potential data corruption issue with
> direct IO overwrites racing with truncate:
> Like:
>  dio write                      truncate_task
>  ->ext4_ext_direct_IO
>   ->overwrite == 1
>    ->down_read(&EXT4_I(inode)->i_data_sem);
>    ->mutex_unlock(&inode->i_mutex);
>  				->ext4_setattr()
>  				 ->inode_dio_wait()
>  				 ->truncate_setsize()
>  				 ->ext4_truncate()
> 				  ->down_write(&EXT4_I(inode)->i_data_sem);
>    ->__blockdev_direct_IO
>     ->ext4_get_block
>     ->submit_io()
>    ->up_read(&EXT4_I(inode)->i_data_sem);
>  				  # truncate data blocks, allocate them to
>  				  # other inode - bad stuff happens because
> 				  # dio is still in flight.
>
This is fun, i've looked at this place, but completely overlooked this 
case. Off course you right. 
Imho we may protect this type of locking optimization
by grabbing extra inode->i_dio_count reference before i_mutex drop.
will send patch in a minute.

>   Anyway your patch makes things better so I'm fine with it (feel free to
> add Reviewed-by: Jan Kara <jack@suse.cz>). Just it seems direct IO locking
> is rather broken in general...
> 
> 								Honza
> 
> > In order to serialize with unlocked DIO reads we have to
> > rearange wait sequance
>   ^^^ rearrange  ^^^ sequence
> 
> > 1) update i_size first
> > 2) wait for outstanding DIO requests
> > 3) and only after that truncate inode blocks
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/ext4/inode.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index d12d30e..ee534ab 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4304,8 +4304,6 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
> >  	}
> >  
> >  	if (attr->ia_valid & ATTR_SIZE) {
> > -		inode_dio_wait(inode);
> > -
> >  		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
> >  			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> >  
> > @@ -4355,6 +4353,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
> >  	if (attr->ia_valid & ATTR_SIZE) {
> >  		if (attr->ia_size != i_size_read(inode))
> >  			truncate_setsize(inode, attr->ia_size);
> > +		inode_dio_wait(inode);
> >  		ext4_truncate(inode);
> >  	}
> >  
> > -- 
> > 1.7.7.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
