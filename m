From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Fri, 5 Jan 2007 11:48:02 +0530
Message-ID: <20070105061802.GA25583@amitarora.in.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com> <1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com> <20070103060601.GB5343@amitarora.in.ibm.com> <20070104085407.GC5345@amitarora.in.ibm.com> <m3zm8zdqjn.fsf@bzzz.home.net> <20070104112707.GB15920@amitarora.in.ibm.com> <m3r6ubdnuj.fsf@bzzz.home.net> <20070104172329.GA23612@amitarora.in.ibm.com> <m3irfmehra.fsf@bzzz.home.net> <459D59D8.5040308@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49366 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030350AbXAEGSI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jan 2007 01:18:08 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l056I6ml028210
	for <linux-ext4@vger.kernel.org>; Fri, 5 Jan 2007 01:18:06 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l056I6vZ264166
	for <linux-ext4@vger.kernel.org>; Fri, 5 Jan 2007 01:18:06 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l056I5Sr004496
	for <linux-ext4@vger.kernel.org>; Fri, 5 Jan 2007 01:18:06 -0500
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <459D59D8.5040308@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 04, 2007 at 11:47:36AM -0800, Mingming Cao (MC) wrote:
> Alex Tomas (AT) wrote:
> 
> >>>>>>Amit K Arora (AKA) writes:
> >
> >
> > > AKA> @@ -1984,6 +2034,10 @@ int ext4_ext_get_blocks(handle_t *handle
> > > AKA>  		 */
> > > AKA>  		if (ee_len > EXT_MAX_LEN)
> > > AKA>  			goto out2;
> > > AKA> +
> > > AKA> +		if (iblock < ee_block && iblock + max_blocks >= 
> > > ee_block)
> > > AKA> +			allocated = ee_block - iblock;
> > > AKA> +
> > > AKA>  		/* if found extent covers block, simply return it */
> > > AKA>  	        if (iblock >= ee_block && iblock < ee_block + 
> > > ee_len) {
> > > AKA>  			newblock = iblock - ee_block + ee_start;
> > >
> > AT> I thought existing code already does this:
> >
> > AT>   /* if found extent covers block, simply return it */
> > AT>   if (iblock >= ee_block && iblock < ee_block + ee_len) {
> > AT>	      newblock = iblock - ee_block + ee_start;
> > AT>	      /* number of remaining blocks in the extent */
> > AT>	      allocated = ee_len - (iblock - ee_block);
> MC> That's different: the existing code address the case when the left part
> MC> of the new extent  overlaps with an exisitng extent, in that case I
> MC> understand it just returns the allocated part of extent, and continue
> MC> the block allocation in the next call of get_blocks().
Right.
 
> MC> Well Amit's new code here trying to address the case when the right part
> MC> of the new extent overlap with an exisitng extent. He was trying to
> MC> update the new extent length to prevent that. As I mentioned ealier we
> MC> could put this code into ext4_ext_check_overlap,let it judge whether
> MC> there is overlap, and if so, what's the right start block number and length
Yes, this check will no longer be required with the modified
ext4_ext_check_overlap, which will check for this condition as well.

--
Regards,
Amit Arora
> 
> Thanks,
> Mingming
