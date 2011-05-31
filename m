From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] ext4: use little-endian bitops directly
Date: Mon, 30 May 2011 22:56:48 -0600
Message-ID: <4B858003-053B-4895-BAD7-71861AAFB00E@dilger.ca>
References: <1306763382-13817-1-git-send-email-akinobu.mita@gmail.com> <09010AAD-7443-4966-BF20-8580FBE8F389@dilger.ca> <20110530154357.GF2890@dhcp-172-31-194-241.cam.corp.google.com> <BANLkTimyCY9_tAOAtoxyNOw4=e+Y0pO_sw@mail.gmail.com> <7B5337F4-B0D7-48E1-8D1B-3669B37AA1D5@dilger.ca> <BANLkTin64T9-QEdE6DC6VoB=7d6m0qFcuQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:54563 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1EaE4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 May 2011 00:56:49 -0400
In-Reply-To: <BANLkTin64T9-QEdE6DC6VoB=7d6m0qFcuQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-05-30, at 9:45 PM, Akinobu Mita wrote:
> 2011/5/31 Andreas Dilger <adilger@dilger.ca>:
>> I would also encourage you to finish off this patch series by pushing up the generic ext2_{set,clear}_bit_atomic() to the few places that are currently using ext2_{set,clear}_bit_atomic() directly (looks like only fs/nilfs2/alloc.h and include/linux/ext3.h) and then removing them from the arch headers.
> 
> The difficulty of doing this is that there are two different
> implementations of ext2_{set,clear}_bit_atomic (spin lock version and
> test_and_{set,clear}_bit_le version).  If we can switch to one of which
> on all architectures, the change is easy.  But I don't have less messy idea
> to keep current behavior on all architectures.

It looks like all of the versions that are #defined in arch/*/asm/bitops.h are really just re-implementations of test_and_{set,clear}_bit_le(), since they ignore the "lock" parameter entirely.

It would be sufficient to replace all of those implementations with:

#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
#include <asm-generic/bitops/ext2-atomic.h>

and then change the ext2-atomic.h to check for this:

#ifdef ARCH_NO_EXT2_ATOMIC_SPINLOCK
#define EXT2_SPIN_LOCK(lock)   do {} while(0)
#define EXT2_SPIN_UNLOCK(lock) do {} while(0)
#else
#define EXT2_SPIN_LOCK(lock)   spin_lock(lock)
#define EXT2_SPIN_UNLOCK(lock) spin_unlock(lock)
#endif

#define ext2_set_bit_atomic(lock, nr, addr)             \
       ({                                              \
               int ret;                                \
               EXT2_SPIN_LOCK(lock);                   \
               ret = __test_and_set_bit_le(nr, addr);  \
               EXT2_SPIN_UNLOCK(lock);                 \
               ret;                                    \
       })

#define ext2_clear_bit_atomic(lock, nr, addr)           \
       ({                                              \
               int ret;                                \
               EXT2_SPIN_LOCK(lock);                   \
               ret = __test_and_clear_bit_le(nr, addr);\
               EXT2_SPIN_UNLOCK(lock);                 \
               ret;                                    \
       })


Cheers, Andreas





