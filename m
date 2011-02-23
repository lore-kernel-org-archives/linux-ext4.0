From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4:Fix a bug in ext4_ext_fiemap_cb().
Date: Wed, 23 Feb 2011 16:35:22 -0700
Message-ID: <FDE557FB-8511-4CBB-A32D-2E5B82C71E4B@dilger.ca>
References: <1298476779-27883-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:41402 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1BWXfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 18:35:23 -0500
In-Reply-To: <1298476779-27883-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-23, at 8:59 AM, Yongqiang Yang wrote:
> @@ -3788,17 +3788,27 @@ static int ext4_ext_fiemap_cb(struct inode *inode,
> -	if (newex->ec_start == 0) {
> +	if (!newex->ec_start) {

(style) the original code is actually correct.  ec_start is not a boolean, so comparing it == 0 is actually the right thing to do.

> @@ -3807,8 +3817,13 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
> 		if (!bh)
> 			return EXT_CONTINUE;
> 
> +		/* Assume block-size equals page-size. */

This is not a valid assumption.

> 		if (buffer_delay(bh)) {
> 			flags |= FIEMAP_EXTENT_DELALLOC;
> +			if (page->index > offset) {
> +				logical =  ((__u64)page->index << PAGE_SHIFT);
> +				newex->ec_block = logical >> blksize_bits;
> +			}	

So, this assumes that the entire unmapped extent is described by the first page, but doesn't actually check whether all of the pages exist.  For the purpose of cp it might be OK, since at worst it means that cp will be reading from a hole in the source file.  However, I wonder if other applications will depend on the allocated extent being more accurate?

> +EXPORT_SYMBOL(find_get_pages);

Eric had also suggested pagevec_lookup_tag(), which is already exported.

Cheers, Andreas





