From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: [PATCH 2/2] ext4: Remove code duplication in ext4_get_block_write_nolock()
Date: Fri, 9 Nov 2012 09:51:35 -0800
Message-ID: <CAOMFOmX8RfzxpwV2OhYQnMTezjwHQLGAV-za7wz3gRSNv88iFg@mail.gmail.com>
References: <1350328009-22740-1-git-send-email-anatol.pomozov@gmail.com>
	<1350328009-22740-2-git-send-email-anatol.pomozov@gmail.com>
	<20121109172957.GA19041@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: wenqing.lz@taobao.com, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50545 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2KIRvg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Nov 2012 12:51:36 -0500
Received: by mail-lb0-f174.google.com with SMTP id n3so3226973lbo.19
        for <linux-ext4@vger.kernel.org>; Fri, 09 Nov 2012 09:51:35 -0800 (PST)
In-Reply-To: <20121109172957.GA19041@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

On Fri, Nov 9, 2012 at 9:29 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> There's a really serious bug in this patch which I didn't notice at
> first:
>
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -683,7 +683,7 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
>>       map.m_lblk = iblock;
>>       map.m_len = bh->b_size >> inode->i_blkbits;
>>
>> -     if (flags && !handle) {
>> +     if (flags && !(flags | EXT4_GET_BLOCKS_NO_LOCK) && !handle) {
>                             ^^^
>
> This should obviously read:
>
>         if (flags && !(flags & EXT4_GET_BLOCKS_NO_LOCK) && !handle) {

D'oh... You are right..

> Otherwise xfstests #91 will blow out with a circular lockdep warning.
>
> As a reminder, please do make sure you compile with lockdep enabled
> when you run your tests; it's found more than one bug for me!

I though I tested with and without debug options enabled. Maybe I
missed lockdep option somehow, next time i'll make sure that it is
enabled.

Thanks for catching it.

>
>                                               - Ted
