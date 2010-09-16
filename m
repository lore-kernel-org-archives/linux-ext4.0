From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
Date: 16 Sep 2010 08:13:09 -0400
Message-ID: <20100916121309.8926.qmail@science.horizon.com>
Cc: linux@horizon.com, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: andi@firstfloor.org, miaox@cn.fujitsu.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>  void *memmove(void *dest, const void *src, size_t count)
>  {
>  	if (dest < src) {
>  		return memcpy(dest, src, count);
>  	} else {
> -		char *p = dest + count;
> -		const char *s = src + count;
> -		while (count--)
> -			*--p = *--s;
> +		return memcpy_backwards(dest, src, count);
>  	}
>  	return dest;
>  }

Er... presumably, the forward-copy case is somewhat better optimized,
so should be preferred if the areas don't overlap; that is, dest >
src by more than the sount.  Assuming that size_t can hold a pointer:

	if ((size_t)src - (size_t)dest >= count)
		return memcpy(dest, src, count);
	else
		return memcpy_backwards(dest, src, count);

Or, using GCC's arithmetic on void * extension,
	if ((size_t)(src - dest) >= count)
		... etc.

If src == dest, it doesn't matter which you use.  You could skip the
copy entirely, but presumably that case doesn't arise often enough to
be worth testing for:

	if ((size_t)(src - dest) >= count)
		return memcpy(dest, src, count);
	else if (src - dest != 0)
		return memcpy_backwards(dest, src, count);
	else
		return dest;
