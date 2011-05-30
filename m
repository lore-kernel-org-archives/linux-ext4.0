From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] ext4: use little-endian bitops directly
Date: Mon, 30 May 2011 11:58:32 -0600
Message-ID: <7B5337F4-B0D7-48E1-8D1B-3669B37AA1D5@dilger.ca>
References: <1306763382-13817-1-git-send-email-akinobu.mita@gmail.com> <09010AAD-7443-4966-BF20-8580FBE8F389@dilger.ca> <20110530154357.GF2890@dhcp-172-31-194-241.cam.corp.google.com> <BANLkTimyCY9_tAOAtoxyNOw4=e+Y0pO_sw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:42147 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1E3R6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 May 2011 13:58:34 -0400
In-Reply-To: <BANLkTimyCY9_tAOAtoxyNOw4=e+Y0pO_sw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-05-30, at 10:21 AM, Akinobu Mita wrote:
> 2011/5/31 Ted Ts'o <tytso@mit.edu>:
>> On Mon, May 30, 2011 at 08:49:43AM -0600, Andreas Dilger wrote:
>>> On 2011-05-30, at 7:49 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>>>> s/ext4_set_bit/__test_and_set_bit_le/
>>>> s/ext4_clear_bit/__test_and_clear_bit_le/
>>>> s/ext4_test_bit/test_bit_le/
>>>> s/ext4_find_first_zero_bit/find_first_zero_bit_le/
>>>> s/ext4_find_next_zero_bit/find_next_zero_bit_le/
>>>> s/ext4_find_next_bit/find_next_bit_le/
>>> 
>>> I'm not souch in favor of making this change. One reason is the need
>>> for inconsistent test_bit_le() vs __test_and_set_bit_le()
>>> functions. I think this will make it more difficult to get the
>>> correct bit operations (I for one do not know the difference between
>>> the normal and __ versions without looking each time).
>> 
>> More to the point, what's the benefit of making this change?
> 
> The main purpose is patch 2/2 that replaces __test_and_{set,clear}_bit_le()
> with __{set,clear}_bit_le(). But there is no ext4_*_bit() macros for
> __{set,clear}_bit_le(). So I convert to use *_bit_le() directly in this
> patch instead of introducing another ext4_*_bit() macros.
> 
> I don't insist on removing these macros for this purpose against the
> developper's will.  There is an alternative suggestion that changes
> ext4_*_bit() macros like below.
> 
> #define ext4_test_and_set_bit	__test_and_set_bit_le
> #define ext4_set_bit		__set_bit_le
> #define ext4_set_bit_atomic	ext2_set_bit_atomic
> #define ext4_test_and_clear_bit	__test_and_clear_bit_le
> #define ext4_clear_bit		__clear_bit_le
> #define ext4_clear_bit_atomic	ext2_clear_bit_atomic
> #define ext4_test_bit		test_bit_le
> #define ext4_find_first_zero_bit	find_first_zero_bit_le
> #define ext4_find_next_zero_bit		find_next_zero_bit_le
> #define ext4_find_next_bit		find_next_bit_le
> 
> By this chage, ext4_test_and_{set,clear}_bit are added and
> ext4_{set,clear}_bit are changed.

I think this second option is a far preferable solution.

Looking more closely at these operations, ext4_set_bit_atomic() is not used anywhere in the code and could be removed.

There is only one place where ext4_clear_bit_atomic() is used (ext4_add_groupblocks()), and this is likely incorrect.  None of the other ext4 code is using ext4_set_bit_atomic(), and all of the ext2_clear_bit_atomic() macros are silently ignoring the "lock" argument, so these changes are done without ext4_group_lock() being held for that group.  I suspect this is never a problem in normal usage because ext4_add_groupblocks() is only used during filesystem resizing, which is rare, and doubly rare for any allocations to be made in the same group concurrently.

This one usage of ext4_clear_bit_atomic() should just be moved inside the ext4_lock_group() a few lines down and then use ext4_clear_bit() for consistency, and ext4_clear_bit_atomic() can be removed entirely.

A further cleanup would be to change this whole function to use mb_clear_bits(), which is not only faster because it operates on many bits at once, but also doesn't require that the buddy bitmap be marked invalid ("NEED_INIT") after these changes are made, but that is work for a separate patch.

I would also encourage you to finish off this patch series by pushing up the generic ext2_{set,clear}_bit_atomic() to the few places that are currently using ext2_{set,clear}_bit_atomic() directly (looks like only fs/nilfs2/alloc.h and include/linux/ext3.h) and then removing them from the arch headers.

Cheers, Andreas





