From: Mark Harris <mhlk@osj.us>
Subject: Re: [BUG] ext4 timestamps corruption
Date: Fri, 8 Jul 2011 10:06:28 -0700
Message-ID: <CADQUmxXSRkvNFJX2+1Wefd5BWFeBB9pThpiucgyn=TBbvFutVw@mail.gmail.com>
References: <4DF1D57C.3030107@rs.jp.nec.com>
	<3BB3CFE7-BD50-4123-A1C8-D3FDAAD184DA@gmail.com>
	<4E02F0B8.4080301@rs.jp.nec.com>
	<BANLkTinxzNWZnMvj1716S24HJ6n2NM0z=w@mail.gmail.com>
	<D77F5ECA-5803-44B7-B8AB-E18707386B42@dilger.ca>
	<BANLkTikQYPmTk7ui1CDszkBR_QDeSzs33g@mail.gmail.com>
	<86641D0C-ADC7-48B4-8AA6-F62929F71528@dilger.ca>
	<4E12ECBF.2060307@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57060 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1GHRG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jul 2011 13:06:29 -0400
Received: by iwn6 with SMTP id 6so1932102iwn.19
        for <linux-ext4@vger.kernel.org>; Fri, 08 Jul 2011 10:06:28 -0700 (PDT)
In-Reply-To: <4E12ECBF.2060307@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Akira Fujita wrote:
> Hi, Andreas and Mark,
> Thank you for looking at this issue.
>
> (2011/06/27 18:04), Andreas Dilger wrote:
>> On 2011-06-24, at 11:12 PM, Mark Harris wrote:
>>> On Fri, Jun 24, 2011 at 15:46, Andreas Dilger wrote:
>>>> The problem with this encoding is that it requires existing 32-bit
>>>> timestamps before 1970 to have encoded "11" in the extra epoch bit=
s,
>>>> which is not the case. =A0Current pre-1970 timestamps would be enc=
oded
>>>> with "00" there, which would (according to your table) bump them p=
ast
>>>> 2038 incorrectly.
>>>
>>> I was under the impression that the encoding code stored bits
>>> 33& =A032 of tv_sec there, which would be 1,1 for a negative value
>>> like -1. =A0Certainly the decoding would be simpler if the extra
>>> value was only non-zero for large timestamps.
>>
>> One problem with a symmetrical encoding is that it wastes half of th=
e
>> dynamic range for values that nobody will ever use. =A0Even values b=
efore
>> 1970 seem so unlikely that I question whether we should support them
>> at all.
>>
>>> On closer inspection of ext4_encode_extra_time, it looks like for
>>> tv_sec =3D -1, a 64-bit kernel will store 1,1 in the extra bits and
>>> a 32-bit kernel will store 0,0 in the extra bits. =A0That is a prob=
lem
>>> if both of these need to be decoded as -1 on a 64-bit system.
>>
>> That is definitely a problem.
>>
>>>> What we need is an encoding that preserves the times for extra epo=
ch "00":
>>>>
>>>> =A0 2 =A0 =A0msb of =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 adjustment needed to convert
>>>> extra =A032-bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 si=
gn-extended 32-bit tv_sec
>>>> =A0 bits =A0 time =A0 decoded 64-bit tv_sec =A0 to decoded 64-bit =
tv_sec
>>>> =A0 0 0 =A0 =A0 1 =A0 =A0-0x80000000..-1 =A0 =A0 =A0 =A0 =A0 0
>>>> =A0 0 0 =A0 =A0 0 =A0 =A00x000000000..0x07fffffff =A00
>>>> =A0 0 1 =A0 =A0 1 =A0 =A00x080000000..0x0ffffffff =A00x100000000
>>>> =A0 0 1 =A0 =A0 0 =A0 =A00x100000000..0x17fffffff =A00x100000000
>>>> =A0 1 0 =A0 =A0 1 =A0 =A00x180000000..0x1ffffffff =A00x200000000
>>>> =A0 1 0 =A0 =A0 0 =A0 =A00x200000000..0x27fffffff =A00x200000000
>>>> =A0 1 1 =A0 =A0 1 =A0 =A00x280000000..0x2ffffffff =A00x300000000
>>>> =A0 1 1 =A0 =A0 0 =A0 =A00x300000000..0x37fffffff =A00x300000000
>>>>
>>>> So, looking at the above desired encoding, it looks like the error=
 in
