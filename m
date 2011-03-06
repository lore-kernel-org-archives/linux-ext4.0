From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ditching e4b->alloc_semp
Date: Sun, 6 Mar 2011 22:15:41 +0200
Message-ID: <AANLkTikW04brZ549=29N1Yan=GH29BN4WSVrA7erR_F6@mail.gmail.com>
References: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
	<20110305160656.GA3505@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46579 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1CFUPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Mar 2011 15:15:42 -0500
Received: by qwd7 with SMTP id 7so2761898qwd.19
        for <linux-ext4@vger.kernel.org>; Sun, 06 Mar 2011 12:15:42 -0800 (PST)
In-Reply-To: <20110305160656.GA3505@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 5, 2011 at 6:06 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Feb 21, 2011 at 10:02:44PM +0200, Amir Goldstein wrote:
>>
>> 1. (AKA easy lane) use a single page (or more) per block group.
>> this will increase the memory usage for 1K blocks fs and for 2K bloc=
k fs
>> on 8K page system, but are these use cases really that common?
>
> The most common use cases will be 4k block file system on 16k page
> systems, which show up on PowerPC and Itanium systems.

OK. no easy way out.

>
>> 2. (AKA hard lane) attach buffer heads to buddy page and use
>> buffer_uptodate() and buffer_lock() instead of PageUptodate() and lo=
ck_page()
>> to initialize buddy cache of groups that share the same page.
>
> How about this; use lock_page() to guarantee exclusive access to the
> shared buddy bitmap, and then define a new bit in
> ext4_group_info->bb_state to indicate whether or not a particular
> block group has been initialized. =A0If the page has gotten flushed f=
rom
> memory, so that it is not present at all (i.e., find_get_page returns
> NULL), then iterate over all of the groups to clear the
> EXT4_GROUP_INFO_BUDDY_INIT bit.
>
> If the page is returned by find_get_page(), then all you need to do i=
s
> check the EXT4_GROUP_INFO_BUDDY_INIT bit to discover whether or not o=
r
> not the buddy bitmap needs to be initialized.
>

That sounds about right, but why do I need a new bit?
Why can't I use EXT4_GROUP_INFO_NEED_INIT_BIT to tell me the exact same=
 thing?
The only difference from current implementation is that I would have
to test the bit again
after taking page_lock().

I didn't have time to check the implementation into details yet.
I will try to get to it during this week and send a tryout patch.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
