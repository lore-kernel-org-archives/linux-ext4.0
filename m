From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: ignore EXT4_INODE_JOURNAL_DATA flag with
 delalloc
Date: Thu, 12 Jan 2012 08:12:54 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1201120802200.4829@dhcp-27-109.brq.redhat.com>
References: <1326266607-15211-1-git-send-email-lczerner@redhat.com> <4F0DD15D.7030706@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab2ALHM7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 02:12:59 -0500
In-Reply-To: <4F0DD15D.7030706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 11 Jan 2012, Eric Sandeen wrote:

> On 1/11/12 1:23 AM, Lukas Czerner wrote:
> > Ext4 does not support data journalling with delayed allocation enabled.
> > We even do not allow to mount the file system with delayed allocation
> > and data journalling enabled, however it can be set via FS_IOC_SETFLAGS
> > so we can hit the inode with EXT4_INODE_JOURNAL_DATA set even on file
> > system mounted with delayed allocation (default) and that's where
> > problem arises. The easies way to reproduce this problem is with the
> > following set of commands:
> > 
> >  mkfs.ext4 /dev/sdd
> >  mount /dev/sdd /mnt/test1
> >  dd if=/dev/zero of=/mnt/test1/file bs=1M count=4
> >  chattr +j /mnt/test1/file
> >  dd if=/dev/zero of=/mnt/test1/file bs=1M count=4 conv=notrunc
> >  chattr -j /mnt/test1/file
> > 
> > Additionally it can be reproduced quite reliably with xfstests 272 and
> > 269. In fact the above reproducer is a part of test 272.
> > 
> > To fix this we should ignore the EXT4_INODE_JOURNAL_DATA inode flag if
> > the file system is mounted with delayed allocation. This can be easily
> > done by fixing ext4_should_*_data() functions do ignore data journal
> > flag when delalloc is set (suggested by Ted). We also have to set the
> > appropriate address space operations for the inode (again, ignoring data
> > journal flag if delalloc enabled).
> > 
> > Additionally this commit introduces ext4_inode_journal_mode() function
> > because ext4_should_*_data() has already had a lot of common code and
> > this change is putting it all into one function so it is easier to
> > read.
> 
> I suppose I would have preferred that to be 2 different patches - ignore
> the journal flag in one step and do the code reorg in another, just for
> clarity when looking through git logs and reviewing commits...

Well, then I would have to rework twice the same code. First add the
delalloc condition to all three functions and then reorganise it in the
second patch. Is this really necessary ? the change is not too big.

