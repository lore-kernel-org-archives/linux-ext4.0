From: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 30/49] ext4: Convert truncate_mutex to read write semaphore.
Date: Thu, 24 Jan 2008 13:00:53 +0000
Message-ID: <20080124130018.GA11136@shadowen.org>
References: <1200970948-17903-23-git-send-email-tytso@mit.edu> <1200970948-17903-24-git-send-email-tytso@mit.edu> <1200970948-17903-25-git-send-email-tytso@mit.edu> <1200970948-17903-26-git-send-email-tytso@mit.edu> <1200970948-17903-27-git-send-email-tytso@mit.edu> <1200970948-17903-28-git-send-email-tytso@mit.edu> <1200970948-17903-29-git-send-email-tytso@mit.edu> <1200970948-17903-30-git-send-email-tytso@mit.edu> <1200970948-17903-31-git-send-email-tytso@mit.edu> <20080123140659.5b70ae6b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	aneesh.kumar@linux.vnet.ibm.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hellhawk.shadowen.org ([80.68.90.175]:2799 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYAXNBB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 08:01:01 -0500
Content-Disposition: inline
In-Reply-To: <20080123140659.5b70ae6b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 23, 2008 at 02:06:59PM -0800, Andrew Morton wrote:
> > On Mon, 21 Jan 2008 22:02:09 -0500 "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> > +int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
> > +			unsigned long max_blocks, struct buffer_head *bh,
> > +			int create, int extend_disksize)
> > +{
> > +	int retval;
> > +	if (create) {
> > +		down_write((&EXT4_I(inode)->i_data_sem));
> > +	} else {
> > +		down_read((&EXT4_I(inode)->i_data_sem));
> > +	}
> > +	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
> > +		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
> > +				bh, create, extend_disksize);
> > +	} else {
> > +		retval = ext4_get_blocks_handle(handle, inode, block,
> > +				max_blocks, bh, create, extend_disksize);
> > +	}
> > +	if (create) {
> > +		up_write((&EXT4_I(inode)->i_data_sem));
> > +	} else {
> > +		up_read((&EXT4_I(inode)->i_data_sem));
> > +	}
> 
> This function has many unneeded braces.  checkpatch used to detect this
> but it seems to have broken.

This is a side effect of this rule:
	
	This does not apply if one branch of a conditional statement
	is a single statement. Use braces in both branches.

Basically each arm is being considered in isolation, each arm is seen as
having a "sibling" arm with braces so it is permitted to have braces.
Bugger.

I guess I'll try and see if I can detect this.

> > +	return retval;
> > +}
> >  static int ext4_get_block(struct inode *inode, sector_t iblock,
> >  			struct buffer_head *bh_result, int create)
> 
> Mising newline.

We could check for those ... will look to add in the next release.

-apw
