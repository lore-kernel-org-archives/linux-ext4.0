From: Jan Kara <jack@suse.cz>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging
	request in ext2_free_blocks
Date: Tue, 19 Aug 2008 11:13:39 +0200
Message-ID: <20080819091339.GE14799@duck.suse.cz>
References: <bug-11266-10286@http.bugzilla.kernel.org/> <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi> <20080807202840.GC26307@lh.kyla.fi> <20080818145841.GC10621@atrey.karlin.mff.cuni.cz> <20080818165131.GC6491@skywalker> <20080819032410.GE3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Sami Liedes <sliedes@cc.hut.fi>,
	Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58442 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752654AbYHSJNl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Aug 2008 05:13:41 -0400
Content-Disposition: inline
In-Reply-To: <20080819032410.GE3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 18-08-08 21:24:10, Andreas Dilger wrote:
> On Aug 18, 2008  22:21 +0530, Aneesh Kumar wrote:
> > > +static int ext2_block_in_group(struct super_block *sb,
> > > +			unsigned int block_group, ext2_fsblk_t block)
> > > +{
> > > +	if (block < ext2_group_first_block_no(sb, block_group))
> > > +		return 0;
> > > +	if (block >= ext2_group_first_block_no(sb, block_group) +
> > > +	    EXT2_BLOCKS_PER_GROUP(sb))
> > > +		return 0;
> > > +	return 1;
> > > +}
> > > +
> > >  /*
> > >   * Read the bitmap for a given block_group,and validate the
> > >   * bits for block/inode/inode tables are set in the bitmaps
> > > @@ -129,6 +140,24 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
> > >  	desc = ext2_get_group_desc(sb, block_group, NULL);
> > >  	if (!desc)
> > >  		return NULL;
> > > +	if (!ext2_block_in_group(sb, block_group,
> > > +				le32_to_cpu(desc->bg_block_bitmap)) ||
> > > +	    !ext2_block_in_group(sb, block_group,
> > > +				le32_to_cpu(desc->bg_inode_bitmap)) ||
> > > +	    !ext2_block_in_group(sb, block_group,
> > > +				le32_to_cpu(desc->bg_inode_table)) ||
> > > +	    !ext2_block_in_group(sb, block_group,
> > > +				le32_to_cpu(desc->bg_inode_table) +
> > > +				EXT2_SB(sb)->s_itb_per_group - 1)) {
> 
> Isn't equivalent checking done in ext2_check_descriptors()?  It would make
> sense to abstract out the "check one group and return error" code and use
> it in both places.
  Actually yes, it is. Good point. Sami, is it the case that you have
mounted the filesystem, then intentionally corrupted it and after that
the kernel oopsed (as opposed to first corrupting the filesystem image and
mounting it after that)? That would explain how corrupted values could get
to read_block_bitmap() even though ext2_check_descriptors() checked them.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
