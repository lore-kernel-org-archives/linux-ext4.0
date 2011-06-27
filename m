From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [BUG] ext4 timestamps corruption
Date: Mon, 27 Jun 2011 03:04:05 -0600
Message-ID: <86641D0C-ADC7-48B4-8AA6-F62929F71528@dilger.ca>
References: <4DF1D57C.3030107@rs.jp.nec.com> <3BB3CFE7-BD50-4123-A1C8-D3FDAAD184DA@gmail.com> <4E02F0B8.4080301@rs.jp.nec.com> <BANLkTinxzNWZnMvj1716S24HJ6n2NM0z=w@mail.gmail.com> <D77F5ECA-5803-44B7-B8AB-E18707386B42@dilger.ca> <BANLkTikQYPmTk7ui1CDszkBR_QDeSzs33g@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mark Harris <mhlk@osj.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:5199 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab1F0JEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 05:04:10 -0400
In-Reply-To: <BANLkTikQYPmTk7ui1CDszkBR_QDeSzs33g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-24, at 11:12 PM, Mark Harris wrote:
> On Fri, Jun 24, 2011 at 15:46, Andreas Dilger wrote:
>> The problem with this encoding is that it requires existing 32-bit
>> timestamps before 1970 to have encoded "11" in the extra epoch bits,
>> which is not the case.  Current pre-1970 timestamps would be encoded
>> with "00" there, which would (according to your table) bump them past
>> 2038 incorrectly.
> 
> I was under the impression that the encoding code stored bits
> 33 & 32 of tv_sec there, which would be 1,1 for a negative value
> like -1.  Certainly the decoding would be simpler if the extra
> value was only non-zero for large timestamps.

One problem with a symmetrical encoding is that it wastes half of the
dynamic range for values that nobody will ever use.  Even values before
1970 seem so unlikely that I question whether we should support them
at all.

> On closer inspection of ext4_encode_extra_time, it looks like for
> tv_sec = -1, a 64-bit kernel will store 1,1 in the extra bits and
> a 32-bit kernel will store 0,0 in the extra bits.  That is a problem
> if both of these need to be decoded as -1 on a 64-bit system.

That is definitely a problem.

