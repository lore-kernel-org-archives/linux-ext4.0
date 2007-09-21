From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Introduce ext4_find_next_bit
Date: Fri, 21 Sep 2007 12:13:13 +0530
Message-ID: <46F36801.3070908@linux.vnet.ibm.com>
References: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:38301 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbXIUGpQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 02:45:16 -0400
In-Reply-To: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:
> Also add generic_find_next_le_bit
> 
> This gets used by the ext4 multi block allocator patches.
> 

Looks like it's a straight forward on Little Endian Architectures.
I see something for powerpc, what about other architectures?

> 
> +unsigned long generic_find_next_le_bit(const unsigned long *addr, unsigned
> +		long size, unsigned long offset)
> +{

Docbook style comments on the function and arguments would be nice.

> +	const unsigned long *p = addr + BITOP_WORD(offset);
> +	unsigned long result = offset & ~(BITS_PER_LONG - 1);
> +	unsigned long tmp;
> +
> +	if (offset >= size)
> +		return size;
> +	size -= result;
> +	offset &= (BITS_PER_LONG - 1UL);
> +	if (offset) {
> +		tmp = ext2_swabp(p++);
> +		tmp &= (~0UL << offset);
> +		if (size < BITS_PER_LONG)
> +			goto found_first;
> +		if (tmp)
> +			goto found_middle;
> +		size -= BITS_PER_LONG;
> +		result += BITS_PER_LONG;
> +	}
> +
> +	while (size & ~(BITS_PER_LONG - 1)) {
> +		tmp = *(p++);
> +		if (tmp)
> +			goto found_middle_swap;
> +		result += BITS_PER_LONG;
> +		size -= BITS_PER_LONG;
> +	}
> +	if (!size)
> +		return result;
> +	tmp = ext2_swabp(p);
> +found_first:
> +	tmp &= (~0UL >> (BITS_PER_LONG - size));
> +	if (tmp == 0UL)		/* Are any bits set? */
> +		return result + size; /* Nope. */
> +found_middle:
> +	return result + __ffs(tmp);
> +
> +found_middle_swap:
> +	return result + __ffs(ext2_swab(tmp));
> +}
> +EXPORT_SYMBOL(generic_find_next_le_bit);
> +
>  #endif /* __BIG_ENDIAN */


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
