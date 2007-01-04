From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Thu, 04 Jan 2007 13:39:24 +0300
Message-ID: <m3zm8zdqjn.fsf@bzzz.home.net>
References: <20070102090909.GA20503@amitarora.in.ibm.com>
	<1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com>
	<20070103060601.GB5343@amitarora.in.ibm.com>
	<20070104085407.GC5345@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:57912 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932343AbXADKjh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jan 2007 05:39:37 -0500
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20070104085407.GC5345@amitarora.in.ibm.com> (Amit K. Arora's
	message of "Thu\, 4 Jan 2007 14\:24\:07 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Amit K Arora (AKA) writes:

 AKA> +int ext4_ext_check_overlap(struct inode *inode,
 AKA> +					struct ext4_extent *newext,
 AKA> +					unsigned long *block)
 AKA> +{
 AKA> +	struct ext4_ext_path *path;
 AKA> +	unsigned int depth, b1, len1;
 AKA> +	int ret = 0;
 AKA> +
 AKA> +	b1 = le32_to_cpu(newext->ee_block);
 AKA> +	len1 = le16_to_cpu(newext->ee_len);
 AKA> +	path = ext4_ext_find_extent(inode, b1, NULL);
 AKA> +	if (IS_ERR(path)) {
 AKA> +		ret = PTR_ERR(path);
 AKA> +		goto out;
 AKA> +	}
 AKA> +	depth = ext_depth(inode);
 AKA> +	BUG_ON(path[depth].p_ext == NULL && depth != 0);
 AKA> +
 AKA> +	*block = ext4_ext_next_allocated_block(path);
 AKA> +	if (*block == EXT_MAX_BLOCK)
 AKA> +		goto out;
 AKA> +
 AKA> +	if (b1 + len1 > *block)
 AKA> +		ret = 1;
 AKA> +out:
 AKA> +	return ret;
 AKA> +}

I'm also not sure we need ext4_ext_find_extent() here.
there are two possibilities:

1) extent in found path covers block(s) before requested ones
   then ext4_ext_next_allocated_block(path) can be used

2) extent in found path covers block(s) after request ones
   then ee_block from that extent can be used.

thanks, Alex

PS. if I remember the code right .. ;)
