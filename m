From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] ext4: make online defrag error reporting consistent
Date: Wed, 17 Jun 2015 14:02:42 -0400
Message-ID: <20150617180242.GB1746@localhost.localdomain>
References: <20150617164035.GA1746@localhost.localdomain>
 <20150617171532.GE7063@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34478 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbbFQSCT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jun 2015 14:02:19 -0400
Received: by qkeo142 with SMTP id o142so13438338qke.1
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2015 11:02:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150617171532.GE7063@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Darrick J. Wong <darrick.wong@oracle.com>:
> On Wed, Jun 17, 2015 at 12:40:35PM -0400, Eric Whitney wrote:
> > Make the error reporting behavior resulting from the unsupported use
> > of online defrag on files with data journaling enabled consistent with
> > that implemented for bigalloc file systems. Difference found with
> > ext4/308.
> > 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > ---
> >  fs/ext4/move_extent.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> > index 8c04afb..fb6f117 100644
> > --- a/fs/ext4/move_extent.c
> > +++ b/fs/ext4/move_extent.c
> > @@ -571,12 +571,16 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
> >  			orig_inode->i_ino, donor_inode->i_ino);
> >  		return -EINVAL;
> >  	}
> > -	/* TODO: This is non obvious task to swap blocks for inodes with full
> > -	   jornaling enabled */
> > +
> > +	/* TODO: it's not obvious how to swap blocks for inodes with full
> > +	   journaling enabled */
> >  	if (ext4_should_journal_data(orig_inode) ||
> >  	    ext4_should_journal_data(donor_inode)) {
> > -		return -EINVAL;
> > +		ext4_msg(orig_inode->i_sb, KERN_ERR,
> > +			 "Online defrag not supported with data journaling");
> > +		return -EOPNOTSUPP;
> >  	}
> > +
> 
> One minor nit: If it's solely the donor_inode that's data=journal (i.e. we
> didn't mount with data=journal and only the donor inode is chattr +j), the
> inode number reported in the message will be inaccurate.
> 
> I'm not sure why you'd chattr +j only the donor inode, so in practice this
> isn't likely to occur.
> 
> Other than that,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 

The message reports the file system's device rather than an inode number
in this case.  Code above this snippet verified that the original and
donor inodes were from the same file system, so hopefully the reported
device will be correct even if only the donor inode is chattr +j.
Unless I'm missing something, of course...

Thanks for the review!
Eric


> --D
> 
> >  	/* Protect orig and donor inodes against a truncate */
> >  	lock_two_nondirectories(orig_inode, donor_inode);
> >  
> > -- 
> > 2.1.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
