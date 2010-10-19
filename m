From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: linux-2.6-block/for-next: Removal of BLKDEV_IFL_BARRIER and BLKDEV_IFL_WAIT
Date: Tue, 19 Oct 2010 14:12:11 +0200
Message-ID: <AANLkTimY3Yp9rMfCVz-N-urC864ADhnH026yLvCvF6uV@mail.gmail.com>
References: <AANLkTi=EiCvRxAqnbWoPMhqYAZDQmsjaDRt+0dK-fRcV@mail.gmail.com>
	<4CBBF382.4000505@kernel.dk>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49857 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363Ab0JSMMN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Oct 2010 08:12:13 -0400
Received: by gxk21 with SMTP id 21so665138gxk.19
        for <linux-ext4@vger.kernel.org>; Tue, 19 Oct 2010 05:12:12 -0700 (PDT)
In-Reply-To: <4CBBF382.4000505@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linux-next patch from [1] has both tree merged and resolved the conflicts.

I could successfully compile it, now.

$ cat /proc/version
Linux version 2.6.36-rc8-686 (Debian
2.6.36~rc8-3~next~20101018~dileks.1) (sedat.dilek@gmail.com) (gcc
version 4.4.5 (Debian 4.4.5-4) ) #1 SMP Tue Oct 19 00:38:54 CEST 2010

- Sedat -

[1] http://www.kernel.org/pub/linux/kernel/v2.6/next/patch-v2.6.36-rc8-next-20101018.bz2

On Mon, Oct 18, 2010 at 9:13 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2010-10-18 02:11, Sedat Dilek wrote:
>> Hi,
>>
>> today, I pulled linux-2.6-block/for-next GIT branch [1] on top of
>> Linus-tree (2.6.36-rc8-git3).
>>
>> Unfortunately, ext4/next GIT branch [2] is not "GIT-pull-able" on top
>> of this local GIT repository.
>> The cause for this is the removal of BLKDEV_IFL_BARRIER and
>> BLKDEV_IFL_WAIT in linux-2.6-block/for-next.
>>
>> As there are few days left for 2.6.36-final, it would be great when
>> ext4/next could be prepared to work with linux-2.6-block/for-next.
>> Thanks in advance.
>
> The argument just has to be removed. linux-next has had a fixup
> patch for this for a long time.
>
> --
> Jens Axboe
>
>
