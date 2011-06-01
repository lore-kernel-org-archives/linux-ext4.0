From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: xfsprogs: Fix for xfstest 252 hang on ext4
Date: Wed, 01 Jun 2011 13:50:41 -0700
Message-ID: <4DE6A621.7040206@linux.vnet.ibm.com>
References: <4DDAC4EF.1050702@linux.vnet.ibm.com> <BANLkTiks0NSDTSPN8n446JHWhKtM61_=Mw@mail.gmail.com> <4DDB1A0C.5030502@linux.vnet.ibm.com>	<4DE50881.90401@linux.vnet.ibm.com> <BANLkTin3+GT+LmjTACDnZUKamhFhDMkvVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
	"Ted Ts'o" <tytso@mit.edu>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43514 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab1FAUu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jun 2011 16:50:59 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p51KSg5r026813
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jun 2011 16:28:42 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p51Kotc2061496
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jun 2011 16:50:55 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p51KosQx009814
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jun 2011 16:50:55 -0400
In-Reply-To: <BANLkTin3+GT+LmjTACDnZUKamhFhDMkvVA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/31/2011 6:58 PM, Yongqiang Yang wrote:
> On Tue, May 31, 2011 at 11:25 PM, Allison Henderson
> <achender@linux.vnet.ibm.com>  wrote:
>> On 5/23/2011 7:38 PM, Allison Henderson wrote:
>>>
>>> On 5/23/2011 6:16 PM, Yongqiang Yang wrote:
>>>>
>>>> On Tue, May 24, 2011 at 4:34 AM, Allison Henderson
>>>> <achender@linux.vnet.ibm.com>  wrote:
>>>>>
>>>>> Hi all,
>>>>>
>>>>> While trying to add more punch hole tests to xfstest, I found tha=
t
>>>>> test 252 hangs on ext4 due to a loop in xfsprogs that does not ex=
it.
>>>>> XFS gets out of this loop because there is logic in the loop that
>>>>> looks for the last extent flag and breaks out. But it looks like =
ext4
>>>>> does not return a last extent when the file has a hole at the end=
=2E I
>>>>> am not sure if this is the correct behavior or not, so I will cop=
y
>>>>> the ext4 folks on this too. Below is a copy of the fix for xfspro=
gs:
>>>>
>>>> Hi there,
>>>>
>>>> What's blocksize of the tested ext4? For now, ext4 returns
>>>> LAST_EXTENT if the logical offset covered by the extent is greater
>>>> than file size, so if there is a hole at the end, no last extent i=
s
>>>> returned. Thx!
>>>>
>>>> Yongqiang.
>>>
>>> Hi there,
>>>
>>> The block size I've been using is 4096. As long as that behavior is
>>> expected, I think the test will be ok with just the xfsprogs fix,
>>> though. Thx!
>>>
>>> Allison Henderson
>>>
>>>>
>>>>>
>>>>> diff --git a/io/fiemap.c b/io/fiemap.c
>>>>> index fa990cc..81fc92c 100644
>>>>> --- a/io/fiemap.c
>>>>> +++ b/io/fiemap.c
>>>>> @@ -246,7 +246,7 @@ fiemap_f(
>>>>> flg_w, _("FLAGS"));
>>>>> }
>>>>>
>>>>> - while (!last&&  ((cur_extent + 1) !=3D max_extents)) {
>>>>> + while (!last&&  (cur_extent<=3D max_extents)) {
>>>>> if (max_extents)
>>>>> num_extents =3D min(num_extents,
>>>>> max_extents - (cur_extent + 1));
>>>>>
>>>>>
>>>>> It looks like the loop enters with last=3D0, cur_extents=3D0, and
>>>>> max_extents =3D 0, and on the first iteration cur_extents get set=
 to 2,
>>>>> so we dont see ((cur_extent + 1) =3D=3D max_extents for a very lo=
ng time.
>>>>> I doubt the logic was meant to work that way, so this patch shoul=
d
>>>>> fix it, but I wanted to make sure that the fiemap for ext4 is wor=
king
>>>>> as intended too. Feed back appreciated! Thx all!
>>>>>
>>>>> Allison Henderson
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>>>
>>>>
>>>
>>
>>
>>>> Hi all,
>>>>
>>>> I haven't heard much back on this patch, so Im just poking this
>>>> thread to make sure it doesn't get forgotten. I have some patches
>>>> out there for punch hole, and I'm currently looking at fixing up
>>>> some older punch hole tests in the dmapi code, but they wont do mu=
ch
>>>> good for ext4 with out this fix.  If I could get a quick peek from
>>>> some one on the xfs list for this patch, that would be much
>>>> appreciated.  Thx all!
>>>
>>> If ext4 is not setting the last extent flag on the last extent then
>>> that's an ext4 bug that the test has detected, right? And so you
>>> should be fixing ext4 rather than modifying the test to hide the
>>> different behaviour?
>>>
>>> Cheer
>>>
>>> -- Dave Chinner david@fromorbit.com
>>
>> Hi All,
>>
>> Sorry, I should have poked the thread with Yongqiang's response, so =
I will
>> move the dialog into this thread.  At the moment, it sounds like the=
 fiemap
>> for ext4 is working as intended.  Yongqiang, do you agree that the f=
iemap
>> for ext4 should be changed?  I think you are more familiar with this=
 part of
> Yes, I agree.  ext4 should return LAST extent.  I am thinking if we
> can find a new solution collecting extents.
>
> Maybe we can insert delayed extents into extent tree. This way fiemap
> will be simpler and much more efficient.
>
> I would like to throw out the proposal inserting delayed-extents into
> extent tree.  What will it bring?  AFAIK it will bring:
> 1. We need to down i_data_sem in delayed write-path to insert
> delayed-extents into the tree without journaling it.
>
> 2. When we come to block allocation, we can convert delayed-extents t=
o
> normal extents.
>
> There is a problem that the solution can be only used in ordered mode=
=2E
> So what are your opinions=EF=BC=9F
>
> Yongqiang.


Hi All,

Well, I am not yet familiar with how the code for ordered mode works, s=
o=20
I may not be much help here, but I do think that if we could get it to=20
work, it would help simplify a lot of things including fiemap and punch=
=20
hole.  I know that the earlier versions of punch hole were a little=20
complicated because of the different mechanisms needed to identify=20
mapped extents, delayed extents and holes.  Eventually what we did was=20
to flush out the data in the region to be punched out in order to avoid=
=20
race conditions, and also to simplify the logic.  This has introduced=20
some problems in some of the existing xfstests punch hole tests, becaus=
e=20
the tests want to see a hole in unwritten extents instead of written=20
extents.  I was working on some optimization patches to avoid this, but=
=20
if this proposal is put in place, I think I could optimize that fix a=20
lot.  And I know the fiemap routines would get simpler sense they would=
=20
only have to deal with the extent tree. If we decide to do what you=20
propose, I will wait on doing any punch hole or fiemap patches to take=20
advantage of that.  I'll poke around with the modes too to see if=20
there's any thing we can do to get around that problem.  Thx!

Allison Henderson

>
>> the code than I am, and I just want to make sure we find a solution =
that
>> everyone is happy with.  Thx!
>>
>> Allison Henderson
>>
>>
>>
>>
>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>>
>
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
