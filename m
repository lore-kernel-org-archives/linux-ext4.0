From: Mark Harris <mhlk@osj.us>
Subject: Re: [BUG] ext4 timestamps corruption
Date: Thu, 23 Jun 2011 15:37:11 -0700
Message-ID: <BANLkTinxzNWZnMvj1716S24HJ6n2NM0z=w@mail.gmail.com>
References: <4DF1D57C.3030107@rs.jp.nec.com>
	<3BB3CFE7-BD50-4123-A1C8-D3FDAAD184DA@gmail.com>
	<4E02F0B8.4080301@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51436 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab1FWWhM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 18:37:12 -0400
Received: by iyb12 with SMTP id 12so1923613iyb.19
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jun 2011 15:37:12 -0700 (PDT)
In-Reply-To: <4E02F0B8.4080301@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/6/23 Akira Fujita <a-fujita@rs.jp.nec.com>:
>> https://bugzilla.kernel.org/show_bug.cgi?id=23732
>
> ext4: Fix ext4 timestamps corruption
>
> Officially, ext4 can handle its timestamps until 2514
> with 32bit entries plus EPOCH_BIT (2bits).
> But when timestamps values use 32+ bit
> (e.g. 2038-01-19 9:14:08 0x0000000080000000),
> we can get corrupted values.
> Because sign bit is overwritten by transferring value
> between kernel space and user space.
>
> To fix this issue, 32th bit of extra time fields in ext4_inode structure
> (e.g. i_ctime_extra) are used as the sign for 64bit user space.
> Because these are used only 20bits for nano-second and bottom of 2bits
> are for EXT4_EPOCH_BITS shift.
> With this patch, ext4 supports timestamps Y1901-2514.

Thanks for looking into this bug.  However tv_nsec is in the
range 0..999999999 and requires 30 bits.  That is why tv_sec was
only extended by 2 bits.  So there are no additional spare bits
in the "extra" field.

34-bit seconds can accommodate a maximum of 544.4 years, e.g.
1970..2514 or 1901..2446.  Although an early version of the patch
for 34-bit tv_sec in ext4 worked with years 1970..2514, prior to
being committed the patch was changed to support pre-1970
timestamps (introducing the sign extension issue in the decoding):
  http://marc.info/?l=linux-ext4&m=118208541320999

The existing encoding simply encodes bits 31..0 of tv_sec in the
regular time field and bits 33..32 in the extra field (along with
the 30-bit tv_nsec).  The issue is in the decoding, which I think
can be addressed by changing only the body of the "if" in in the
ext4_decode_extra_time function, to something like this:

        time->tv_sec += ((__u32)time->tv_sec +
                ((__u64)le32_to_cpu(extra) << 32) +
                0x80000000LL) & 0x300000000LL;

This is untested, and might look nicer with some macros, but
it should decode the 34 bits into a timestamp in the range
-0x80000000 (1901-12-13) to 0x37fffffff (2446-05-10), while
retaining compatibility with the existing encoding.

   2    msb of                         adjustment needed to convert
 extra  32-bit                         sign-extended 32-bit tv_sec
  bits   time   decoded 64-bit tv_sec   to decoded 64-bit tv_sec
  1 1     1    -0x80000000..-1           0
  0 0     0    0x000000000..0x07fffffff  0
  0 0     1    0x080000000..0x0ffffffff  0x100000000
  0 1     0    0x100000000..0x17fffffff  0x100000000
  0 1     1    0x180000000..0x1ffffffff  0x200000000
  1 0     0    0x200000000..0x27fffffff  0x200000000
  1 0     1    0x280000000..0x2ffffffff  0x300000000
  1 1     0    0x300000000..0x37fffffff  0x300000000

 - Mark
