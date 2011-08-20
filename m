From: Andreas Dilger <adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org>
Subject: Re: [PATCH 3 2/4] Return 32/64-bit dir name hash according to usage type
Date: Sat, 20 Aug 2011 00:23:24 -0600
Message-ID: <8B32DE36-9AD0-4418-86D8-4E453AA910DB@whamcloud.com>
References: <20110816115404.1810393.47239.stgit@localhost.localdomain> <20110816115414.1810393.92169.stgit@localhost.localdomain> <20110819222951.GC3578@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org,
	hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110819222951.GC3578-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2011-08-19, at 4:29 PM, Ted Ts'o wrote:
> On Tue, Aug 16, 2011 at 01:54:14PM +0200, Bernd Schubert wrote:
>> +static inline int is_32bit_api(void)
>> +{
>> +#ifdef HAVE_IS_COMPAT_TASK
>> +	return is_compat_task();
>> +#else
>> +	return (BITS_PER_LONG == 32);
>> +#endif
> 
> I assume is_compat_task() is coming from another patch?  What is the
> status of that change?

No, is_compat_task() is upstream for most (all?) of the architectures
that support hybrid 32-/64-bit operation.  It is set at 32-bit syscall
entry when running on 64-bit architectures.

The only minor error in this patch (fixed with a new version from Bernd)
is that this should be under CONFIG_COMPAT instead of HAVE_IS_COMPAT_TASK.

> In the case where is_compat_task() is not defined, we can't just test
> based on BITS_PER_LONG == 32, since even on an x86_64 machine, it's
> possible we're running a 32-bit binary in compat mode....

It is definitely available on x86_64.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
