From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Sat, 24 Apr 2010 10:30:45 -0400
Message-ID: <o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
	 <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>
	 <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>
	 <4BCF4C53.3010608@redhat.com>
	 <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>
	 <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
	 <alpine.LFD.2.00.1004230944070.2814@localhost>
	 <w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>
	 <4BD2F69D.7070508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:60251 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0DXOaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Apr 2010 10:30:46 -0400
Received: by iwn35 with SMTP id 35so6393853iwn.21
        for <linux-ext4@vger.kernel.org>; Sat, 24 Apr 2010 07:30:45 -0700 (PDT)
In-Reply-To: <4BD2F69D.7070508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 24, 2010 at 9:48 AM, Ric Wheeler <rwheeler@redhat.com> wrot=
e:
> On 04/24/2010 09:24 AM, Greg Freemyer wrote:
>>
>> On Fri, Apr 23, 2010 at 4:23 AM, Lukas Czerner<lczerner@redhat.com>
>> =A0wrote:
>>
>>>
>>> On Wed, 21 Apr 2010, Greg Freemyer wrote:
>>>
>>>
>>>>>>>>>
>>>>>>>>> Mmm.. If that's what it is doing, then this patch set would b=
e a
>>>>>>>>> complete disaster.
>>>>>>>>> It would take *hours* to do the initial TRIM.
>>>>>>>>>
>>>>>
>>>>> Except it doesn't. =A0Lukas did provide numbers in his original e=
mail.
>>>>>
>>>>>
>>>>
>>>> Looking at the benchmarks (for the first time) at
>>>> http://people.redhat.com/jmoyer/discard/ext4_batched_discard/
>>>>
>>>> I don't see anything that says how long the proposed trim ioctl ta=
kes
>>>> to complete on the full filesystem.
>>>>
>>>
>>> Well, it strongly depends on how is the file system fragmented. On =
the
>>> fresh file system (147G) the initial ioctl takes 2 seconds to finis=
h (it
>>> may be worth to mention that on another SSD (111G) it takes 56s). I=
 will
>>> try to get some numbers for the "usual" file system (not full, not
>>> fresh).
>>>
>>>
>>>>
>>>> What they do show is that with the 3 test SSDs used for this
>>>> benchmark, the current released discard implementation is a net lo=
ss.
>>>> ie. You are better off running without the discards for all 3 vend=
ors.
>>>> =A0(at least under the conditions tested.)
>>>>
>>>> After the patch is applied and optimizing the discards to large fr=
ee
>>>> extents only, it works out to same performance with or without the
>>>> discards. =A0ie. no net gain or loss.
>>>>
>>>> That is extremely cool because one assumes that the non-discard ca=
se
>>>> would degrade over time, but that the discard case will not.
>>>>
>>>> So that argues for the current proposed patch going in.
>>>>
>>>> But quoting from the first email:
>>>>
>>>> =3D=3D
>>>> The basic idea behind my discard support is to create an ioctl whi=
ch
>>>> walks through all the free extents in each allocating group and di=
scard
>>>> those extents. As an addition to improve its performance one can s=
pecify
>>>> minimum free extent length, so ioctl will not bother with shorter
>>>> extents.
>>>>
>>>> This of course means, that with each invocation the ioctl must wal=
k
>>>> through whole file system, checking and discarding free extents, w=
hich
>>>> is not very efficient. The best way to avoid this is to keep track=
 of
>>>> deleted (freed) blocks. Then the ioctl have to trim just those fre=
e
>>>> extents which were recently freed.
>>>>
>>>> In order to implement this I have added new bitmap into ext4_group=
_info
>>>> (bb_bitmap_deleted) which stores recently freed blocks. The ioctl =
then
>>>> walk through bb_bitmap_deleted, compare deleted extents with free
>>>> extents trim them and then removes it from the bb_bitmap_deleted.
>>>>
>>>> But you may notice, that there is one problem. bb_bitmap_deleted d=
oes
>>>> not survive umount. To bypass the problem the first ioctl call hav=
e to
>>>> walk through whole file system trimming all free extents. But ther=
e is a
>>>> better solution to this problem. The bb_bitmap_deleted can be stor=
ed on
>>>> disk an can be restored in mount time along with other bitmaps, bu=
t I
>>>> think it is a quite big change and should be discussed further.
>>>> =3D=3D
>>>>
>>>> The above seems to argue against the patch going in until the
>>>> mount/umount issues are addressed.
>>>>
>>>
>>> I do not know much about how production system is being used, but I
>>> doubt this is that big issue. Sure the initial ioctl takes long to
>>> finish and there is a place for improvement, there was a proposal t=
o
>>> do the initial trim at mount time. I do not think that it is wise,
>>> why to block mount, when the trim can be run at background when the=
 fs
>>> is mounted ? Of course there will be some performance loss, while i=
octl
>>> will be in progress, but it will not block.
>>>
>>> There are also another way to overcome this problem. We can assure =
that
>>> the file system is left trimmed after umount. To do this, we can si=
mply
>>> trim the fs at umount time. I think this won't be any problem and w=
e even
>>> do not prolong the umount time too much, because we will not trim w=
hole
>>> fs, but just recently freed blocks.
>>>
>>> This of course bring another problem, when the system is not proper=
ly
>>> terminated and the umount is not properly finished (or done at all)=
=2E But
>>> this can be solved in fsck at boot time I think. This will entirely
>>> eliminate the need to trim the whole fs (except the fsck obviously)=
,
>>> since it is done when fs is created.
>>>
>>>
>>>>
>>>> So in addition to this patch, Lukas is proposing a on disk change =
to
>>>> address the fact that calling trim upteen times at mount time is t=
oo
>>>> slow.
>>>>
>>>> Per Mark's testing of last summer, an alternative solution is to u=
se a
>>>> vectored trim approach that is far more efficient.
>>>>
>>>
>>> Vectored trim will be great, I did not tested anything like that bu=
t
>>> obviously it will strongly reduce time needed to trim the fs. But w=
e do
>>> not have this support just yet.
>>>
>>>
>>>>
>>>> Mark's benchmarks showed this as doable in seconds which seems lik=
e a
>>>> reasonable amount of time for a mount time operation.
>>>>
>>>> Greg
>>>>
>>>>
>>>
>>> And also, currently I am rewriting the patch do use rbtree instead =
of the
>>> bitmap, because there were some concerns of memory consumption. It =
is a
>>> question whether or not the rbtree will be more memory friendly.
>>> Generally I think that in most "normal" cases it will, but there ar=
e some
>>> extreme scenarios, where the rbtree will be much worse. Any comment=
 on
>>> this ?
>>>
>>
>> I know I've been arguing against this patch for the single SSD case
>> and I still think that use case should be handled by userspace as
>> hdparm/wiper.sh currently does. =A0In particular for those extreme
>> scenarios with JBOD SSDs, the user space solution wins because it
>> knows how to optimize the trim calls via vectorized ranges in the
>> payload.
>>
>
> I think that you have missed the broader point. This is not on by def=
ault,
> so you can mount without discard and use whatever user space utility =
you
> like at your discretion.
>
> ric

Ric,

I was trying to say the design should be driven by the large discard
range use case, not the potentially pathological small discard range
use case that would only benefit SSDs.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
