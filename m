From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Thu, 04 Jan 2007 11:47:36 -0800
Message-ID: <459D59D8.5040308@us.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com>	<1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com>	<20070103060601.GB5343@amitarora.in.ibm.com>	<20070104085407.GC5345@amitarora.in.ibm.com> <m3zm8zdqjn.fsf@bzzz.home.net>	<20070104112707.GB15920@amitarora.in.ibm.com> <m3r6ubdnuj.fsf@bzzz.home.net>	<20070104172329.GA23612@amitarora.in.ibm.com> <m3irfmehra.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:44583 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030184AbXADTrk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jan 2007 14:47:40 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l04Jldw3002876
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 14:47:39 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l04Jlcjc537252
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 12:47:39 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l04Jlcnc018480
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 12:47:38 -0700
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3irfmehra.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:

>>>>>>Amit K Arora (AKA) writes:
> 
> 
>  AKA> @@ -1984,6 +2034,10 @@ int ext4_ext_get_blocks(handle_t *handle
>  AKA>  		 */
>  AKA>  		if (ee_len > EXT_MAX_LEN)
>  AKA>  			goto out2;
>  AKA> +
>  AKA> +		if (iblock < ee_block && iblock + max_blocks >= ee_block)
>  AKA> +			allocated = ee_block - iblock;
>  AKA> +
>  AKA>  		/* if found extent covers block, simply return it */
>  AKA>  	        if (iblock >= ee_block && iblock < ee_block + ee_len) {
>  AKA>  			newblock = iblock - ee_block + ee_start;
> 
> I thought existing code already does this:
> 
> 	/* if found extent covers block, simply return it */
>         if (iblock >= ee_block && iblock < ee_block + ee_len) {
> 		newblock = iblock - ee_block + ee_start;
> 		/* number of remaining blocks in the extent */
> 		allocated = ee_len - (iblock - ee_block);
> 
> 
> thanks, Alex
That's different: the existing code address the case when the left part 
of the new extent  overlaps with an exisitng extent, in that case I 
understand it just returns the allocated part of extent, and continue 
the block allocation in the next call of get_blocks().

Well Amit's new code here trying to address the case when the right part 
of the new extent overlap with an exisitng extent. He was trying to 
update the new extent length to prevent that. As I mentioned ealier we 
could put this code into ext4_ext_check_overlap,let it judge whether 
there is overlap, and if so, what's the right start block number and length

Thanks,
Mingming
