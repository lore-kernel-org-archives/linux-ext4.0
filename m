From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 36/49] ext4: Add EXT4_IOC_MIGRATE ioctl
Date: Sat, 26 Jan 2008 14:12:47 +0530
Message-ID: <20080126084247.GA6778@skywalker>
References: <1200970948-17903-31-git-send-email-tytso@mit.edu> <1200970948-17903-32-git-send-email-tytso@mit.edu> <1200970948-17903-33-git-send-email-tytso@mit.edu> <1200970948-17903-34-git-send-email-tytso@mit.edu> <1200970948-17903-35-git-send-email-tytso@mit.edu> <1200970948-17903-36-git-send-email-tytso@mit.edu> <1200970948-17903-37-git-send-email-tytso@mit.edu> <20080123140716.e6f5d14f.akpm@linux-foundation.org> <20080124055532.GC7902@skywalker> <20080126041500.GA28889@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:45608 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYAZIm7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2008 03:42:59 -0500
Content-Disposition: inline
In-Reply-To: <20080126041500.GA28889@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2008 at 11:15:00PM -0500, Theodore Tso wrote:
> On Thu, Jan 24, 2008 at 11:25:32AM +0530, Aneesh Kumar K.V wrote:
> > +static int free_ext_idx(handle_t *handle, struct inode *inode,
> > +					struct ext4_extent_idx *ix)
> > +{
> > +	int i, retval = 0;
> > +	ext4_fsblk_t block;
> > +	struct buffer_head *bh;
> > +	struct ext4_extent_header *eh;
> > +
> > +	block = idx_pblock(ix);
> > +	bh = sb_bread(inode->i_sb, block);
> > +	if (!bh)
> > +		return -EIO;
> > +
> > +	eh = (struct ext4_extent_header *)bh->b_data;
> > +	if (eh->eh_depth == 0) {
> > +		brelse(bh);
> > +		ext4_free_blocks(handle, inode, block, 1);
> > +	} else {
> > +		ix = EXT_FIRST_INDEX(eh);
> > +		for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ix++) {
> > +			retval = free_ext_idx(handle, inode, ix);
> > +			if (retval)
> > +				return retval;
> > +		}
> > +	}
> > +	return retval;
> > +}
> 
> Aneesh, looks like if eh->eh_depth is != 0, bh gets leaked.  This is
> how I plan to fix it up:
> 
> +static int free_ext_idx(handle_t *handle, struct inode *inode,
> +					struct ext4_extent_idx *ix)
> +{
> +	int i, retval = 0;
> +	ext4_fsblk_t block;
> +	struct buffer_head *bh;
> +	struct ext4_extent_header *eh;
> +
> +	block = idx_pblock(ix);
> +	bh = sb_bread(inode->i_sb, block);
> +	if (!bh)
> +		return -EIO;
> +
> +	eh = (struct ext4_extent_header *)bh->b_data;
> +	if (eh->eh_depth == 0)
> +		ext4_free_blocks(handle, inode, block, 1);
> +	else {
> +		ix = EXT_FIRST_INDEX(eh);
> +		for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ix++) {
> +			retval = free_ext_idx(handle, inode, ix);
> +			if (retval)
> +				break;
> +		}
> +	}
> +	put_bh(bh);


We need to mark the index block as free.
 via ext4_free_blocks(handle, inode, block, 1);

I remember making this change. May be it was related to dind/tind
blocks. 


-aneesh
