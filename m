From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: ext4 scaling limits ?
Date: Tue, 21 Mar 2017 22:59:18 +0100
Message-ID: <e866a6ec-3f9c-0c8a-1547-5e8c5db9516e@thelounge.net>
References: <CAE0An6fc6tX6ACQYdTYdP+CwN=RDKuv_oaW0xeNrBLY_1AvOtw@mail.gmail.com>
 <32A4A230-566F-4476-A516-2C6C4BA5C1C6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>,
        Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.thelounge.net ([91.118.73.15]:56661 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758127AbdCUWSD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Mar 2017 18:18:03 -0400
In-Reply-To: <32A4A230-566F-4476-A516-2C6C4BA5C1C6@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Am 21.03.2017 um 22:48 schrieb Andreas Dilger:
> While it is true that e2fsck does not free memory during operation, in
> practice this is not a problem. Even for large filesystems (say 32-48TB)
> it will only use around 8-12GB of RAM so that is very reasonable for a
> server today.

no it's not reasonable even today that your whole physical machine 
exposes it's total RAM to the one of many single virtual machines 
running just a samba server for a 50 TB "datagrave" with a handful of users

in reality it should not be a problem to attach even a 100 TB storage to 
a VM with 1-2 GB

> The rough estimate that I use for e2fsck is 1 byte of RAM per block.
>
> Cheers, Andreas
>
>> On Mar 21, 2017, at 16:07, Manish Katiyar <mkatiyar@gmail.com> wrote:
>>
>> Hi,
>>
>> I was looking at e2fsck code to see if there are any limits on running
>> e2fsck on large ext4 filesystems. From the code it looks like all the
>> required metadata while e2fsck is running is only kept in memory and
>> is only flushed to disk when the appropriate changes are corrected.
>> (Except the undo file case).
>> There doesn't seem to be a case/code where we have to periodically
>> flush some tracking metadata while it is running, just because we have
>> too much of incore tracking data and may ran out of memory (looks like
>> code will simply return failure if ext2fs_get_mem() returns failure)
>>
>> Appreciate if someone can confirm that my understanding is correct ?
