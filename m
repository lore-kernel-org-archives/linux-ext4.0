From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Y2038 bug in ext4 recently_deleted() function
Date: Tue, 22 Aug 2017 17:18:14 +0200
Message-ID: <CAK8P3a2eY=yZM+mpUcFWHCD-DqSMvk+YtnVx1YAkJGbR_dXJTA@mail.gmail.com>
References: <20170808050517.7160-1-wshilong@ddn.com> <20170816164211.GA31117@quack2.suse.cz>
 <3ED34739A4E85E4F894367D57617CDEFEDA401CE@LAX-EX-MB2.datadirect.datadirectnet.com>
 <20170817091959.GB7644@quack2.suse.cz> <20170817092153.GA14074@quack2.suse.cz>
 <BCA34CA8-FDDF-49FA-A5B4-9CCCEAC0C8D0@dilger.ca> <CABeXuvqtDdtjgjEznXPgdUfaZiG-KJ3AURpT_AuUACcPATaoDw@mail.gmail.com>
 <CAK8P3a2mu9SGdZhWX59OhSK-fokSEpjKsK4_HC1OC-XxZU8eTw@mail.gmail.com>
 <CABeXuvpHvyOq09JQW0XtrJ4fGZNBjmC=MBDRS2eKoVsmpi3g4Q@mail.gmail.com> <AB3E8CB7-76CE-4F1D-B47C-57D63E56E6D7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Deepa Dinamani <deepa.kernel@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Wang Shilong <wshilong@ddn.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34774 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932815AbdHVPSP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Aug 2017 11:18:15 -0400
Received: by mail-oi0-f51.google.com with SMTP id j144so61048297oib.1
        for <linux-ext4@vger.kernel.org>; Tue, 22 Aug 2017 08:18:14 -0700 (PDT)
In-Reply-To: <AB3E8CB7-76CE-4F1D-B47C-57D63E56E6D7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 18, 2017 at 6:09 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>
>>>> So moving to the case of a 32 bit machine:
>>>>
>>>> get_seconds() can return values until year 2106. And, recentcy at max
>>>> can only be 35. Analyzing the current line:
>>>>
>>>> if (dtime && (dtime < now) && (now < dtime + recentcy))
>>>>
>>>> The above equation should work fine at least until 35 seconds before
>>>> y2038 deadline.
>>>
>>> Since it's all unsigned arithmetic, it should be fine until 2106.
>>> However, we should get rid of get_seconds() long before then
>>> and use ktime_get_real_seconds() instead, as most other users
>>> of get_seconds() are (more) broken.
>>
>> Dtime on disk representation again breaks this for certain values in
>> 2038 even though everything is unsigned.
>>
>> I was just saying that whatever we do here depends on how dtime on
>> disk is interpreted.
>>
>> Agree that ktime_get_real_seconds() should be used here. But, the way
>> we handle new values would rely on this new interpretation of dtime.
>> Also, using time64_t variables on stack only matters after this. Once
>> the types are corrected, maybe the comparison expression need not
>> change at all (after new dtime interpretation is in place).
>
> There will not be a new dtime format on disk, but since the calculation
> here only depends on relative times (within a few minutes), then it would
> be fine to use only 32-bit timestamps, and truncate off the high bits
> from get_seconds()/ktime_get_real_seconds().

Agreed.

Are you planning to apply your fix for it then? I think your first
suggestion is all we need, aside from the three  minor comments
I had.

       Arnd
