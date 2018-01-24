From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v6 3/4] vfs: Add timestamp_truncate() api
Date: Wed, 24 Jan 2018 10:00:45 -0800
Message-ID: <CA+55aFy1Lue+txzoCDJF9XR2bCvWz0W5s0tB+XXQkyf2KaxiOg@mail.gmail.com>
References: <20180122020426.2988-1-deepa.kernel@gmail.com> <20180122020426.2988-4-deepa.kernel@gmail.com>
 <CA+55aFyNbcS8k3x1WrZ1-Ymtr6OpnCJ8NUZXBUCfacwWXYzC+g@mail.gmail.com>
 <CABeXuvogBWfTzteb8RFAGnW_HGLQX=hVUj0_SZ-TP1ZeNj=OHA@mail.gmail.com> <CAK8P3a2+WO70nUW4xAAW-Lmc9OzcjERhKm8zZiBTcscKWzocdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:36658 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964826AbeAXSAq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jan 2018 13:00:46 -0500
In-Reply-To: <CAK8P3a2+WO70nUW4xAAW-Lmc9OzcjERhKm8zZiBTcscKWzocdg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 24, 2018 at 3:56 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Jan 23, 2018 at 5:25 PM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>>
>> I checked POSIX again. There is no mention of tv_nsec being positive
>> always for utimes.
>> And, the long term plan is to replace all the callers of
>> timespec_trunc() to use this new api instead for filesystems.
>> So this will need to be fixed. I will fix this and post an update.
>
> I found this on
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/utimes.html
>
> ERRORS
> These functions shall fail if:
> ...
> [EINVAL]
>  Either of the times argument structures specified a tv_nsec value that was
>  neither UTIME_NOW nor UTIME_OMIT, and was a value less than zero or
>  greater than or equal to 1000 million.

The thing is, we shouldn't check the standards, we should check what
we actually _do_.

And what we actually _do_ is to have a tv_nsec that is of type "long",
and while we do have a

  timespec64_valid(const struct timespec64 *ts)

and fs/utimes.c has a 'nsec_valid()' that apparently the utimes*
family of system calls all do end up using, I'm more worried about
something where we don't.

Because I'm almost certain that we've had cases where we just
normalize things after-the-fact.

This all likely isn't a big deal, but it does end up worrying me if we
then _depend_ on that granularity thing actually giving the proper
granularity even for odd inputs. If they can happen.

Maybe we don't care?

                 Linus
