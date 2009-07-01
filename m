From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4_ext_calc_credits_for_single_extent() bug?
Date: Thu, 2 Jul 2009 00:08:54 +0530
Message-ID: <20090701183854.GC31235@skywalker>
References: <20090629224133.GF19362@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57740 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbZGASi7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2009 14:38:59 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id n61IbA9q002593
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jul 2009 04:37:10 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n61Id1VD557350
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jul 2009 04:39:01 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n61Id1Xp006355
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jul 2009 04:39:01 +1000
Content-Disposition: inline
In-Reply-To: <20090629224133.GF19362@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 30, 2009 at 12:41:33AM +0200, Andreas Dilger wrote:
> I was looking at the function ext4_ext_calc_credits_for_insert(), because
> it appeared similar to a function we were using in Lustre and I wanted to
> remove redundant code from our patches.  On closer inspection, however,
> that function is doing something strange that wasn't in our original code.
> 
> int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int nrblocks,
>                                                 struct ext4_ext_path *path)
> {
>         if (path) {
>                 int depth = ext_depth(inode);
>                 int ret = 0;
> 
>                 /* probably there is space in leaf? */
>                 if (le16_to_cpu(path[depth].p_hdr->eh_entries)
>                                 < le16_to_cpu(path[depth].p_hdr->eh_max)) {
> 
>                         /*
>                          *  There are some space in the leaf tree, no
>                          *  need to account for leaf block credit
>                          *
>                          *  bitmaps and block group descriptor blocks
>                          *  and other metadat blocks still need to be
>                          *  accounted.
>                          */
>                         /* 1 bitmap, 1 block group descriptor */
>                         ret = 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);
>                 }
>         }
> 
>         return ext4_chunk_trans_blocks(inode, nrblocks);
> }
> 
> It computes "ret" but doesn't actually use it, and then
> ext4_chunk_trans_blocks() does nothing but call ext4_meta_trans_blocks(),
> which is doing the bulk of the calculation.
> 
> It looks like this was committed by Mingming in "ext4: journal credits
> reservation fixes for extent file writepage"
> ee12b630687d510f6f4b6d4acdc4e267fd4adeda
> 
> Ideally we would use the "path" information to generate an accurate block
> count for this extent.  Can we just return "ret" in this case?
> 

I guess so a return ret is missing. If we have space in the leaf tree
then i guess we can safely add the extent information to the leaf and
update only bitmap and group descriptors.

-aneesh
