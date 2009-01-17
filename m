From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, RFC] ext4: ignore i_size_high for directories
Date: Sat, 17 Jan 2009 18:36:53 -0500
Message-ID: <20090117233653.GC25943@mit.edu>
References: <1232125148-13785-1-git-send-email-tytso@mit.edu> <20090116235706.GK13929@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52915 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756719AbZAQXhM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 18:37:12 -0500
Content-Disposition: inline
In-Reply-To: <20090116235706.GK13929@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 17, 2009 at 07:57:06AM +0800, Andreas Dilger wrote:
> 
> Actually, it would be preferable to allow directories to grow beyond
> the 2GB limit.  2GB only allows about 30M files.  While the htree code
> is currently limited to only 2 levels deep, if you have 8kB+ block
> size it is possible to have directories larger than 2GB with only
> 2 levels of htree.

At some point, maybe, although e2fsprogs doesn't have any support for
directories > 2GB, and I strongly suspect there are other places in
the kernel where we assume directories are < 2GB.  So this is
something that I'd prefer we implement with a feature flag,
explicitly, probably after we get a better b-tree implementation into
ext4 (say, like the one you gave me a few months ago, if one of us
actually has time to try to get it integrated into the kernel and into
e2fsprogs).

> >  static inline loff_t ext4_isize(struct ext4_inode *raw_inode)
> >  {
> > +	if (S_ISDIR(le16_to_cpu(raw_inode->i_mode)))
> > +		return (loff_t) le32_to_cpu(raw_inode->i_size_lo);
> > +	else
> > +		return ((loff_t)le32_to_cpu(raw_inode->i_size_high) << 32) |
> > +			le32_to_cpu(raw_inode->i_size_lo);
> 
> If you are going to limit this it should be "if (!S_ISREG(...))"
> instead of "if (S_ISDIR(...))" because none of the special files
> should use i_size_high - e2fsck will clear a special inode if
> it has a non-zero size.

Hmm, yes, that's probably a better check; although for most special
inodes we ignore i_size so having an absurd i_size is harmless.
Looking at things, we should probably add a check to make sure that
i_size for symlinks is sane.

						- Ted
