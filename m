From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/10] string: introduce memweight
Date: Wed, 23 May 2012 11:21:13 +0200
Message-ID: <20120523092113.GG10452@quack.suse.cz>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Anders Larsen <al@alarsen.net>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2EWJVe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 May 2012 05:21:34 -0400
Content-Disposition: inline
In-Reply-To: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 20-05-12 22:23:14, Akinobu Mita wrote:
> memweight() is the function that counts the total number of bits set
> in memory area.  The memory area doesn't need to be aligned to
> long-word boundary unlike bitmap_weight().
  Thanks for the patch. I have some comments below.

> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Anders Larsen <al@alarsen.net>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-media@vger.kernel.org
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: ocfs2-devel@oss.oracle.com
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-ext4@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  include/linux/string.h |    3 +++
>  lib/string.c           |   37 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index e033564..ffe0442 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -145,4 +145,7 @@ static inline bool strstarts(const char *str, const char *prefix)
>  	return strncmp(str, prefix, strlen(prefix)) == 0;
>  }
>  #endif
> +
> +extern size_t memweight(const void *ptr, size_t bytes);
> +
>  #endif /* _LINUX_STRING_H_ */
> diff --git a/lib/string.c b/lib/string.c
> index e5878de..c8b92a0 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -26,6 +26,7 @@
>  #include <linux/export.h>
>  #include <linux/bug.h>
>  #include <linux/errno.h>
> +#include <linux/bitmap.h>
>  
>  #ifndef __HAVE_ARCH_STRNICMP
>  /**
> @@ -824,3 +825,39 @@ void *memchr_inv(const void *start, int c, size_t bytes)
>  	return check_bytes8(start, value, bytes % 8);
>  }
>  EXPORT_SYMBOL(memchr_inv);
> +
> +/**
> + * memweight - count the total number of bits set in memory area
> + * @ptr: pointer to the start of the area
> + * @bytes: the size of the area
> + */
> +size_t memweight(const void *ptr, size_t bytes)
> +{
> +	size_t w = 0;
> +	size_t longs;
> +	union {
> +		const void *ptr;
> +		const unsigned char *b;
> +		unsigned long address;
> +	} bitmap;
  Ugh, this is ugly and mostly unnecessary. Just use "const unsigned char
*bitmap".

> +
> +	for (bitmap.ptr = ptr; bytes > 0 && bitmap.address % sizeof(long);
> +			bytes--, bitmap.address++)
> +		w += hweight8(*bitmap.b);
  This can be:
	count = ((unsigned long)bitmap) % sizeof(long);
	while (count--) {
		w += hweight(*bitmap);
		bitmap++;
		bytes--;
	}
> +
> +	for (longs = bytes / sizeof(long); longs > 0; ) {
> +		size_t bits = min_t(size_t, INT_MAX & ~(BITS_PER_LONG - 1),
> +					longs * BITS_PER_LONG);
  I find it highly unlikely that someone would have such a large bitmap
(256 MB or more on 32-bit). Also the condition as you wrote it can just
overflow so it won't have the desired effect. Just do
	BUG_ON(longs >= ULONG_MAX / BITS_PER_LONG);
and remove the loop completely. If someone comes with such a huge bitmap,
the code can be modified easily (after really closely inspecting whether
such a huge bitmap is really well justified).

> +
> +		w += bitmap_weight(bitmap.ptr, bits);
> +		bytes -= bits / BITS_PER_BYTE;
> +		bitmap.address += bits / BITS_PER_BYTE;
> +		longs -= bits / BITS_PER_LONG;
> +	}
> +
> +	for (; bytes > 0; bytes--, bitmap.address++)
> +		w += hweight8(*bitmap.b);
> +
> +	return w;
> +}
> +EXPORT_SYMBOL(memweight);

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
