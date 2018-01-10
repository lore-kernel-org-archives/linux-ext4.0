From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ext4: use strlcpy() instead of strncpy()
Date: Wed, 10 Jan 2018 22:30:15 +0100
Message-ID: <CAK8P3a1xGW+KmtaqQfuARTn2zwJ3J6fZrLqTchstJcvGPj_BEQ@mail.gmail.com>
References: <1515488319-23779-1-git-send-email-wangxiongfeng2@huawei.com>
 <20180109100655.bdbnsrvhceaimaxh@quack2.suse.cz> <eae3c8fd-d778-fa65-4609-5159a1a3b405@huawei.com>
 <20180109202003.GC5389@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:34103 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754036AbeAJVaQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jan 2018 16:30:16 -0500
Received: by mail-ot0-f181.google.com with SMTP id p16so397952otf.1
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jan 2018 13:30:16 -0800 (PST)
In-Reply-To: <20180109202003.GC5389@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 9, 2018 at 9:20 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jan 09, 2018 at 07:14:36PM +0800, Xiongfeng Wang wrote:
>>
>> Sorry, I didn't notice how s_last_error_func is used before.
>> We do waste one character if we use strlcpy() instead of strncpy().
>> We can't use memcpy() either. But I can't  figure out a better way to avoid
>> this warning.
>
> Compain to the GCC developers?   Create scripts that filter out crap?

This warning option appears to be particularly good in finding code that
is actually dangerous in case of an overflow, and generally using
strscpy() improves either correctness and readability over strncpy(),
I think it's worth leaving enabled globally.

I have an experimental patch series to let you wrap the _Pragma("GCC
diagnostic ingnored \"-Wstringop-truncation\"") directive in some
nicer syntax. Would that work for you here?

       Arnd
