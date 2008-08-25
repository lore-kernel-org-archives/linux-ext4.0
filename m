From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Large EAs in ext4
Date: Mon, 25 Aug 2008 16:47:36 -0600
Message-ID: <20080825224736.GZ3392@webber.adilger.int>
References: <1219680023.31999.30.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Kalpak Shah <Kalpak.Shah@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53498 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYHYWri (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2008 18:47:38 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7PMlcqB017939
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 15:47:38 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6600701HU61200@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 25 Aug 2008 15:47:38 -0700 (PDT)
Received: from webber.adilger.int ([68.147.167.155])
 by fe-sfbay-09.sun.com (Sun Java System Messaging Server 6.2-8.04 (built Feb
 28 2007)) with ESMTPSA id <0K66001IAHZCQWG0@fe-sfbay-09.sun.com> for
 linux-ext4@vger.kernel.org; Mon, 25 Aug 2008 15:47:38 -0700 (PDT)
In-reply-to: <1219680023.31999.30.camel@localhost>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 25, 2008  21:30 +0530, Kalpak Shah wrote:
> This is the implementation for large EA support in ext4. Note that this
> also helps to have a larger number of EAs since large EAs get written
> out to a new inode instead of the EA block.
> 
> If value of an attribute is greater than 2048 bytes the value is not
> saved in the external EA block, instead it is saved in an inode.

I just realized that this needs to be (blocksize / 2) instead of 2048,
or we will never get the EA inodes in case of 1kB/2kB block filesystem
where we need it the most.

> +struct  inode *ext4_xattr_inode_iget(struct inode *parent, int ea_ino, int *err)
         ^^ extra space here

> +	if (ea_inode->i_mtime.tv_sec != parent->i_ino ||

Do you think it makes sense to "#define i_xattr_inode_parent i_mtime.tv_sec"
in case there is a decision to change which field is used?  Or do people
think that is more confusing than helpful?

Note to readers that this is a new patch, and Lustre doesn't use it yet,
but we'd like to in the relatively near future so feedback that affects
the on disk format is preferred sooner than later.

> +ext4_xattr_inode_set(handle_t *handle, struct inode *inode, int *ea_ino,
> +		     const void *value, size_t value_len)
> +{
> +	/*
> +	 * Make sure that enough buffer credits are available else extend the
> +	 * transaction.
> +	 */
> +	req_buffer_credits = (value_len / inode->i_sb->s_blocksize) + 4;

Can you please explain in the comment what the "+ 4" blocks are?
I suspect this will not be enough if the xattr is large, it should just
use one of the standard "transaction size" helper functions to determine
metadata size.

>  static int
> -ext4_xattr_set_entry(struct ext4_xattr_info *i, struct ext4_xattr_search *s)
> +ext4_xattr_set_entry(struct ext4_xattr_info *i, struct ext4_xattr_search *s,
> +		     handle_t *handle, struct inode *inode)
>  {
> +		if (s->here->e_value_inum) {
> +			ext4_xattr_inode_unlink(inode, s->here->e_value_inum);
> +			s->here->e_value_inum = 0;
> +		}

The transaction not have enough blocks reserved to do the unlink and
truncate of the old EA inode.  It isn't really possible to know this
before having done the xattr header lookup, so it is difficult to compute
the transaction size without doing the lookup first.  As an alternative,
it would be possible to only add this inode to the orphan list and do
the iput() after the handle is done, in a separate transaction maybe.

Also, what will happen with this inode?  Will it be allocated again
for the ext4_xattr_inode_set() below, or will changing a large EA in
the same transaction cause the freed inode to be busy until after the
transaction commit and a new inode found for the new EA?  That would
be sub-optimal, since rapid EA changing will mark a bunch of inodes
busy.  Another option is to just overwrite the old inode, trusting
that the journal will keep the update atomic (enough blocks for the
overwrite were reserved at the start).

> +#define EXT4_EA_INODE_FL		0x00200000 /* Inode used for large EA */
>  #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
>  
>  #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */

Is there any reason not to make this flag visible?
Did you also verify that it does not clash with the "generic" flags?

> @@ -514,6 +518,42 @@ struct inode *ext4_new_inode(handle_t *h
> +	if (goal) {
> +		if (ext4_set_bit_atomic(sb_bgl_lock(sbi, group),
> +					ino, bitmap_bh->b_data)) {
> +			goto continue_allocation;
> +		}

This should probably set the goal to the first inode in the current
inode table block, if the goal is not found.  That will possibly help
avoid another block read if there is a free inode in the same block
(e.g. if xattr inode is being allocated long after initial inode and
maybe another inode was freed in the same block.

The patch is good enough to go into the unstable part of the patch
queue I think, though it can have a few tweaks still.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

