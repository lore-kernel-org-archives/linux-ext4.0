From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: Y2038 bug in ext4 recently_deleted() function
Date: Fri, 18 Aug 2017 08:38:01 -0700
Message-ID: <CABeXuvpHvyOq09JQW0XtrJ4fGZNBjmC=MBDRS2eKoVsmpi3g4Q@mail.gmail.com>
References: <20170808050517.7160-1-wshilong@ddn.com> <20170816164211.GA31117@quack2.suse.cz>
 <3ED34739A4E85E4F894367D57617CDEFEDA401CE@LAX-EX-MB2.datadirect.datadirectnet.com>
 <20170817091959.GB7644@quack2.suse.cz> <20170817092153.GA14074@quack2.suse.cz>
 <BCA34CA8-FDDF-49FA-A5B4-9CCCEAC0C8D0@dilger.ca> <CABeXuvqtDdtjgjEznXPgdUfaZiG-KJ3AURpT_AuUACcPATaoDw@mail.gmail.com>
 <CAK8P3a2mu9SGdZhWX59OhSK-fokSEpjKsK4_HC1OC-XxZU8eTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>, Wang Shilong <wshilong@ddn.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Jan Kara <jack@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:37430 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdHRPiC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Aug 2017 11:38:02 -0400
Received: by mail-io0-f172.google.com with SMTP id c74so34120260iod.4
        for <linux-ext4@vger.kernel.org>; Fri, 18 Aug 2017 08:38:02 -0700 (PDT)
In-Reply-To: <CAK8P3a2mu9SGdZhWX59OhSK-fokSEpjKsK4_HC1OC-XxZU8eTw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 18, 2017 at 2:31 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Fri, Aug 18, 2017 at 3:23 AM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>>> Strange, I never even knew recently_deleted() existed, even though it was
>>> added to the tree 4 years ago yesterday.  It looks like this is only used
>>> with the no-journal code, which I don't really interact with.
>>>
>>> One thing I did notice when looking at it is that there is a Y2038 bug in
>>> recently_deleted(), as it is comparing 32-bit i_dtime directly with 64-bit
>>> get_seconds().
>>
>> I don't think dtime has widened on the disk layout for ext4 according
>> to https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout. So I am
>> not sure how fixing the internal implementation would be useful until
>> we do that. Is there a plan for that?
>>
>> As far as get_seconds() is concerned, get_seconds() returns unsigned
>> long which is 64 bits on a 64 bit arch and 32 bit on a 32 bit arch.
>> Since dtime variable is declared as unsigned long in this function,
>> same holds for the size of this variable.
>>
>> There is no y2038 problem on a 64 bit machine.
>
> I think what Andreas was saying is that it's actually the opposite:
> on a 32-bit machine, the code will work correctly for 32-bit unsigned
> long values as long as 'dtime' and 'now' are in the same epoch,
> e.g. both are before 2106 or both are after.
> On 64-bit systems it's always wrong after 2106.

There is some confusion here.
I was only referring to the current implementation:

static int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
{
.
.
.
   unsigned long dtime, now;
   int offset, ret = 0, recentcy = RECENTCY_MIN;
.
.
.
    offset = (ino % inodes_per_block) * EXT4_INODE_SIZE(sb);
    raw_inode = (struct ext4_inode *) (bh->b_data + offset);
    dtime = le32_to_cpu(raw_inode->i_dtime);
    now = get_seconds();
    if (buffer_dirty(bh))
    recentcy += RECENTCY_DIRTY;

    if (dtime && (dtime < now) && (now < dtime + recentcy))
         ret = 1;
.
.
.
}

In the above implementation, I do not see any problem on a 64 bit machine.
The only problem is that dtime on disk representation is signed 32 bits only.
If that were not a problem then this would be fine from time prespective.

On 32 bit machine, dtime on disk representation again prevents it from
being able to represent times beyond 2038 unless one of the approaches
Ted mentioned is used to extend/ interpret it.

>> So moving to the case of a 32 bit machine:
>>
>> get_seconds() can return values until year 2106. And, recentcy at max
>> can only be 35. Analyzing the current line:
>>
>> if (dtime && (dtime < now) && (now < dtime + recentcy))
>>
>> The above equation should work fine at least until 35 seconds before
>> y2038 deadline.
>
> Since it's all unsigned arithmetic, it should be fine until 2106.
> However, we should get rid of get_seconds() long before then
> and use ktime_get_real_seconds() instead, as most other users
> of get_seconds() are (more) broken.

Dtime on disk representation again breaks this for certain values in
2038 even though everything is unsigned.

I was just saying that whatever we do here depends on how dtime on
disk is interpreted.

Agree that ktime_get_real_seconds() should be used here. But, the way
we handle new values would rely on this new interpretation of dtime.
Also, using time64_t variables on stack only matters after this. Once
the types are corrected, maybe the comparison expression need not
change at all(after new dtime interpretation is in place).

Let me know if I am missing something here.

-Deepa
