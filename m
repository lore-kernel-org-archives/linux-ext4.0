From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Y2038 bug in ext4 recently_deleted() function
Date: Fri, 18 Aug 2017 11:31:25 +0200
Message-ID: <CAK8P3a2mu9SGdZhWX59OhSK-fokSEpjKsK4_HC1OC-XxZU8eTw@mail.gmail.com>
References: <20170808050517.7160-1-wshilong@ddn.com> <20170816164211.GA31117@quack2.suse.cz>
 <3ED34739A4E85E4F894367D57617CDEFEDA401CE@LAX-EX-MB2.datadirect.datadirectnet.com>
 <20170817091959.GB7644@quack2.suse.cz> <20170817092153.GA14074@quack2.suse.cz>
 <BCA34CA8-FDDF-49FA-A5B4-9CCCEAC0C8D0@dilger.ca> <CABeXuvqtDdtjgjEznXPgdUfaZiG-KJ3AURpT_AuUACcPATaoDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>, Wang Shilong <wshilong@ddn.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Jan Kara <jack@suse.cz>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36281 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbdHRJb1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Aug 2017 05:31:27 -0400
Received: by mail-oi0-f41.google.com with SMTP id g131so91060699oic.3
        for <linux-ext4@vger.kernel.org>; Fri, 18 Aug 2017 02:31:27 -0700 (PDT)
In-Reply-To: <CABeXuvqtDdtjgjEznXPgdUfaZiG-KJ3AURpT_AuUACcPATaoDw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 18, 2017 at 3:23 AM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>> Strange, I never even knew recently_deleted() existed, even though it was
>> added to the tree 4 years ago yesterday.  It looks like this is only used
>> with the no-journal code, which I don't really interact with.
>>
>> One thing I did notice when looking at it is that there is a Y2038 bug in
>> recently_deleted(), as it is comparing 32-bit i_dtime directly with 64-bit
>> get_seconds().
>
> I don't think dtime has widened on the disk layout for ext4 according
> to https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout. So I am
> not sure how fixing the internal implementation would be useful until
> we do that. Is there a plan for that?
>
> As far as get_seconds() is concerned, get_seconds() returns unsigned
> long which is 64 bits on a 64 bit arch and 32 bit on a 32 bit arch.
> Since dtime variable is declared as unsigned long in this function,
> same holds for the size of this variable.
>
> There is no y2038 problem on a 64 bit machine.

I think what Andreas was saying is that it's actually the opposite:
on a 32-bit machine, the code will work correctly for 32-bit unsigned
long values as long as 'dtime' and 'now' are in the same epoch,
e.g. both are before 2106 or both are after.

On 64-bit systems it's always wrong after 2106.

> So moving to the case of a 32 bit machine:
>
> get_seconds() can return values until year 2106. And, recentcy at max
> can only be 35. Analyzing the current line:
>
> if (dtime && (dtime < now) && (now < dtime + recentcy))
>
> The above equation should work fine at least until 35 seconds before
> y2038 deadline.

Since it's all unsigned arithmetic, it should be fine until 2106.
However, we should get rid of get_seconds() long before then
and use ktime_get_real_seconds() instead, as most other users
of get_seconds() are (more) broken.

Looking at the two suggested approaches:

>>        u32 now, dtime;
>>
>>        /* assume dtime is within the past 30 years, see time_after() */
>>        now = get_seconds();
>>        if (dtime && (dtime - now < 0) && (dtime + recentcy - now < 0))
>>                ret = 1;

* As 'dtime' and 'now' are both unsigned, subtracting them will also result
  in an unsigned value that is never less than zero, so it won't work.
  Adding a cast to 's32' would fix that the same way that time_after() does.

* please use ktime_get_real_seconds() instead of get_seconds(), so we
   don't have to replace it later.

* The comment should say '68 years', not 30.

> or use i_ctime_extra to implicitly extend i_dtime beyond 2038, something like:
>
>        /* assume dtime epoch same as ctime, see EXT4_INODE_GET_XTIME() */
>        dtime = le32_to_cpu(raw_inode->i_dtime);
>        if (EXT4_INODE_SIZE(sb) > EXT4_GOOD_OLD_INODE_SIZE &&
>            offsetof(typeof(*raw_inode), i_ctime_extra) + 4 <=
>            EXT4_GOOD_OLD_INODE_SIZE + le32_to_cpu(raw_inode->i_extra_isize))
>                dtime += (long)(le32_to_cpu(raw_inode->i_ctime_extra) &
>                                EXT4_EPOCH_MASK) << 32;

* This is slightly incorrect when we are close to the epoch boundary, as i_ctime
  and i_dtime might end up being in different epochs. I would not go there.

* If we were to pick this approach, a cast to 'long' is obviously wrong on
  32-bit systems, better use 'u64' or 'time64_t'.

     Arnd
