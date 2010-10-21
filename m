From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 20/22] bitops: remove ext2 non-atomic bitops from asm/bitops.h
Date: Thu, 21 Oct 2010 11:52:15 -0600
Message-ID: <AECEA79F-28E8-49B0-8C13-2CF115A6ECB4@dilger.ca>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com> <1287672077-5797-21-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:15727 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab0JURwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Oct 2010 13:52:19 -0400
In-Reply-To: <1287672077-5797-21-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-21, at 08:41, Akinobu Mita wrote:
> As the result of conversions, there are no users of ext2 non-atomic bit
> operations except for ext2 file system itself.  Now we can put them
> into architecture independent code in ext2 file system, and remove
> from asm/bitops.h for all architectures.

Presumably there will be a separate patch series to remove the atomic ext2 bitops?  I was going to suggest removing the ext2 comment in bitops.h, but I notice that there are still the atomic bitops left.

In any case, thanks for your efforts.  I agree that these ext2_* functions have no place in the generic code, and are only there for historical reasons.

> --- a/arch/arm/include/asm/bitops.h
> +++ b/arch/arm/include/asm/bitops.h
> @@ -327,22 +327,10 @@ static inline int fls(int x)
> * Ext2 is defined to use little-endian byte ordering.
> * These do not need to be atomic.
> */
> -#define ext2_set_bit(nr,p)			\
> -		__test_and_set_le_bit(nr, (unsigned long *)(p))
> #define ext2_set_bit_atomic(lock,nr,p)          \
> 		test_and_set_le_bit(nr, (unsigned long *)(p))
> -#define ext2_clear_bit(nr,p)			\
> -		__test_and_clear_le_bit(nr, (unsigned long *)(p))
> #define ext2_clear_bit_atomic(lock,nr,p)        \
> 		test_and_clear_le_bit(nr, (unsigned long *)(p))
> -#define ext2_test_bit(nr,p)			\
> -		test_le_bit(nr, (unsigned long *)(p))
> -#define ext2_find_first_zero_bit(p,sz)		\
> -		find_first_zero_le_bit((unsigned long *)(p), sz)
> -#define ext2_find_next_zero_bit(p,sz,off)	\
> -		find_next_zero_le_bit((unsigned long *)(p), sz, off)
> -#define ext2_find_next_bit(p, sz, off) \
> -		find_next_le_bit((unsigned long *)(p), sz, off)


Cheers, Andreas





