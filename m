From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] ext4: make the bitmap read routines return real
 error codes
Date: Thu, 15 Oct 2015 08:02:08 -0700
Message-ID: <20151015150208.GP10390@birch.djwong.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215458.28872.63722.stgit@birch.djwong.org>
 <20151015145729.GJ17329@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30478 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbJOPCO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2015 11:02:14 -0400
Content-Disposition: inline
In-Reply-To: <20151015145729.GJ17329@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 15, 2015 at 10:57:29AM -0400, Theodore Ts'o wrote:
> On Mon, Oct 12, 2015 at 02:54:58PM -0700, Darrick J. Wong wrote:
> >   * Return buffer_head on success or NULL in case of failure.
> >   */
> > -struct buffer_head *
> > -ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
> > +int
> > +ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group,
> > +			      struct buffer_head **bbh)
> 
> 
> Is there a reason why you didn't use the ERR_PTR convention?

Hah!  I plumb forgot that existed. :(

Will send a revision with that fixed, thanks for catching it.

--D

> 
> >  
> > -struct buffer_head *
> > -ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
> > +int
> > +ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group,
> > +		       struct buffer_head **bbh)
> 
> And here....
> 
> >   * Return buffer_head of bitmap on success or NULL.
> >   */
> > -static struct buffer_head *
> > -ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
> > +static int
> > +ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group,
> > +		       struct buffer_head **bbh)
> >  {
> 
> And here....
> 
> 					- Ted
> 					
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
