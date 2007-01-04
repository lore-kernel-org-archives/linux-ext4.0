From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Thu, 4 Jan 2007 16:46:16 +0530
Message-ID: <20070104111616.GA15920@amitarora.in.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com> <1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com> <20070103060601.GB5343@amitarora.in.ibm.com> <20070104085407.GC5345@amitarora.in.ibm.com> <m3d55vf5r4.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:49084 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778AbXADLQX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jan 2007 06:16:23 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l04BGL04010124
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 06:16:21 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l04BGKX3402392
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 04:16:20 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l04BGKKJ018518
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 04:16:20 -0700
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m3d55vf5r4.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 04, 2007 at 01:25:35PM +0300, Alex Tomas wrote:
> >>>>> Amit K Arora (AKA) writes:
> 
>  AKA> +int ext4_ext_check_overlap(struct inode *inode,
>  AKA> +					struct ext4_extent *newext,
>  AKA> +					unsigned long *block)
>  AKA> +{
>  AKA> +	struct ext4_ext_path *path;
>  AKA> +	unsigned int depth, b1, len1;
>  AKA> +	int ret = 0;
>  AKA> +
>  AKA> +	b1 = le32_to_cpu(newext->ee_block);
>  AKA> +	len1 = le16_to_cpu(newext->ee_len);
>  AKA> +	path = ext4_ext_find_extent(inode, b1, NULL);
>  AKA> +	if (IS_ERR(path)) {
>  AKA> +		ret = PTR_ERR(path);
>  AKA> +		goto out;
>  AKA> +	}
>  AKA> +	depth = ext_depth(inode);
>  AKA> +	BUG_ON(path[depth].p_ext == NULL && depth != 0);
>  AKA> +
>  AKA> +	*block = ext4_ext_next_allocated_block(path);
>  AKA> +	if (*block == EXT_MAX_BLOCK)
>  AKA> +		goto out;
>  AKA> +
>  AKA> +	if (b1 + len1 > *block)
>  AKA> +		ret = 1;
>  AKA> +out:
>  AKA> +	return ret;
> 
> <AT> ext4_ext_find_extent() allocates 'path', I'd expect
> <AT> kfree() in the function.

Ok. I will add following after "out:" 
	if (path) {
		ext4_ext_drop_refs(path);
		kfree(path);
	}

And also set "path = NULL;" before calling "goto out", incase
ext4_ext_find_extent() returns an error.

--
Regards,
Amit Arora
