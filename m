From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/2] ext4: use little-endian bitops directly
Date: Tue, 31 May 2011 18:43:44 +0900
Message-ID: <BANLkTimnB5okiG_M9zhUG6F22PHPoAsZLw@mail.gmail.com>
References: <1306763382-13817-1-git-send-email-akinobu.mita@gmail.com>
	<09010AAD-7443-4966-BF20-8580FBE8F389@dilger.ca>
	<20110530154357.GF2890@dhcp-172-31-194-241.cam.corp.google.com>
	<BANLkTimyCY9_tAOAtoxyNOw4=e+Y0pO_sw@mail.gmail.com>
	<7B5337F4-B0D7-48E1-8D1B-3669B37AA1D5@dilger.ca>
	<BANLkTin64T9-QEdE6DC6VoB=7d6m0qFcuQ@mail.gmail.com>
	<4B858003-053B-4895-BAD7-71861AAFB00E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38009 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1EaJnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 May 2011 05:43:45 -0400
In-Reply-To: <4B858003-053B-4895-BAD7-71861AAFB00E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/5/31 Andreas Dilger <adilger@dilger.ca>:
> On 2011-05-30, at 9:45 PM, Akinobu Mita wrote:
>> 2011/5/31 Andreas Dilger <adilger@dilger.ca>:
>>> I would also encourage you to finish off this patch series by pushi=
ng up the generic ext2_{set,clear}_bit_atomic() to the few places that =
are currently using ext2_{set,clear}_bit_atomic() directly (looks like =
only fs/nilfs2/alloc.h and include/linux/ext3.h) and then removing them=
 from the arch headers.
>>
>> The difficulty of doing this is that there are two different
>> implementations of ext2_{set,clear}_bit_atomic (spin lock version an=
d
>> test_and_{set,clear}_bit_le version). =A0If we can switch to one of =
which
>> on all architectures, the change is easy. =A0But I don't have less m=
essy idea
>> to keep current behavior on all architectures.
>
> It looks like all of the versions that are #defined in arch/*/asm/bit=
ops.h are really just re-implementations of test_and_{set,clear}_bit_le=
(), since they ignore the "lock" parameter entirely.
>
> It would be sufficient to replace all of those implementations with:
>
> #define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> #include <asm-generic/bitops/ext2-atomic.h>
>
> and then change the ext2-atomic.h to check for this:
>
> #ifdef ARCH_NO_EXT2_ATOMIC_SPINLOCK
> #define EXT2_SPIN_LOCK(lock) =A0 do {} while(0)
> #define EXT2_SPIN_UNLOCK(lock) do {} while(0)
> #else
> #define EXT2_SPIN_LOCK(lock) =A0 spin_lock(lock)
> #define EXT2_SPIN_UNLOCK(lock) spin_unlock(lock)
> #endif
>
> #define ext2_set_bit_atomic(lock, nr, addr) =A0 =A0 =A0 =A0 =A0 =A0 \
> =A0 =A0 =A0 ({ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT2_SPIN_LOCK(lock); =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __test_and_set_bit_le(nr, addr); =
=A0\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT2_SPIN_UNLOCK(lock); =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 })

This is not equivalent change if ARCH_NO_EXT2_ATOMIC_SPINLOCK is define=
d
because ext2_set_bit_atomic for the majority of architectures is

#define ext2_set_bit_atomic(lock, nr, addr) \
        test_and_set_bit_le((nr), (unsigned long*)addr)

So ext2-atomic.h could be:

#ifdef ARCH_NO_EXT2_ATOMIC_SPINLOCK

#define ext2_set_bit_atomic(l, nr, addr)	test_and_set_bit_le(nr, addr)
#define ext2_clear_bit_atomic(l, nr, addr)	test_and_clear_bit_le(nr, ad=
dr)

#else

#define ext2_set_bit_atomic(lock, nr, addr)		\
	({						\
		int ret;				\
		spin_lock(lock);			\
		ret =3D __test_and_set_bit_le(nr, addr);	\
		spin_unlock(lock);			\
		ret;					\
	})

#define ext2_clear_bit_atomic(lock, nr, addr)		\
	({						\
		int ret;				\
		spin_lock(lock);			\
		ret =3D __test_and_clear_bit_le(nr, addr);	\
		spin_unlock(lock);			\
		ret;					\
	})

#endif
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