>> What we need is an encoding that preserves the times for extra epoch "00":
>> 
>>  2    msb of                         adjustment needed to convert
>> extra  32-bit                         sign-extended 32-bit tv_sec
>>  bits   time   decoded 64-bit tv_sec   to decoded 64-bit tv_sec
>>  0 0     1    -0x80000000..-1           0
>>  0 0     0    0x000000000..0x07fffffff  0
>>  0 1     1    0x080000000..0x0ffffffff  0x100000000
>>  0 1     0    0x100000000..0x17fffffff  0x100000000
>>  1 0     1    0x180000000..0x1ffffffff  0x200000000
>>  1 0     0    0x200000000..0x27fffffff  0x200000000
>>  1 1     1    0x280000000..0x2ffffffff  0x300000000
>>  1 1     0    0x300000000..0x37fffffff  0x300000000
>> 
>> So, looking at the above desired encoding, it looks like the error in
>> the existing code is that it is doing a boolean operation on decode
>> instead of a mathematical one, and it was incorrectly trying to extend
>> the time to (1ULL<<34).  The below should fix this:
>> 
>> static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
>> {
>>        if (unlikely(sizeof(time->tv_sec) > 4 &&
>>                     (extra & cpu_to_le32(EXT4_EPOCH_MASK)))
>>                time->tv_sec += (u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK) << 32;
>> 
>>        time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
>> }
> 
> That is not compatible with the existing ext4_encode_extra_time.
> For example, 2038-01-31 (0x80101500) is encoded with extra bits
> equal to bits 33 & 32, i.e. 0,0.  But this code would decode it
> as 1901-12-25 (i.e. it would leave the sign-extended 32-bit value
> unchanged).

Part of the problem is that the encoding/decoding of timestamps beyond
2038 is already broken today, so I don't think anyone has been using
them so far.  This gives us some leeway for fixing this problem I think.

> Possible solutions:
> 
> (a) Define the current 64-bit encoding as the correct encoding since
>     the 2 extra bits are not even decoded on 32-bit kernels, so its
>     encoding doesn't matter much.  However, if anyone with existing
>     pre-1970 timestamps written using a 32-bit kernel wants to use
>     their ext4 filesystem with a 64-bit kernel, the pre-1970
>     timestamps would be wrong unless they re-write them with a
>     fixed kernel.
> 
>     Change ext4_decode_extra_time "if" body to something like:
>        time->tv_sec += ((__u32)time->tv_sec +
>                ((__u64)le32_to_cpu(extra) << 32) +
>                0x80000000LL) & 0x300000000LL;
> 
>     Change ext4_encode_extra_time ": 0" to something like:
>        time->tv_sec < 0 ? EXT4_EPOCH_MASK : 0

The real-world problem isn't with 32-bit systems, where it doesn't
really matter at all how time is encoded, nor with files on 64-bit systems
with timestamps 26 years in the future, but rather 256-byte inodes that
were previously written with ext3 that will break if they are mounted
with ext4 on a 64-bit system. 

> (b) Change the encoding of the extra bits to be those in your new
>     table.  This is compatible with the 32-bit kernel encoding
>     (which does not decode these bits) but incompatible with the
>     64-bit kernel encoding.  Existing pre-1970 timestamps written
>     with a 64-bit kernel would be decoded as dates far in the future.
> 
>     Requires your change to ext4_decode_extra_time.
>     Also requires a change to ext4_encode_extra_time, changing
>     (time->tv_sec >> 32) to something like:
>        ((time->tv_sec - (signed int)time->tv_sec) >> 32)

I think this is a reasonable solution, but I dislike that it breaks
pre-1970 timestamps on 64-bit systems.

> (c) If 100% compatibility with existing pre-1970 32-bit timestamps
>     is desired even when switching between 32-bit and 64-bit kernels,
>     both extra=1,1/msb=1 and extra=0,0/msb=1 could be treated as year
>     1901..1969 timestamps.  However this would reduce the maximum
>     64-bit ext4 timestamp, and would necessarily be incompatible with
>     the existing 64-bit kernel encoding of timestamps > year 2038
>     (since a current 64-bit kernel encodes a year 2039 timestamp
>     exactly the same as a current 32-bit kernel encodes a year 1902
>     timestamp).
> 
>     This requires additional complexity in both ext4_decode_extra_time
>     and ext4_encode_extra_time.

This would also be a good option for the short term, and then have e2fsck
fix up the "11" encoded pre-1970 times to use "00", or just allow both
to work.  This cuts 136 years off the range (2310-04-04..2446-05-10) but
to be honest I don't think that will matter very much.

> (d) Declare that ext4 supports only timestamps with year >= 1970.
>     i.e. 1970..2514 (64-bit), 1970..2038 (32-bit).
>     Any existing pre-1970 timestamps would now be interpreted as a
>     year >= 2038 timestamp on 64-bit kernels.
> 
>     It may be possible for users of 32-bit kernels to continue to
>     successfully read and write 1901..1969 timestamps, but this
>     would have to be unsupported.  If such a timestamp was read with
>     a 64-bit kernel, or a program like fsck.ext4, the time may be
>     different.

I'm not so fond of this solution either.

>     If some day, as 2038 approaches, 32-bit time_t is changed to
>     unsigned, ext4 would once again support all 32-bit time_t
>     values.
> 
>     To implement, the decoding can simply drop all casts to (signed).
>     Optionally, the encoding could encode any negative tv_sec as 0
>     to make 32-bit and 64-bit behavior for pre-1970 timestamps
>     consistent (bugzilla 5079/8643).  However this may break some
>     uses of pre-1970 timestamps that would otherwise work on
>     32-bit kernels.

Hopefully Ted can chime in on this as well.

Cheers, Andreas





