From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging
	request in ext2_free_blocks
Date: Mon, 18 Aug 2008 21:24:10 -0600
Message-ID: <20080819032410.GE3392@webber.adilger.int>
References: <bug-11266-10286@http.bugzilla.kernel.org/>
 <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi>
 <20080807202840.GC26307@lh.kyla.fi>
 <20080818145841.GC10621@atrey.karlin.mff.cuni.cz>
 <20080818165131.GC6491@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Sami Liedes <sliedes@cc.hut.fi>,
	Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43211 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYHSDYU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 23:24:20 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7J3OFYP011205
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 20:24:15 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K5T00001VY8PF00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 18 Aug 2008 20:24:15 -0700 (PDT)
In-reply-to: <20080818165131.GC6491@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 18, 2008  22:21 +0530, Aneesh Kumar wrote:
> > +static int ext2_block_in_group(struct super_block *sb,
> > +			unsigned int block_group, ext2_fsblk_t block)
> > +{
> > +	if (block < ext2_group_first_block_no(sb, block_group))
> > +		return 0;
> > +	if (block >= ext2_group_first_block_no(sb, block_group) +
> > +	    EXT2_BLOCKS_PER_GROUP(sb))
> > +		return 0;
> > +	return 1;
> > +}
> > +
> >  /*
> >   * Read the bitmap for a given block_group,and validate the
> >   * bits for block/inode/inode tables are set in the bitmaps
> > @@ -129,6 +140,24 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
> >  	desc = ext2_get_group_desc(sb, block_group, NULL);
> >  	if (!desc)
> >  		return NULL;
> > +	if (!ext2_block_in_group(sb, block_group,
> > +				le32_to_cpu(desc->bg_block_bitmap)) ||
> > +	    !ext2_block_in_group(sb, block_group,
> > +				le32_to_cpu(desc->bg_inode_bitmap)) ||
> > +	    !ext2_block_in_group(sb, block_group,
> > +				le32_to_cpu(desc->bg_inode_table)) ||
> > +	    !ext2_block_in_group(sb, block_group,
> > +				le32_to_cpu(desc->bg_inode_table) +
> > +				EXT2_SB(sb)->s_itb_per_group - 1)) {

Isn't equivalent checking done in ext2_check_descriptors()?  It would make
sense to abstract out the "check one group and return error" code and use
it in both places.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

