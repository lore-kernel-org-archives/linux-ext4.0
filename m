From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: xfsprogs: Fix for xfstest 252 hang on ext4
Date: Wed, 1 Jun 2011 09:58:45 +0800
Message-ID: <BANLkTin3+GT+LmjTACDnZUKamhFhDMkvVA@mail.gmail.com>
References: <4DDAC4EF.1050702@linux.vnet.ibm.com>
	<BANLkTiks0NSDTSPN8n446JHWhKtM61_=Mw@mail.gmail.com>
	<4DDB1A0C.5030502@linux.vnet.ibm.com>
	<4DE50881.90401@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
	"Ted Ts'o" <tytso@mit.edu>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64805 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1FAB6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 May 2011 21:58:45 -0400
Received: by pwi15 with SMTP id 15so2325211pwi.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 May 2011 18:58:45 -0700 (PDT)
In-Reply-To: <4DE50881.90401@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 31, 2011 at 11:25 PM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 5/23/2011 7:38 PM, Allison Henderson wrote:
>>
>> On 5/23/2011 6:16 PM, Yongqiang Yang wrote:
>>>
>>> On Tue, May 24, 2011 at 4:34 AM, Allison Henderson
>>> <achender@linux.vnet.ibm.com> wrote:
>>>>
>>>> Hi all,
>>>>
>>>> While trying to add more punch hole tests to xfstest, I found that
>>>> test 252 hangs on ext4 due to a loop in xfsprogs that does not exi=
t.
>>>> XFS gets out of this loop because there is logic in the loop that
>>>> looks for the last extent flag and breaks out. But it looks like e=
xt4
>>>> does not return a last extent when the file has a hole at the end.=
 I
>>>> am not sure if this is the correct behavior or not, so I will copy
>>>> the ext4 folks on this too. Below is a copy of the fix for xfsprog=
s:
>>>
>>> Hi there,
>>>
>>> What's blocksize of the tested ext4? For now, ext4 returns
>>> LAST_EXTENT if the logical offset covered by the extent is greater
>>> than file size, so if there is a hole at the end, no last extent is
>>> returned. Thx!
>>>
>>> Yongqiang.
>>
>> Hi there,
>>
>> The block size I've been using is 4096. As long as that behavior is
>> expected, I think the test will be ok with just the xfsprogs fix,
>> though. Thx!
>>
>> Allison Henderson
>>
>>>
>>>>
>>>> diff --git a/io/fiemap.c b/io/fiemap.c
>>>> index fa990cc..81fc92c 100644
>>>> --- a/io/fiemap.c
>>>> +++ b/io/fiemap.c
>>>> @@ -246,7 +246,7 @@ fiemap_f(
>>>> flg_w, _("FLAGS"));
>>>> }
>>>>
>>>> - while (!last&& ((cur_extent + 1) !=3D max_extents)) {
>>>> + while (!last&& (cur_extent<=3D max_extents)) {
>>>> if (max_extents)
>>>> num_extents =3D min(num_extents,
>>>> max_extents - (cur_extent + 1));
>>>>
>>>>
>>>> It looks like the loop enters with last=3D0, cur_extents=3D0, and
>>>> max_extents =3D 0, and on the first iteration cur_extents get set =
to 2,
>>>> so we dont see ((cur_extent + 1) =3D=3D max_extents for a very lon=
g time.
>>>> I doubt the logic was meant to work that way, so this patch should
>>>> fix it, but I wanted to make sure that the fiemap for ext4 is work=
ing
>>>> as intended too. Feed back appreciated! Thx all!
>>>>
>>>> Allison Henderson
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>>
>>
>
>
>>> Hi all,
>>>
>>> I haven't heard much back on this patch, so Im just poking this
>>> thread to make sure it doesn't get forgotten. I have some patches
>>> out there for punch hole, and I'm currently looking at fixing up
>>> some older punch hole tests in the dmapi code, but they wont do muc=
h
>>> good for ext4 with out this fix. =C2=A0If I could get a quick peek =
from
>>> some one on the xfs list for this patch, that would be much
>>> appreciated. =C2=A0Thx all!
>>
>> If ext4 is not setting the last extent flag on the last extent then
>> that's an ext4 bug that the test has detected, right? And so you
>> should be fixing ext4 rather than modifying the test to hide the
>> different behaviour?
>>
>> Cheer
>>
>>-- Dave Chinner david@fromorbit.com
>
> Hi All,
>
> Sorry, I should have poked the thread with Yongqiang's response, so I=
 will
> move the dialog into this thread. =C2=A0At the moment, it sounds like=
 the fiemap
> for ext4 is working as intended. =C2=A0Yongqiang, do you agree that t=
he fiemap
> for ext4 should be changed? =C2=A0I think you are more familiar with =
this part of
Yes, I agree.  ext4 should return LAST extent.  I am thinking if we
can find a new solution collecting extents.

Maybe we can insert delayed extents into extent tree. This way fiemap
will be simpler and much more efficient.

I would like to throw out the proposal inserting delayed-extents into
extent tree.  What will it bring?  AFAIK it will bring:
1. We need to down i_data_sem in delayed write-path to insert
delayed-extents into the tree without journaling it.

2. When we come to block allocation, we can convert delayed-extents to
normal extents.

There is a problem that the solution can be only used in ordered mode.
So what are your opinions=EF=BC=9F

Yongqiang.

> the code than I am, and I just want to make sure we find a solution t=
hat
> everyone is happy with. =C2=A0Thx!
>
> Allison Henderson
>
>
>
>
>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
