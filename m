From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ditching e4b->alloc_semp
Date: Mon, 21 Mar 2011 06:39:32 +0200
Message-ID: <AANLkTikw_XNkky0KYsJcmW_X3cC-DE89ddimFhQfmzL2@mail.gmail.com>
References: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
	<20110305160656.GA3505@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62562 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1CUEjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Mar 2011 00:39:33 -0400
Received: by qwk3 with SMTP id 3so3909145qwk.19
        for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 21:39:32 -0700 (PDT)
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

I didn't need to use EXT4_GROUP_INFO_BUDDY_INIT after all.
That state could be obtained from page uptodate bit.

See patches posted on the list.

Cheers,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
