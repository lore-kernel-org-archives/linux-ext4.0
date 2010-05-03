From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH] Prevent creation of files larger than RLIMIT_FSIZE using fallocate
Date: Mon, 3 May 2010 09:53:44 +0530
Message-ID: <201005030953.45157.knikanth@suse.de>
References: <201004281854.49730.knikanth@suse.de> <20100430143319.d51d6d77.akpm@linux-foundation.org> <20100501070426.GA9562@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, coly.li@suse.de,
	Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>,
	Christoph Hellwig <hch@infradead.org>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39417 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab0ECEWO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 May 2010 00:22:14 -0400
In-Reply-To: <20100501070426.GA9562@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Saturday 01 May 2010 12:34:26 Amit K. Arora wrote:
> On Fri, Apr 30, 2010 at 02:33:19PM -0700, Andrew Morton wrote:
> > (Amit Arora <aarora@in.ibm.com> wrote fallocate.  cc added)
> 
> Thanks for adding me to CC.
> 
> > On Thu, 29 Apr 2010 10:14:06 +0530
> >
> > Nikanth Karthikesan <knikanth@suse.de> wrote:
> > > Here is an updated patch that takes the i_mutex and calls
> > > inode_newsize_ok() only for regular files.
> >
> > err, no.  It's taking i_lock where it meant to take i_mutex.
> >
> > > Thanks
> > > Nikanth
> > >
> > > +	if (S_ISREG(inode->i_mode)) {
> > > +		spin_lock(&inode->i_lock);
> > > +		ret = inode_newsize_ok(inode, (offset + len));
> > > +		spin_unlock(&inode->i_lock);
> > > +		if (ret)
> > > +			return ret;
> > > +	} else if (S_ISDIR(inode->i_mode)) {
> > > +		/*
> > > +		 * Let individual file system decide if it supports
> > > +		 * preallocation for directories or not.
> > > +		 */
> > > +		if (offset > inode->i_sb->s_maxbytes)
> > > +			return -EFBIG;
> > > +	} else
> > > +		return -ENODEV;
> > > +
> > >  	if (!inode->i_op->fallocate)
> > >  		return -EOPNOTSUPP;
> >
> > Also, there doesn't seem to be much point in doing
> >
> > 	mutex_lock(i_mutex);
> > 	if (some_condition)
> > 		bale out
> > 	mutex_unlock(i_mutex);
> >
> > 	<stuff>
> >
> > because `some_condition' can now become true before or during the
> > execution of `stuff'.
> >
> > IOW, it's racy.
> 

oh, yes. :(

> Agreed. How about doing this check in the filesystem specific fallocate
> inode routines instead ? For example, in ext4 we could do :
> 

I guess, calling the filesystem specific fallocate with the lock held would 
create lock ordering problems? If so, this might be the only way. But it would 
be better to document at the call site, that the callee should check for 
RLIMIT_FSIZE.

Thanks
Nikanth

> diff -Nuarp linux-2.6.org/fs/ext4/extents.c linux-2.6.new/fs/ext4/extents.c
> --- linux-2.6.org/fs/ext4/extents.c	2010-05-01 12:16:07.000000000 +0530
> +++ linux-2.6.new/fs/ext4/extents.c	2010-05-01 12:17:37.000000000 +0530
> @@ -3672,6 +3672,11 @@ long ext4_fallocate(struct inode *inode,
>  	 */
>  	credits = ext4_chunk_trans_blocks(inode, max_blocks);
>  	mutex_lock(&inode->i_mutex);
> +	ret = inode_newsize_ok(inode, (offset + len));
> +	if (ret) {
> +		mutex_unlock(&inode->i_mutex);
> +		return ret;
> +	}
>  retry:
>  	while (ret >= 0 && ret < max_blocks) {
>  		block = block + ret;
> 
> 
> Similarly for ocfs2, btrfs and xfs..
> 
> --
> Regards,
> Amit Arora
> 
