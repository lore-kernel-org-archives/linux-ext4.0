From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [RFC 0/6] vfs: Add timestamp range check support
Date: Sun, 6 Nov 2016 13:14:05 -0800
Message-ID: <CABeXuvq5LyREPV1OqFvXb7HKXxQ9hQBh4G5oYTg-jchRwKa-EA@mail.gmail.com>
References: <1478099096-25637-1-git-send-email-deepa.kernel@gmail.com>
 <1206C36E-9CB4-47B3-A891-8EA94C3220E0@dilger.ca> <CABeXuvoCANJohBWy4mpJFiYvJj0XNHKVpW1RWhXVrd9ZjT5FSQ@mail.gmail.com>
 <147897712.8Iuj6e9dPp@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        linux-afs@lists.infradead.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34498 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbcKFVOG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Nov 2016 16:14:06 -0500
In-Reply-To: <147897712.8Iuj6e9dPp@wuerfel>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 6, 2016 at 12:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday, November 6, 2016 9:44:33 AM CET Deepa Dinamani wrote:
>> I will post xfs tests that validate mount and range checking.
>> I will keep the policy same as what the RFC suggests for now.
>>
>> Clamping can be verified once vfs is transitioned to using time64_t.
>
> Won't it already work as expected on 64-bit architectures as they
> have a 64-bit time_t?

Yes, on 64 bit architectures, it should work fine.
32 bit machines will have wrong clamped timestamps though for some filesystems.

I can post a test for clamping that only works on 64 bit machines.

Thanks,
-Deepa
