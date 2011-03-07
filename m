From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ditching e4b->alloc_semp
Date: Mon, 7 Mar 2011 07:52:40 +0200
Message-ID: <AANLkTimS8X+Mm70-atAL7sZkpTgpakO05KdSTG1h6vK8@mail.gmail.com>
References: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
	<20110305160656.GA3505@thunk.org>
	<AANLkTikW04brZ549=29N1Yan=GH29BN4WSVrA7erR_F6@mail.gmail.com>
	<20110307040810.GE11120@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52620 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1CGFwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Mar 2011 00:52:41 -0500
Received: by qyk7 with SMTP id 7so1711991qyk.19
        for <linux-ext4@vger.kernel.org>; Sun, 06 Mar 2011 21:52:41 -0800 (PST)
In-Reply-To: <20110307040810.GE11120@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 7, 2011 at 6:08 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Mar 06, 2011 at 10:15:41PM +0200, Amir Goldstein wrote:
>>
>> That sounds about right, but why do I need a new bit?
>> Why can't I use EXT4_GROUP_INFO_NEED_INIT_BIT to tell me the exact
>> same thing?
>
> The current meaning of NEED_INIT_BIT is that it indicates that the
> group has been initialized once since the file system has been
> mounted. =A0It is used by ext4_mb_good_group() to know whether it can
> rely on ext4_group_info->bb_free, ext4_group_info->bb_fragments,
> ext4_group_info->bb_largest_free_order, et. al, without needing to
> reload the buddy bitmap.
>
> We added this so that even if memory pressure has forced the buddy
> bitmap and block allocation bitmaps out of memory, we have enough
> information in the ext4_group_info summary array that we can quickly
> decide whether or not a group is a likely good candidate to be
> examined more closely to have the necessary free blocks. =A0Without t=
his
> (relatively recent) change, the mballoc code might potentially need t=
o
> read in tens if not hundreds of block allocation bitmaps only to find
> that it didn't have enough contiguous blocks, and then the memory
> pressure would push the block bitmap out of memory again.... and file
> system performance would go into the toilet.
>

Right... we need it.
I also wanted to examine if clearing the NEED_INIT_BIT on add_group_blo=
cks
is really necessary.
Couldn't the buddy bitmap of partial group be initialized with all
blocks at the end
"used", similar to the block bitmap itself?
Then add_group_blocks() could just "free" the extra added blocks.

>
> So we don't want to disturb the meaning of this particular bit. =A0If=
 we
> zap the NEED_INIT_BIT whenever we discover that the group's buddy
> bitmap page has been pushed out of memory, then we will once again
> need to read in massive numbers of block bitmaps because clearing the
> bit effectively marks the summary information stored ext4_group_info
> structure as invalid.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
