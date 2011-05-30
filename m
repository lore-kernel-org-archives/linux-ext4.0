From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/2] ext4: use little-endian bitops directly
Date: Tue, 31 May 2011 01:21:10 +0900
Message-ID: <BANLkTimyCY9_tAOAtoxyNOw4=e+Y0pO_sw@mail.gmail.com>
References: <1306763382-13817-1-git-send-email-akinobu.mita@gmail.com>
	<09010AAD-7443-4966-BF20-8580FBE8F389@dilger.ca>
	<20110530154357.GF2890@dhcp-172-31-194-241.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andreas Dilger <a
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56335 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab1E3QVL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 May 2011 12:21:11 -0400
In-Reply-To: <20110530154357.GF2890@dhcp-172-31-194-241.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/5/31 Ted Ts'o <tytso@mit.edu>:
> On Mon, May 30, 2011 at 08:49:43AM -0600, Andreas Dilger wrote:
>> On 2011-05-30, at 7:49 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>> > s/ext4_set_bit/__test_and_set_bit_le/
>> > s/ext4_clear_bit/__test_and_clear_bit_le/
>> > s/ext4_test_bit/test_bit_le/
>> > s/ext4_find_first_zero_bit/find_first_zero_bit_le/
>> > s/ext4_find_next_zero_bit/find_next_zero_bit_le/
>> > s/ext4_find_next_bit/find_next_bit_le/
>>
>> I'm not souch in favor of making this change. One reason is the need
>> for inconsistent test_bit_le() vs __test_and_set_bit_le()
>> functions. I think this will make it more difficult to get the
>> correct bit operations (I for one do not know the difference between
>> the normal and __ versions without looking each time).
>
> More to the point, what's the benefit of making this change?

The main purpose is patch 2/2 that replaces __test_and_{set,clear}_bit_le()
with __{set,clear}_bit_le(). But there is no ext4_*_bit() macros for
__{set,clear}_bit_le(). So I convert to use *_bit_le() directly in this
patch instead of introducing another ext4_*_bit() macros.

I don't insist on removing these macros for this purpose against the
developper's will.  There is an alternative suggestion that changes
ext4_*_bit() macros like below.

#define ext4_test_and_set_bit	__test_and_set_bit_le
#define ext4_set_bit		__set_bit_le
#define ext4_set_bit_atomic	ext2_set_bit_atomic
#define ext4_test_and_clear_bit	__test_and_clear_bit_le
#define ext4_clear_bit		__clear_bit_le
#define ext4_clear_bit_atomic	ext2_clear_bit_atomic
#define ext4_test_bit		test_bit_le
#define ext4_find_first_zero_bit	find_first_zero_bit_le
#define ext4_find_next_zero_bit		find_next_zero_bit_le
#define ext4_find_next_bit		find_next_bit_le

By this chage, ext4_test_and_{set,clear}_bit are added and
ext4_{set,clear}_bit are changed.
