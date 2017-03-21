From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: ext4 scaling limits ?
Date: Tue, 21 Mar 2017 16:28:47 -0700
Message-ID: <CAE0An6c40nF5v4km4tn-qzDZXptnfhPdYt=X=sBH-EKWB2=6RQ@mail.gmail.com>
References: <CAE0An6fc6tX6ACQYdTYdP+CwN=RDKuv_oaW0xeNrBLY_1AvOtw@mail.gmail.com>
 <32A4A230-566F-4476-A516-2C6C4BA5C1C6@dilger.ca> <e866a6ec-3f9c-0c8a-1547-5e8c5db9516e@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andreas Dilger <adilger@dilger.ca>,
        ext4 <linux-ext4@vger.kernel.org>
To: Reindl Harald <h.reindl@thelounge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:34138 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932568AbdCUX3T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Mar 2017 19:29:19 -0400
Received: by mail-vk0-f52.google.com with SMTP id z204so53598841vkd.1
        for <linux-ext4@vger.kernel.org>; Tue, 21 Mar 2017 16:29:13 -0700 (PDT)
In-Reply-To: <e866a6ec-3f9c-0c8a-1547-5e8c5db9516e@thelounge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 21, 2017 at 2:59 PM, Reindl Harald <h.reindl@thelounge.net> wrote:
>
>
> Am 21.03.2017 um 22:48 schrieb Andreas Dilger:
>>
>> While it is true that e2fsck does not free memory during operation, in
>> practice this is not a problem. Even for large filesystems (say 32-48TB)
>> it will only use around 8-12GB of RAM so that is very reasonable for a
>> server today.
>
>
> no it's not reasonable even today that your whole physical machine exposes
> it's total RAM to the one of many single virtual machines running just a
> samba server for a 50 TB "datagrave" with a handful of users
>
> in reality it should not be a problem to attach even a 100 TB storage to a
> VM with 1-2 GB
>

Thanks Andreas, for confirming.

If I understand correctly, then the theoretical limit is really (RAM +
available swap space) right ? Only if we aren't able to page out
anything to swap it should hurt ?


Thanks -
Manish



>
>> The rough estimate that I use for e2fsck is 1 byte of RAM per block.
>>
>> Cheers, Andreas
>>
>>> On Mar 21, 2017, at 16:07, Manish Katiyar <mkatiyar@gmail.com> wrote:
>>>
>>> Hi,
>>>
>>> I was looking at e2fsck code to see if there are any limits on running
>>> e2fsck on large ext4 filesystems. From the code it looks like all the
>>> required metadata while e2fsck is running is only kept in memory and
>>> is only flushed to disk when the appropriate changes are corrected.
>>> (Except the undo file case).
>>> There doesn't seem to be a case/code where we have to periodically
>>> flush some tracking metadata while it is running, just because we have
>>> too much of incore tracking data and may ran out of memory (looks like
>>> code will simply return failure if ext2fs_get_mem() returns failure)
>>>
>>> Appreciate if someone can confirm that my understanding is correct ?
