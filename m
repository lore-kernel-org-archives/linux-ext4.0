From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: make online defrag error reporting consistent
Date: Wed, 17 Jun 2015 11:04:37 -0700
Message-ID: <20150617180437.GG6343@birch.djwong.org>
References: <20150617164035.GA1746@localhost.localdomain>
 <20150617171532.GE7063@birch.djwong.org>
 <20150617180242.GB1746@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49590 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbbFQSEq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jun 2015 14:04:46 -0400
Content-Disposition: inline
In-Reply-To: <20150617180242.GB1746@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 17, 2015 at 02:02:42PM -0400, Eric Whitney wrote:
> * Darrick J. Wong <darrick.wong@oracle.com>:
> > On Wed, Jun 17, 2015 at 12:40:35PM -0400, Eric Whitney wrote:
> > > Make the error reporting behavior resulting from the unsupported use
> > > of online defrag on files with data journaling enabled consistent with
> > > that implemented for bigalloc file systems. Difference found with
> > > ext4/308.
> > > 
> > > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > > ---
> > >  fs/ext4/move_extent.c | 10 +++++++---
> > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> > > index 8c04afb..fb6f117 100644
> > > --- a/fs/ext4/move_extent.c
> > > +++ b/fs/ext4/move_extent.c
> > > @@ -571,12 +571,16 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
> > >  			orig_inode->i_ino, donor_inode->i_ino);
> > >  		return -EINVAL;
> > >  	}
> > > -	/* TODO: This is non obvious task to swap blocks for inodes with full
> > > -	   jornaling enabled */
> > > +
> > > +	/* TODO: it's not obvious how to swap blocks for inodes with full
> > > +	   journaling enabled */
> > >  	if (ext4_should_journal_data(orig_inode) ||
> > >  	    ext4_should_journal_data(donor_inode)) {
> > > -		return -EINVAL;
> > > +		ext4_msg(orig_inode->i_sb, KERN_ERR,
> > > +			 "Online defrag not supported with data journaling");
> > > +		return -EOPNOTSUPP;
> > >  	}
> > > +
> > 
> > One minor nit: If it's solely the donor_inode that's data=journal (i.e. we
> > didn't mount with data=journal and only the donor inode is chattr +j), the
> > inode number reported in the message will be inaccurate.
> > 
> > I'm not sure why you'd chattr +j only the donor inode, so in practice this
> > isn't likely to occur.
> > 
> > Other than that,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> 
> The message reports the file system's device rather than an inode number
> in this case.  Code above this snippet verified that the original and
> donor inodes were from the same file system, so hopefully the reported
> device will be correct even if only the donor inode is chattr +j.
> Unless I'm missing something, of course...

inode->i_sb ==> superblock, d'oh!

You're right, I misread that expression for the inode number, ignore my
noise. :)

--D

> 
> Thanks for the review!
> Eric
> 
> 
> > --D
> > 
> > >  	/* Protect orig and donor inodes against a truncate */
> > >  	lock_two_nondirectories(orig_inode, donor_inode);
> > >  
> > > -- 
> > > 2.1.4
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
