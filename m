From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: problem(?) in ext4 or mke2fs
Date: Sun, 03 Apr 2011 12:21:26 -0700
Message-ID: <4D98C8B6.7050806@redhat.com>
References: <BANLkTi=gE-utOo479RU8qcWM99NpBrFmvQ@mail.gmail.com> <4D98BF34.6040503@redhat.com> <BANLkTikZYqbjkTrZPAPFkhMcRnmJtuAzzw@mail.gmail.com> <4D98C2E0.3010808@redhat.com> <BANLkTimRJ95zd64CPckPu9RpRwHioJdVCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab1DCTVO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Apr 2011 15:21:14 -0400
In-Reply-To: <BANLkTimRJ95zd64CPckPu9RpRwHioJdVCA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/3/11 12:01 PM, Zeev Tarantov wrote:
> On Sun, Apr 3, 2011 at 21:56, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 4/3/11 11:52 AM, Zeev Tarantov wrote:
>>> If the filesystem created with the default options is slow or has
>>> higher cpu usage, it should be changed.
>>
>> I agree.  For actual striped storage, this makes it faster, but this
>> case is a problem; block-sized stripe width is never going to be good.
>> What device is this, exactly?
> 
> Look in linux-2.6/drivers/staging/zram/zram.txt

OK, so it does:

        /*
         * To ensure that we always get PAGE_SIZE aligned
         * and n*PAGE_SIZED sized I/O requests.
         */
        blk_queue_physical_block_size(zram->disk->queue, PAGE_SIZE);
        blk_queue_logical_block_size(zram->disk->queue,
                                        ZRAM_LOGICAL_BLOCK_SIZE);
        blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
        blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);

These are all documented in Documentation/ABI/testing/sysfs-block.

I don't think that setting all those values in zram is necessary and/or
sufficient to achieve what is desired in the comment.  io_min/io_opt
generally are set only for striped devices.

Still, mke2fsprogs should probably sanity-check for this; I'll make
sure this seems right, and send a patch.

Thanks,
-Eric

>> -Eric (losing my free airport wifi in about 8 minutes, so I may have
>> to continue this later...!)
>>
>>>> -Eric
>>>
>>> -Z.T.
>>

