From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Thu, 4 Jan 2007 16:57:07 +0530
Message-ID: <20070104112707.GB15920@amitarora.in.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com> <1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com> <20070103060601.GB5343@amitarora.in.ibm.com> <20070104085407.GC5345@amitarora.in.ibm.com> <m3zm8zdqjn.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:50747 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964782AbXADL1N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jan 2007 06:27:13 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l04BRCHF020265
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 06:27:12 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l04BRC2h525100
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 04:27:12 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l04BRBPw006363
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 04:27:12 -0700
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m3zm8zdqjn.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 04, 2007 at 01:39:24PM +0300, Alex Tomas (AT) wrote:
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
>  AKA> +}
 
> AT> I'm also not sure we need ext4_ext_find_extent() here.
Do you mean ext4_ext_next_allocated_block() above ? We anyhow have to
call find_extent() to get the possible neighbouring extent.

> AT> there are two possibilities:
> 
> AT> 1) extent in found path covers block(s) before requested ones
> AT>    then ext4_ext_next_allocated_block(path) can be used
> 
> AT> 2) extent in found path covers block(s) after request ones
> AT>    then ee_block from that extent can be used.

You are right. In the case the requested block(s) lie within a hole, when
this hole starts from the begining of the file, this will be true. i.e.,
find_blocks() will return the extent after the requested block(s). In all
other cases, it will return the extent before the requested block(s)
(assuming there is no existing extent which covers the start of the
requested blocks).

Will change the code accordingly to handle this corner case. Thanks for
pointing this out !

--
Regards,
Amit Arora
