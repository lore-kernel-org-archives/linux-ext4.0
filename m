From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Wed, 23 Jul 2008 14:19:21 -0400
Message-ID: <20080723181921.GB27683@mit.edu>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723011802.GB20749@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49734 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751400AbYGWST0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2008 14:19:26 -0400
Content-Disposition: inline
In-Reply-To: <20080723011802.GB20749@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 22, 2008 at 07:18:02PM -0600, Andreas Dilger wrote:
> On Jul 22, 2008  17:51 -0700, Mingming Cao wrote:
> > + * Calulate the total number of credits to reserve to fit
> > + * the modification of @num pages into a single transaction
> > + */
> > +int ext4_writepages_trans_blocks(struct inode *inode, int num)
> > +{
> > +	int bpp = ext4_journal_blocks_per_page(inode);
> > +	int nrblocks = num * bpp;
> > +
> > +	if (!EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
> > +		return ext4_writepages_trans_blocks_old(inode, nrblocks);
> 
> This should be "if (!(EXT4_I(inode)->i_flags & EXT_EXTENTS_FL))", and
> we should probably make it "unlikely()" since we expect most new files
> in an ext4 filesystem are extent mapped.

The cost of unlikely() can be pretty bad; the rule of thumb I've heard
is that unless it's less than 1% vs. 99%, you should probably avoid
using likely() and unlikely().  Given that there will be a fair number
of people who will be doing upgrades of existing ext3 filesystems, I
don't think using unlikely() would be a good choice here.

      	    	  	     	      	     - Ted
