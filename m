From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ditching e4b->alloc_semp
Date: Wed, 23 Feb 2011 11:54:55 +0200
Message-ID: <AANLkTimb2qcAaxO8MTbbhNcf2bjfy8Q+6RCCdpQ3p_bX@mail.gmail.com>
References: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
	<6F62599D-3EC9-421C-AAD2-CFA6204A5F8C@dilger.ca>
	<AANLkTi=a_p6euBjPsJJUgFp8cR+6tkHx4+iGjeTWAi2G@mail.gmail.com>
	<6A9C4ED7-C0FF-4232-8E2D-D76855021E87@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49677 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1BWJy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 04:54:58 -0500
Received: by qwd7 with SMTP id 7so3586752qwd.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Feb 2011 01:54:57 -0800 (PST)
In-Reply-To: <6A9C4ED7-C0FF-4232-8E2D-D76855021E87@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 22, 2011 at 11:00 PM, Andreas Dilger <adilger@dilger.ca> wr=
ote:
> On 2011-02-22, at 1:02 PM, Amir Goldstein wrote:
>> On Tue, Feb 22, 2011 at 7:18 PM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>>> On 2011-02-21, at 1:02 PM, Amir Goldstein wrote:
>>>> After looking at the code a bit, I find that the only critical res=
ource
>>>> that several groups may share on a single page is the Uptodate fla=
g,
>>>> which is used to indicate that the buddy cache for *all* these gro=
ups
>>>> is loaded and lock_page() and get_page() are used to protect it.
>>>>
>>>> There are 2 ways to eliminate this dependency:
>>>>
>>>> 1. (AKA easy lane) use a single page (or more) per block group.
>>>> this will increase the memory usage for 1K blocks fs and for 2K bl=
ock fs
>>>> on 8K page system, but are these use cases really that common?
>>>
>>> I think some distros may use 1kB block filesystems for root, where =
there are lots of small files. =A0I wonder if smolt would have this kin=
d of info?
>>>
>>>> 2. (AKA hard lane) attach buffer heads to buddy page and use
>>>> buffer_uptodate() and buffer_lock() instead of PageUptodate() and =
lock_page()
>>>> to initialize buddy cache of groups that share the same page.
>>>>
>>>> What do you say?
>>>> Shall I take easy lane?
>>>
>>> For flex_bg filesystems, it would probably make even more sense to =
just load all of the bitmaps for that page, since it won't waste any mo=
re memory or cause extra disk seeks. =A0I wonder what the memory vs. se=
ek performance tradeoff is for 1k filesystems to load all the bitmaps e=
ven for the non-flex_bg case (i.e. would the second bitmap have been lo=
aded anyway in most cases)?
>>
>> I'm sorry. I don't follow. I see how disk seeks can be avoided if we
>> load all bitmaps of a flex_bg,
>> but there can be no more than 2 groups on a page (4 on 8k system).
>> So what do I gain? My goal =A0is to remove the locking protection on
>> allocations from different block groups.
>
> My point was that the locking is necessary because we may be loading =
multiple bitmaps into a single page at different times, making it diffi=
cult to set PageUptodate at one time. =A0However, with flex_bg it is po=
ssible to read both bitmap blocks into the same page at one time withou=
t noticeably hurting performance, and possibly even improving performan=
ce due to reduced disk operations. =A0Without flex_bg the benefit of re=
ading all the bitmaps into a page at one time is less clear, because it=
 would seek to read each bitmap.
>

I'm afraid the the details of buddy cache initialization are a bit more=
 complex
than the level of our discussion and you may be referring to other lock=
s then
the ones I am referring to (there are several levels of lockings).

I am trying to ditch the holding of down_read(grp->alloc_sem) throughou=
t the
time that buddy is loaded,
because I find it to be an overkill and it interferes with snapshots CO=
W.

In both options (i.e. easy lane or hard lane above), the page_lock() wi=
ll be
held during ext4_mb_init_cache() and down_write(grp->alloc_sem) of the =
group
ITSELF will be held during ext4_mb_init_group().
In the buddy page buffers option, it is possible to read all blocks of =
the same
page at the same time and mark all buddy page buffers uptodate.
Other groups on the same page will be able to skip the read from disk, =
go
straight to initializing phase and mark the buddy page buffers bitmap_u=
ptodate
on completion.

ext4_mb_load_buddy() would then check for !buffer_bitmap_uptodate() ins=
tead
of !PageUptodate(), before calling ext4_mb_init_cache().

It's a bit complicated to explain without a patch and I will get to it.=
=2E.
I only wanted to know if I can take easy lane, since it is a lot less w=
ork
and I was not sure the little memory saved for 1K block fs is worth tha=
t work.

Easy lane will also be simplifying mballoc.c and reduce lines, whereas
hard lane is
likely to add more lines that it removes.

Ted, can you please comment on the easy vs. hard choice?

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
