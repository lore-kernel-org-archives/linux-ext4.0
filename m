From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 30/49] ext4: Convert truncate_mutex to read write
	semaphore.
Date: Thu, 24 Jan 2008 10:59:07 +0530
Message-ID: <20080124052907.GB7902@skywalker>
References: <1200970948-17903-23-git-send-email-tytso@mit.edu> <1200970948-17903-24-git-send-email-tytso@mit.edu> <1200970948-17903-25-git-send-email-tytso@mit.edu> <1200970948-17903-26-git-send-email-tytso@mit.edu> <1200970948-17903-27-git-send-email-tytso@mit.edu> <1200970948-17903-28-git-send-email-tytso@mit.edu> <1200970948-17903-29-git-send-email-tytso@mit.edu> <1200970948-17903-30-git-send-email-tytso@mit.edu> <1200970948-17903-31-git-send-email-tytso@mit.edu> <20080123140659.5b70ae6b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	Andy Whitcroft <apw@shadowen.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:45569 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752175AbYAXF3Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 00:29:16 -0500
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

The follow up patch "ext4: Take read lock during overwrite case" removes
those single line if statement.


> 
> > +	return retval;
> > +}
> >  static int ext4_get_block(struct inode *inode, sector_t iblock,
> >  			struct buffer_head *bh_result, int create)
> 
> Mising newline.

Fixed.

-aneesh
