From: Mark Harris <mhlk@osj.us>
Subject: Re: [BUG] ext4 timestamps corruption
Date: Fri, 24 Jun 2011 22:12:12 -0700
Message-ID: <BANLkTikQYPmTk7ui1CDszkBR_QDeSzs33g@mail.gmail.com>
References: <4DF1D57C.3030107@rs.jp.nec.com>
	<3BB3CFE7-BD50-4123-A1C8-D3FDAAD184DA@gmail.com>
	<4E02F0B8.4080301@rs.jp.nec.com>
	<BANLkTinxzNWZnMvj1716S24HJ6n2NM0z=w@mail.gmail.com>
	<D77F5ECA-5803-44B7-B8AB-E18707386B42@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64766 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1FYFMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Jun 2011 01:12:14 -0400
Received: by iwn6 with SMTP id 6so2892667iwn.19
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jun 2011 22:12:13 -0700 (PDT)
In-Reply-To: <D77F5ECA-5803-44B7-B8AB-E18707386B42@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 24, 2011 at 15:46, Andreas Dilger wrote:
> On 2011-06-23, at 4:37 PM, Mark Harris wrote:
>> 2011/6/23 Akira Fujita <a-fujita@rs.jp.nec.com>:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D23732
>>>
>>> ext4: Fix ext4 timestamps corruption
>>>
>>> Officially, ext4 can handle its timestamps until 2514
>>> with 32bit entries plus EPOCH_BIT (2bits).
>>> But when timestamps values use 32+ bit
>>> (e.g. 2038-01-19 9:14:08 0x0000000080000000),
>>> we can get corrupted values.
>>> Because sign bit is overwritten by transferring value
>>> between kernel space and user space.
>>>
>>> To fix this issue, 32th bit of extra time fields in ext4_inode stru=
cture
>>> (e.g. i_ctime_extra) are used as the sign for 64bit user space.
>>> Because these are used only 20bits for nano-second and bottom of 2b=
its
>>> are for EXT4_EPOCH_BITS shift.
>>> With this patch, ext4 supports timestamps Y1901-2514.
>>
>> Thanks for looking into this bug. =A0However tv_nsec is in the
>> range 0..999999999 and requires 30 bits. =A0That is why tv_sec was
>> only extended by 2 bits. =A0So there are no additional spare bits
>> in the "extra" field.
>>
>> 34-bit seconds can accommodate a maximum of 544.4 years, e.g.
>> 1970..2514 or 1901..2446. =A0Although an early version of the patch
>> for 34-bit tv_sec in ext4 worked with years 1970..2514, prior to
>> being committed the patch was changed to support pre-1970
>> timestamps (introducing the sign extension issue in the decoding):
>> =A0http://marc.info/?l=3Dlinux-ext4&m=3D118208541320999
>
> Sigh, it seems so unlikely that anyone even has a valid timestamp
> on a file with a date before 1970, it makes me wonder if this extra
> effort is even worthwhile...
>
>> The existing encoding simply encodes bits 31..0 of tv_sec in the
>> regular time field and bits 33..32 in the extra field (along with
>> the 30-bit tv_nsec). =A0The issue is in the decoding, which I think
>> can be addressed by changing only the body of the "if" in in the
>> ext4_decode_extra_time function, to something like this:
>>
>> =A0 =A0 =A0 =A0time->tv_sec +=3D ((__u32)time->tv_sec +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((__u64)le32_to_cpu(extra) << 32) +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x80000000LL) & 0x300000000LL;
>>
>> This is untested, and might look nicer with some macros, but
>> it should decode the 34 bits into a timestamp in the range
>> -0x80000000 (1901-12-13) to 0x37fffffff (2446-05-10), while
>> retaining compatibility with the existing encoding.
>>
>> =A0 2 =A0 =A0msb of =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
adjustment needed to convert
>> extra =A032-bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sign=
-extended 32-bit tv_sec
>> =A0bits =A0 time =A0 decoded 64-bit tv_sec =A0 to decoded 64-bit tv_=
sec
>> =A01 1 =A0 =A0 1 =A0 =A0-0x80000000..-1 =A0 =A0 =A0 =A0 =A0 0
>> =A00 0 =A0 =A0 0 =A0 =A00x000000000..0x07fffffff =A00
>> =A00 0 =A0 =A0 1 =A0 =A00x080000000..0x0ffffffff =A00x100000000
>> =A00 1 =A0 =A0 0 =A0 =A00x100000000..0x17fffffff =A00x100000000
>> =A00 1 =A0 =A0 1 =A0 =A00x180000000..0x1ffffffff =A00x200000000
>> =A01 0 =A0 =A0 0 =A0 =A00x200000000..0x27fffffff =A00x200000000
>> =A01 0 =A0 =A0 1 =A0 =A00x280000000..0x2ffffffff =A00x300000000
>> =A01 1 =A0 =A0 0 =A0 =A00x300000000..0x37fffffff =A00x300000000
>
> The problem with this encoding is that it requires existing 32-bit
> timestamps before 1970 to have encoded "11" in the extra epoch bits,
> which is not the case. =A0Current pre-1970 timestamps would be encode=
d
> with "00" there, which would (according to your table) bump them past
> 2038 incorrectly.

I was under the impression that the encoding code stored bits
33 & 32 of tv_sec there, which would be 1,1 for a negative value
like -1.  Certainly the decoding would be simpler if the extra
value was only non-zero for large timestamps.

On closer inspection of ext4_encode_extra_time, it looks like for
tv_sec =3D -1, a 64-bit kernel will store 1,1 in the extra bits and
a 32-bit kernel will store 0,0 in the extra bits.  That is a problem
if both of these need to be decoded as -1 on a 64-bit system.