> 
> Other than that, the logic all seems ok to me, though I have a few
> nitpicky comments below.
> 
> -Eric
> 
> > Successfully tested with xfstest in following configurations:
> > 
> > delalloc + data=ordered
> > delalloc + data=writeback
> > data=journal
> > nodelalloc + data=ordered
> > nodelalloc + data=writeback
> > nodelalloc + data=journal
> > 
> > (I wish we can get rid of the data=journal mode)
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/ext4_jbd2.h |   55 ++++++++++++++++++++++++++-------------------------
> >  fs/ext4/inode.c     |   36 ++++++++++++++++++++-------------
> >  2 files changed, 50 insertions(+), 41 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> > index 5802fa1..8a1982a 100644
> > --- a/fs/ext4/ext4_jbd2.h
> > +++ b/fs/ext4/ext4_jbd2.h
> > @@ -261,43 +261,44 @@ static inline void ext4_update_inode_fsync_trans(handle_t *handle,
> >  /* super.c */
> >  int ext4_force_commit(struct super_block *sb);
> >  
> > -static inline int ext4_should_journal_data(struct inode *inode)
> > +/*
> > + * Ext4 inode journal modes
> > + */
> > +#define EXT4_INODE_JOURNAL_DATA_MODE	0x01 /* journal data mode */
> > +#define EXT4_INODE_ORDER_DATA_MODE	0x02 /* ordered data mode */
> 
> Should probably be EXT4_INODE_ORDERED_DATA_MODE?

Yes, it probably should. I'll change that.

> 
> > +#define EXT4_INODE_WRITEBACK_DATA_MODE	0x04 /* writeback data mode */
> > +
> > +static inline int ext4_inode_journal_mode(struct inode *inode)
> >  {
> >  	if (EXT4_JOURNAL(inode) == NULL)
> > -		return 0;
> > -	if (!S_ISREG(inode->i_mode))
> > -		return 1;
> > -	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
> > -		return 1;
> > -	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> > -		return 1;
> > -	return 0;
> > +		return EXT4_INODE_WRITEBACK_DATA_MODE;	/* writeback */
> > +	/* We do not support data journalling with delayed allocation */
> > +	if ((!S_ISREG(inode->i_mode)) ||
> 
> I wonder if there's any way to make this if() more readable.
> 
> I think the first extra set of () makes this harder to read, it's easy to think
> the first opening ( extends past the || since it otherwise wouldn't be
> necessary?  I guess I'm getting nitpicky here.

I can remove the extra set of ().

> 
> > +	   (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) ||
> > +	   (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
> > +	   (!test_opt(inode->i_sb, DELALLOC))))
> > +		return EXT4_INODE_JOURNAL_DATA_MODE;	/* journal data */
> > +	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
> > +		return EXT4_INODE_ORDER_DATA_MODE;		/* ordered */
> 
> I'd remove a tab there just to line up the comments :)
> 
> (actually the comments may not be necessary, they are just restating the
> flag, but they stand out a bit more I guess)

Right, it is not necessary, but it makes it more readable. I'll align it
properly.

> 
> > +	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
> > +		return EXT4_INODE_WRITEBACK_DATA_MODE;	/* writeback */
> > +	else
> > +		BUG();
> 
> Hm 2 new BUG() statements in the patch.  If these are at all possible
> to hit, maybe a printk at least saying where we are and what state we're
> in first?  Should we instead fall back to a common/safe journaling mode,
> rather than BUG()?
> 
> I guess it's pretty much impossible, if the journaling mode is set to
> any of the 3 possible values, we get a normal return.

Both cases are pretty much impossible to happen, of course only if we
did not screwed up the conditions somehow :) Which might happen with the
amount of conditions there. Just call it defensive programming :) of
some sort. I do not think printk is necessary since BUG() will show the
line number in the usual case and it is there just so we do not mess it
up when changing the code in that area.


Thanks for the review Eric.

-Lukas

> 
> > +}
> > +
> > +static inline int ext4_should_journal_data(struct inode *inode)
> > +{
> > +	return ext4_inode_journal_mode(inode) & EXT4_INODE_JOURNAL_DATA_MODE;
> >  }
> >  
> >  static inline int ext4_should_order_data(struct inode *inode)
> >  {
> > -	if (EXT4_JOURNAL(inode) == NULL)
> > -		return 0;
> > -	if (!S_ISREG(inode->i_mode))
> > -		return 0;
> > -	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> > -		return 0;
> > -	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
> > -		return 1;
> > -	return 0;
> > +	return ext4_inode_journal_mode(inode) & EXT4_INODE_ORDER_DATA_MODE;
> >  }
> >  
> >  static inline int ext4_should_writeback_data(struct inode *inode)
> >  {
> > -	if (EXT4_JOURNAL(inode) == NULL)
> > -		return 1;
> > -	if (!S_ISREG(inode->i_mode))
> > -		return 0;
> > -	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> > -		return 0;
> > -	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
> > -		return 1;
> > -	return 0;
> > +	return ext4_inode_journal_mode(inode) & EXT4_INODE_WRITEBACK_DATA_MODE;
> >  }
> >  
> >  /*
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index aa8efa6..3b07d22 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -2479,13 +2479,14 @@ static int ext4_da_write_end(struct file *file,
> >  	int write_mode = (int)(unsigned long)fsdata;
> >  
> >  	if (write_mode == FALL_BACK_TO_NONDELALLOC) {
> > -		if (ext4_should_order_data(inode)) {
> > +		switch (ext4_inode_journal_mode(inode)) {
> > +		case EXT4_INODE_ORDER_DATA_MODE:
> >  			return ext4_ordered_write_end(file, mapping, pos,
> >  					len, copied, page, fsdata);
> > -		} else if (ext4_should_writeback_data(inode)) {
> > +		case EXT4_INODE_WRITEBACK_DATA_MODE:
> >  			return ext4_writeback_write_end(file, mapping, pos,
> >  					len, copied, page, fsdata);
> > -		} else {
> > +		default:
> >  			BUG();
> >  		}
> >  	}
> > @@ -3083,18 +3084,25 @@ static const struct address_space_operations ext4_da_aops = {
> >  
> >  void ext4_set_aops(struct inode *inode)
> >  {
> > -	if (ext4_should_order_data(inode) &&
> > -		test_opt(inode->i_sb, DELALLOC))
> > -		inode->i_mapping->a_ops = &ext4_da_aops;
> > -	else if (ext4_should_order_data(inode))
> > -		inode->i_mapping->a_ops = &ext4_ordered_aops;
> > -	else if (ext4_should_writeback_data(inode) &&
> > -		 test_opt(inode->i_sb, DELALLOC))
> > -		inode->i_mapping->a_ops = &ext4_da_aops;
> > -	else if (ext4_should_writeback_data(inode))
> > -		inode->i_mapping->a_ops = &ext4_writeback_aops;
> > -	else
> > +	switch (ext4_inode_journal_mode(inode)) {
> > +	case EXT4_INODE_ORDER_DATA_MODE:
> > +		if (test_opt(inode->i_sb, DELALLOC))
> > +			inode->i_mapping->a_ops = &ext4_da_aops;
> > +		else
> > +			inode->i_mapping->a_ops = &ext4_ordered_aops;
> > +		break;
> > +	case EXT4_INODE_WRITEBACK_DATA_MODE:
> > +		if (test_opt(inode->i_sb, DELALLOC))
> > +			inode->i_mapping->a_ops = &ext4_da_aops;
> > +		else
> > +			inode->i_mapping->a_ops = &ext4_writeback_aops;
> > +		break;
> > +	case EXT4_INODE_JOURNAL_DATA_MODE:
> >  		inode->i_mapping->a_ops = &ext4_journalled_aops;
> > +		break;
> > +	default:
> > +		BUG();
> > +	}
> >  }
> >  
> >  
> 
> 

-- 
