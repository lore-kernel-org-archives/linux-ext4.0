From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] Extent overlap bugfix in ext4
Date: Wed, 3 Jan 2007 11:36:01 +0530
Message-ID: <20070103060601.GB5343@amitarora.in.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com> <1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60229 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbXACGGH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jan 2007 01:06:07 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l036666O030346
	for <linux-ext4@vger.kernel.org>; Wed, 3 Jan 2007 01:06:06 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l03665Zt285130
	for <linux-ext4@vger.kernel.org>; Wed, 3 Jan 2007 01:06:06 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l03665hd012482
	for <linux-ext4@vger.kernel.org>; Wed, 3 Jan 2007 01:06:05 -0500
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 02, 2007 at 05:35:28PM -0800, Mingming Cao wrote:
> > +struct ext4_extent * ext4_ext_check_overlap(struct inode *inode,
> > +					struct ext4_extent *newext)
> > +{
> > +	struct ext4_ext_path *path;
> > +	struct ext4_extent *ex;
> > +	unsigned int depth, b1, b2, len1;
> > +
> > +	b1 = le32_to_cpu(newext->ee_block);
> > +	len1 = le16_to_cpu(newext->ee_len);
> > +	path = ext4_ext_find_extent(inode, b1, NULL);
> > +	if (IS_ERR(path))
> > +		return NULL;
> > +
> > +	depth = ext_depth(inode);
> > +	ex = path[depth].p_ext;
> > +	if (!ex)
> > +		return NULL;
> > +
> 
> I am confused, when we come here, isn't we confirmed that we need block
> allocation, thus there is no extent start from b1?

Yes, we are sure here that there is no extent which covers b1 block.
Since I couldn't find a direct way to get the next extent (extent on the
right from the "would be" position of the new extent in the tree), we
make a call to ext4_ext_find_extent() to get the extent on the left, and
then use this to call ext4_ext_next_allocated_block() to get the logical
block number (LBN) of the "next" extent in the tree. This LBN is
compared with the LBN of the new extent plus its length, to detect an
overlap.

> 
> > +	b2 = ext4_ext_next_allocated_block(path);
> > +	if (b2 == EXT_MAX_BLOCK)
> > +
> > 		return NULL;
> > +	path = ext4_ext_find_extent(inode, b2, path);
> > +	if (IS_ERR(path))
> > +		return NULL;
> > +	BUG_ON(path[depth].p_hdr == NULL);
> > +	ex = path[depth].p_ext;
> > +
> 
> How useful to have the next extent pointer?It seems only used to print
> out warning messages. I am a little concerned about the expensive
> ext4_ext_find_extent(). After all ext4_ext_next_allocated_block()
> already returns the start block of next extent, isn't it?

Ok, agreed. Will get rid of this extra code.


--
Regards,
Amit Arora