>
> What we need is an encoding that preserves the times for extra epoch =
"00":
>
> =A02 =A0 =A0msb of =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ad=
justment needed to convert
> extra =A032-bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sign-=
extended 32-bit tv_sec
> =A0bits =A0 time =A0 decoded 64-bit tv_sec =A0 to decoded 64-bit tv_s=
ec
> =A00 0 =A0 =A0 1 =A0 =A0-0x80000000..-1 =A0 =A0 =A0 =A0 =A0 0
> =A00 0 =A0 =A0 0 =A0 =A00x000000000..0x07fffffff =A00
> =A00 1 =A0 =A0 1 =A0 =A00x080000000..0x0ffffffff =A00x100000000
> =A00 1 =A0 =A0 0 =A0 =A00x100000000..0x17fffffff =A00x100000000
> =A01 0 =A0 =A0 1 =A0 =A00x180000000..0x1ffffffff =A00x200000000
> =A01 0 =A0 =A0 0 =A0 =A00x200000000..0x27fffffff =A00x200000000
> =A01 1 =A0 =A0 1 =A0 =A00x280000000..0x2ffffffff =A00x300000000
> =A01 1 =A0 =A0 0 =A0 =A00x300000000..0x37fffffff =A00x300000000
>
> So, looking at the above desired encoding, it looks like the error in
> the existing code is that it is doing a boolean operation on decode
> instead of a mathematical one, and it was incorrectly trying to exten=
d
> the time to (1ULL<<34). =A0The below should fix this:
>
> static inline void ext4_decode_extra_time(struct timespec *time, __le=
32 extra)
> {
> =A0 =A0 =A0 =A0if (unlikely(sizeof(time->tv_sec) > 4 &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (extra & cpu_to_le32(EXT4_EPO=
CH_MASK)))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0time->tv_sec +=3D (u64)(le32_to_cpu(ex=
tra) & EXT4_EPOCH_MASK) << 32;
>
> =A0 =A0 =A0 =A0time->tv_nsec =3D (le32_to_cpu(extra) & EXT4_NSEC_MASK=
) >> EXT4_EPOCH_BITS;
> }

That is not compatible with the existing ext4_encode_extra_time.
=46or example, 2038-01-31 (0x80101500) is encoded with extra bits
equal to bits 33 & 32, i.e. 0,0.  But this code would decode it
as 1901-12-25 (i.e. it would leave the sign-extended 32-bit value
unchanged).

Possible solutions:

 (a) Define the current 64-bit encoding as the correct encoding since
     the 2 extra bits are not even decoded on 32-bit kernels, so its
     encoding doesn't matter much.  However, if anyone with existing
     pre-1970 timestamps written using a 32-bit kernel wants to use
     their ext4 filesystem with a 64-bit kernel, the pre-1970
     timestamps would be wrong unless they re-write them with a
     fixed kernel.

     Change ext4_decode_extra_time "if" body to something like:
        time->tv_sec +=3D ((__u32)time->tv_sec +
                ((__u64)le32_to_cpu(extra) << 32) +
                0x80000000LL) & 0x300000000LL;

     Change ext4_encode_extra_time ": 0" to something like:
        time->tv_sec < 0 ? EXT4_EPOCH_MASK : 0

 (b) Change the encoding of the extra bits to be those in your new
     table.  This is compatible with the 32-bit kernel encoding
     (which does not decode these bits) but incompatible with the
     64-bit kernel encoding.  Existing pre-1970 timestamps written
     with a 64-bit kernel would be decoded as dates far in the future.

     Requires your change to ext4_decode_extra_time.
     Also requires a change to ext4_encode_extra_time, changing
     (time->tv_sec >> 32) to something like:
        ((time->tv_sec - (signed int)time->tv_sec) >> 32)

 (c) If 100% compatibility with existing pre-1970 32-bit timestamps
     is desired even when switching between 32-bit and 64-bit kernels,
     both extra=3D1,1/msb=3D1 and extra=3D0,0/msb=3D1 could be treated =
as year
     1901..1969 timestamps.  However this would reduce the maximum
     64-bit ext4 timestamp, and would necessarily be incompatible with
     the existing 64-bit kernel encoding of timestamps > year 2038
     (since a current 64-bit kernel encodes a year 2039 timestamp
     exactly the same as a current 32-bit kernel encodes a year 1902
     timestamp).

     This requires additional complexity in both ext4_decode_extra_time
     and ext4_encode_extra_time.

 (d) Declare that ext4 supports only timestamps with year >=3D 1970.
     i.e. 1970..2514 (64-bit), 1970..2038 (32-bit).
     Any existing pre-1970 timestamps would now be interpreted as a
     year >=3D 2038 timestamp on 64-bit kernels.

     It may be possible for users of 32-bit kernels to continue to
     successfully read and write 1901..1969 timestamps, but this
     would have to be unsupported.  If such a timestamp was read with
     a 64-bit kernel, or a program like fsck.ext4, the time may be
     different.

     If some day, as 2038 approaches, 32-bit time_t is changed to
     unsigned, ext4 would once again support all 32-bit time_t
     values.

     To implement, the decoding can simply drop all casts to (signed).
     Optionally, the encoding could encode any negative tv_sec as 0
     to make 32-bit and 64-bit behavior for pre-1970 timestamps
     consistent (bugzilla 5079/8643).  However this may break some
     uses of pre-1970 timestamps that would otherwise work on
     32-bit kernels.

 - Mark

>
> Cheers, Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
