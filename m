From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 01/10] string: introduce memweight
Date: Mon, 4 Jun 2012 12:12:37 +0200
Message-ID: <20120604101237.GD7670@quack.suse.cz>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
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
	Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 02-06-12 22:40:07, Akinobu Mita wrote:
> memweight() is the function that counts the total number of bits set
> in memory area.  Unlike bitmap_weight(), memweight() takes pointer
> and size in bytes to specify a memory area which does not need to be
> aligned to long-word boundary.
> 
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
> Cc: Matthew Wilcox <matthew@wil.cx>
> ---
> 
> v2: simplify memweight(), adviced by Jan Kara
> 
>  include/linux/string.h |    3 +++
>  lib/string.c           |   32 ++++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+), 0 deletions(-)
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
> index e5878de..bf4d5a8 100644
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
> @@ -824,3 +825,34 @@ void *memchr_inv(const void *start, int c, size_t bytes)
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
> +	const unsigned char *bitmap = ptr;
> +
> +	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
> +			bytes--, bitmap++)
> +		w += hweight8(*bitmap);
> +
> +	longs = bytes / sizeof(long);
> +	if (longs) {
> +		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
> +		w += bitmap_weight((unsigned long *)bitmap,
> +				longs * BITS_PER_LONG);
> +		bytes -= longs * sizeof(long);
> +		bitmap += longs * sizeof(long);
> +	}
> +
> +	for (; bytes > 0; bytes--, bitmap++)
> +		w += hweight8(*bitmap);
  Looking at bitmap_weight() it seems this last loop is not needed. Just
pass to bitmap_weight() bytes*BITS_PER_BYTE. Also generally this function
doesn't seem necessary at all at least for ext2 & ext3 (sorry for not
noticing this earlier...).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
