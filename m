From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ditching e4b->alloc_semp
Date: Tue, 22 Feb 2011 22:02:39 +0200
Message-ID: <AANLkTi=a_p6euBjPsJJUgFp8cR+6tkHx4+iGjeTWAi2G@mail.gmail.com>
References: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
	<6F62599D-3EC9-421C-AAD2-CFA6204A5F8C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39478 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab1BVUCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Feb 2011 15:02:42 -0500
Received: by qwd7 with SMTP id 7so3191257qwd.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Feb 2011 12:02:40 -0800 (PST)
In-Reply-To: <6F62599D-3EC9-421C-AAD2-CFA6204A5F8C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 22, 2011 at 7:18 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-02-21, at 1:02 PM, Amir Goldstein wrote:
>> On Mon, Feb 14, 2011 at 11:22 PM, Amir Goldstein <amir73il@gmail.com=
> wrote:
>>> On Mon, Feb 14, 2011 at 9:58 PM, Ted Ts'o <tytso@mit.edu> wrote:
>>>
>>>> One thing that comes to mind about your question with the
>>>> e4b->alloc_semp causing problems. =A0If the only reason why we nee=
d it
>>>> is to protect against multiple attempts to initialize different bl=
ock
>>>> groups that share the same buddy bitmap, can we solve the problem =
by
>>>> ditching e4b->alloc_semp entirely, and simply using lock_page() on=
 the
>>>> buddy bitmap page to protect it?
>>>
>>> Perhaps. I imagine there is more than one elegant way to deal with =
that,
>>> but using a semaphore is not one of them.
>>> I will take a shot at evaporating e4b->alloc_semp.
>>
>> After looking at the code a bit, I find that the only critical resou=
rce
>> that several groups may share on a single page is the Uptodate flag,
>> which is used to indicate that the buddy cache for *all* these group=
s
>> is loaded and lock_page() and get_page() are used to protect it.
>>
>> There are 2 ways to eliminate this dependency:
>>
>> 1. (AKA easy lane) use a single page (or more) per block group.
>> this will increase the memory usage for 1K blocks fs and for 2K bloc=
k fs
>> on 8K page system, but are these use cases really that common?
>
> I think some distros may use 1kB block filesystems for root, where th=
ere are lots of small files. =A0I wonder if smolt would have this kind =
of info?
>
>> 2. (AKA hard lane) attach buffer heads to buddy page and use
>> buffer_uptodate() and buffer_lock() instead of PageUptodate() and lo=
ck_page()
>> to initialize buddy cache of groups that share the same page.
>>
>> What do you say?
>> Shall I take easy lane?
>
> For flex_bg filesystems, it would probably make even more sense to ju=
st load all of the bitmaps for that page, since it won't waste any more=
 memory or cause extra disk seeks. =A0I wonder what the memory vs. seek=
 performance tradeoff is for 1k filesystems to load all the bitmaps eve=
n for the non-flex_bg case (i.e. would the second bitmap have been load=
ed anyway in most cases)?
>

I'm sorry. I don't follow. I see how disk seeks can be avoided if we
load all bitmaps of a flex_bg,
but there can be no more than 2 groups on a page (4 on 8k system).
So what do I gain? My goal  is to remove the locking protection on
allocations from different block groups.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
