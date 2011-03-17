From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ditching e4b->alloc_semp
Date: Thu, 17 Mar 2011 18:13:49 +0200
Message-ID: <AANLkTima8ZC99JAQvcZQ=WuCyZgWCdVzg3qkLpZ7+_eq@mail.gmail.com>
References: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
	<20110305160656.GA3505@thunk.org>
	<AANLkTikW04brZ549=29N1Yan=GH29BN4WSVrA7erR_F6@mail.gmail.com>
	<20110307040810.GE11120@thunk.org>
	<AANLkTimS8X+Mm70-atAL7sZkpTgpakO05KdSTG1h6vK8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51989 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab1CQQNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Mar 2011 12:13:50 -0400
Received: by qyg14 with SMTP id 14so2626349qyg.19
        for <linux-ext4@vger.kernel.org>; Thu, 17 Mar 2011 09:13:49 -0700 (PDT)
In-Reply-To: <AANLkTimS8X+Mm70-atAL7sZkpTgpakO05KdSTG1h6vK8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 7, 2011 at 7:52 AM, Amir Goldstein <amir73il@gmail.com> wro=
te:
> On Mon, Mar 7, 2011 at 6:08 AM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Sun, Mar 06, 2011 at 10:15:41PM +0200, Amir Goldstein wrote:
>>>
>>> That sounds about right, but why do I need a new bit?
>>> Why can't I use EXT4_GROUP_INFO_NEED_INIT_BIT to tell me the exact
>>> same thing?
>>
>> The current meaning of NEED_INIT_BIT is that it indicates that the
>> group has been initialized once since the file system has been
>> mounted. =A0It is used by ext4_mb_good_group() to know whether it ca=
n
>> rely on ext4_group_info->bb_free, ext4_group_info->bb_fragments,
>> ext4_group_info->bb_largest_free_order, et. al, without needing to
>> reload the buddy bitmap.
>>
>> We added this so that even if memory pressure has forced the buddy
>> bitmap and block allocation bitmaps out of memory, we have enough
>> information in the ext4_group_info summary array that we can quickly
>> decide whether or not a group is a likely good candidate to be
>> examined more closely to have the necessary free blocks. =A0Without =
this
>> (relatively recent) change, the mballoc code might potentially need =
to
>> read in tens if not hundreds of block allocation bitmaps only to fin=
d
>> that it didn't have enough contiguous blocks, and then the memory
>> pressure would push the block bitmap out of memory again.... and fil=
e
>> system performance would go into the toilet.
>>
>
> Right... we need it.
> I also wanted to examine if clearing the NEED_INIT_BIT on add_group_b=
locks
> is really necessary.
> Couldn't the buddy bitmap of partial group be initialized with all
> blocks at the end
> "used", similar to the block bitmap itself?
> Then add_group_blocks() could just "free" the extra added blocks.
>

I have started to look into removing down_write(&grp->alloc_sem) from
ext4_add_group_blocks(), because until I remove it, I won't be able to =
get rid
of down_read(&e4b->alloc_semp) and I don't see how I can use the page_l=
ock()
and grp->bb_state bits semantics alone.

As long as the NEED_INIT_BIT is a clear-only flag the semantics work,
but when ext4_add_group_blocks() sets the bit, we may have a task holdi=
ng
a reference to buddy page and another trying to initialize it (under pa=
ge_lock).
I don't suppose you meant holding page_lock() for the entire allocation=
=2E

So unless you have a better idea, I will try to implement the "add grou=
p blocks
by freeing them" paradigm.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