>>>> the existing code is that it is doing a boolean operation on decod=
e
>>>> instead of a mathematical one, and it was incorrectly trying to ex=
tend
>>>> the time to (1ULL<<34). =A0The below should fix this:
>>>>
>>>> static inline void ext4_decode_extra_time(struct timespec *time, _=
_le32 extra)
>>>> {
>>>> =A0 =A0 =A0 =A0 if (unlikely(sizeof(time->tv_sec)> =A04&&
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(extra& =A0cpu_to_le32(=
EXT4_EPOCH_MASK)))
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 time->tv_sec +=3D (u64)(le32_to_cp=
u(extra)& =A0EXT4_EPOCH_MASK)<< =A032;
>>>>
>>>> =A0 =A0 =A0 =A0 time->tv_nsec =3D (le32_to_cpu(extra)& =A0EXT4_NSE=
C_MASK)>> =A0EXT4_EPOCH_BITS;
>>>> }
>>>
>>> That is not compatible with the existing ext4_encode_extra_time.
>>> For example, 2038-01-31 (0x80101500) is encoded with extra bits
>>> equal to bits 33& =A032, i.e. 0,0. =A0But this code would decode it
>>> as 1901-12-25 (i.e. it would leave the sign-extended 32-bit value
>>> unchanged).
>>
>> Part of the problem is that the encoding/decoding of timestamps beyo=
nd
>> 2038 is already broken today, so I don't think anyone has been using
>> them so far. =A0This gives us some leeway for fixing this problem I =
think.
>>
>>> Possible solutions:
>>>
>>> (a) Define the current 64-bit encoding as the correct encoding sinc=
e
>>> =A0 =A0 =A0the 2 extra bits are not even decoded on 32-bit kernels,=
 so its
>>> =A0 =A0 =A0encoding doesn't matter much. =A0However, if anyone with=
 existing
>>> =A0 =A0 =A0pre-1970 timestamps written using a 32-bit kernel wants =
to use
>>> =A0 =A0 =A0their ext4 filesystem with a 64-bit kernel, the pre-1970
>>> =A0 =A0 =A0timestamps would be wrong unless they re-write them with=
 a
>>> =A0 =A0 =A0fixed kernel.
>>>
>>> =A0 =A0 =A0Change ext4_decode_extra_time "if" body to something lik=
e:
>>> =A0 =A0 =A0 =A0 time->tv_sec +=3D ((__u32)time->tv_sec +
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((__u64)le32_to_cpu(extra)<< =A032)=
 +
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x80000000LL)& =A00x300000000LL;
>>>
>>> =A0 =A0 =A0Change ext4_encode_extra_time ": 0" to something like:
>>> =A0 =A0 =A0 =A0 time->tv_sec< =A00 ? EXT4_EPOCH_MASK : 0
>>
>> The real-world problem isn't with 32-bit systems, where it doesn't
>> really matter at all how time is encoded, nor with files on 64-bit s=
ystems
>> with timestamps 26 years in the future, but rather 256-byte inodes t=
hat
>> were previously written with ext3 that will break if they are mounte=
d
>> with ext4 on a 64-bit system.
>>
>>> (b) Change the encoding of the extra bits to be those in your new
>>> =A0 =A0 =A0table. =A0This is compatible with the 32-bit kernel enco=
ding
>>> =A0 =A0 =A0(which does not decode these bits) but incompatible with=
 the
>>> =A0 =A0 =A064-bit kernel encoding. =A0Existing pre-1970 timestamps =
written
>>> =A0 =A0 =A0with a 64-bit kernel would be decoded as dates far in th=
e future.
>>>
>>> =A0 =A0 =A0Requires your change to ext4_decode_extra_time.
>>> =A0 =A0 =A0Also requires a change to ext4_encode_extra_time, changi=
ng
>>> =A0 =A0 =A0(time->tv_sec>> =A032) to something like:
>>> =A0 =A0 =A0 =A0 ((time->tv_sec - (signed int)time->tv_sec)>> =A032)
>>
>> I think this is a reasonable solution, but I dislike that it breaks
>> pre-1970 timestamps on 64-bit systems.
>
> I agree with this solution.
> I guess that no one has pre-1970 timestamps on ext4, actually.
>
> Mark, are you working on this right now?
> If you have a patch to fix this issue, please send it to the list.

I think that all of the code changes needed to implement this
solution (b) are in ext4_decode_extra_time and ext4_encode_extra_time
and are included above, if you want to submit them in patch format
as a new version of your patch.  The issue with this solution is
that it breaks existing 1901..1969 timestamps written with a 64-bit
kernel to ext4 with 256-byte inodes.  (It breaks existing year 2038+
timestamps as well, but those are already broken.)  It sounds like
Andreas favors either (b) or (c) but would like to hear from Ted.

 - Mark

>
> Regards,
> Akira Fujita
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
