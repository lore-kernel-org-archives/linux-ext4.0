From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [BUG] ext4 timestamps corruption
Date: Fri, 24 Jun 2011 16:46:44 -0600
Message-ID: <D77F5ECA-5803-44B7-B8AB-E18707386B42@dilger.ca>
References: <4DF1D57C.3030107@rs.jp.nec.com> <3BB3CFE7-BD50-4123-A1C8-D3FDAAD184DA@gmail.com> <4E02F0B8.4080301@rs.jp.nec.com> <BANLkTinxzNWZnMvj1716S24HJ6n2NM0z=w@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mark Harris <mhlk@osj.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57560 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab1FXWqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jun 2011 18:46:47 -0400
In-Reply-To: <BANLkTinxzNWZnMvj1716S24HJ6n2NM0z=w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-23, at 4:37 PM, Mark Harris wrote:
> 2011/6/23 Akira Fujita <a-fujita@rs.jp.nec.com>:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=23732
>> 
>> ext4: Fix ext4 timestamps corruption
>> 
>> Officially, ext4 can handle its timestamps until 2514
>> with 32bit entries plus EPOCH_BIT (2bits).
>> But when timestamps values use 32+ bit
>> (e.g. 2038-01-19 9:14:08 0x0000000080000000),
>> we can get corrupted values.
>> Because sign bit is overwritten by transferring value
>> between kernel space and user space.
>> 
>> To fix this issue, 32th bit of extra time fields in ext4_inode structure
>> (e.g. i_ctime_extra) are used as the sign for 64bit user space.
>> Because these are used only 20bits for nano-second and bottom of 2bits
>> are for EXT4_EPOCH_BITS shift.
>> With this patch, ext4 supports timestamps Y1901-2514.
> 
> Thanks for looking into this bug.  However tv_nsec is in the
> range 0..999999999 and requires 30 bits.  That is why tv_sec was
> only extended by 2 bits.  So there are no additional spare bits
> in the "extra" field.
> 
> 34-bit seconds can accommodate a maximum of 544.4 years, e.g.
> 1970..2514 or 1901..2446.  Although an early version of the patch
> for 34-bit tv_sec in ext4 worked with years 1970..2514, prior to
> being committed the patch was changed to support pre-1970
> timestamps (introducing the sign extension issue in the decoding):
>  http://marc.info/?l=linux-ext4&m=118208541320999

Sigh, it seems so unlikely that anyone even has a valid timestamp
on a file with a date before 1970, it makes me wonder if this extra
effort is even worthwhile...

> The existing encoding simply encodes bits 31..0 of tv_sec in the
> regular time field and bits 33..32 in the extra field (along with
> the 30-bit tv_nsec).  The issue is in the decoding, which I think
> can be addressed by changing only the body of the "if" in in the
> ext4_decode_extra_time function, to something like this:
> 
>        time->tv_sec += ((__u32)time->tv_sec +
>                ((__u64)le32_to_cpu(extra) << 32) +
>                0x80000000LL) & 0x300000000LL;
> 
> This is untested, and might look nicer with some macros, but
> it should decode the 34 bits into a timestamp in the range
> -0x80000000 (1901-12-13) to 0x37fffffff (2446-05-10), while
> retaining compatibility with the existing encoding.
> 
>   2    msb of                         adjustment needed to convert
> extra  32-bit                         sign-extended 32-bit tv_sec
>  bits   time   decoded 64-bit tv_sec   to decoded 64-bit tv_sec
>  1 1     1    -0x80000000..-1           0
>  0 0     0    0x000000000..0x07fffffff  0
>  0 0     1    0x080000000..0x0ffffffff  0x100000000
>  0 1     0    0x100000000..0x17fffffff  0x100000000
>  0 1     1    0x180000000..0x1ffffffff  0x200000000
>  1 0     0    0x200000000..0x27fffffff  0x200000000
>  1 0     1    0x280000000..0x2ffffffff  0x300000000
>  1 1     0    0x300000000..0x37fffffff  0x300000000

The problem with this encoding is that it requires existing 32-bit
timestamps before 1970 to have encoded "11" in the extra epoch bits,
which is not the case.  Current pre-1970 timestamps would be encoded
with "00" there, which would (according to your table) bump them past
2038 incorrectly.

What we need is an encoding that preserves the times for extra epoch "00":

  2    msb of                         adjustment needed to convert
extra  32-bit                         sign-extended 32-bit tv_sec
 bits   time   decoded 64-bit tv_sec   to decoded 64-bit tv_sec
 0 0     1    -0x80000000..-1           0
 0 0     0    0x000000000..0x07fffffff  0
 0 1     1    0x080000000..0x0ffffffff  0x100000000
 0 1     0    0x100000000..0x17fffffff  0x100000000
 1 0     1    0x180000000..0x1ffffffff  0x200000000
 1 0     0    0x200000000..0x27fffffff  0x200000000
 1 1     1    0x280000000..0x2ffffffff  0x300000000
 1 1     0    0x300000000..0x37fffffff  0x300000000

So, looking at the above desired encoding, it looks like the error in
the existing code is that it is doing a boolean operation on decode
instead of a mathematical one, and it was incorrectly trying to extend
the time to (1ULL<<34).  The below should fix this:

static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
{
	if (unlikely(sizeof(time->tv_sec) > 4 &&
		     (extra & cpu_to_le32(EXT4_EPOCH_MASK)))
		time->tv_sec += (u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK) << 32;

	time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
}

Cheers, Andreas





