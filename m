From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 3/4] vfs: Add timestamp_truncate() api
Date: Tue, 30 Jan 2018 17:52:13 +0100
Message-ID: <CAK8P3a35yrUoN8jYaPfNYUWb45DPsKvGTMXnLPF1ut+mKmQVVw@mail.gmail.com>
References: <20180122020426.2988-1-deepa.kernel@gmail.com> <20180122020426.2988-4-deepa.kernel@gmail.com>
 <CA+55aFyNbcS8k3x1WrZ1-Ymtr6OpnCJ8NUZXBUCfacwWXYzC+g@mail.gmail.com>
 <CABeXuvogBWfTzteb8RFAGnW_HGLQX=hVUj0_SZ-TP1ZeNj=OHA@mail.gmail.com>
 <CAK8P3a2+WO70nUW4xAAW-Lmc9OzcjERhKm8zZiBTcscKWzocdg@mail.gmail.com> <CA+55aFy1Lue+txzoCDJF9XR2bCvWz0W5s0tB+XXQkyf2KaxiOg@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:42520 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbeA3QwO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Jan 2018 11:52:14 -0500
In-Reply-To: <CA+55aFy1Lue+txzoCDJF9XR2bCvWz0W5s0tB+XXQkyf2KaxiOg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 24, 2018 at 7:00 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jan 24, 2018 at 3:56 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tue, Jan 23, 2018 at 5:25 PM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>>>
>>> I checked POSIX again. There is no mention of tv_nsec being positive
>>> always for utimes.
>>> And, the long term plan is to replace all the callers of
>>> timespec_trunc() to use this new api instead for filesystems.
>>> So this will need to be fixed. I will fix this and post an update.
>>
>> I found this on
>> http://pubs.opengroup.org/onlinepubs/9699919799/functions/utimes.html
>>
>> ERRORS
>> These functions shall fail if:
>> ...
>> [EINVAL]
>>  Either of the times argument structures specified a tv_nsec value that was
>>  neither UTIME_NOW nor UTIME_OMIT, and was a value less than zero or
>>  greater than or equal to 1000 million.
>
> The thing is, we shouldn't check the standards, we should check what
> we actually _do_.

The issue for tv_sec is that we don't do anything interesting
at the moment, and that's bad.

- The Linux man page says we return -EINVAL for an out-of-range
  tv_sec, but the VFS code at the moment ends up running into an
  integer overflow, resulting in an arbitrary (i.e. file system specific)
  tv_sec when we read back a number that was set out of range.

- POSIX (IEEE Std 1003.1-2008) appears to say we should cap the
  tv_sec to the maximum supported value to update the inode /and/
  return -EINVAL, which seems better than what we do today, but
  would be surprising behavior, as -EINVAL usually indicates that we
  did not do anything.
  My best guess is that this is not intentional in the spec and should
  not be done like that.

- Deepa's patch implements a third option, which is to cap to the
  maximum (or minimum for times before the fs specific epoch)
  and keep always returning success for utimensat() etc.
  This seems the most reasonable behavior.

Between these three, we really need to make a decision.

> And what we actually _do_ is to have a tv_nsec that is of type "long",
> and while we do have a
>
>   timespec64_valid(const struct timespec64 *ts)
>
> and fs/utimes.c has a 'nsec_valid()' that apparently the utimes*
> family of system calls all do end up using, I'm more worried about
> something where we don't.
>
> Because I'm almost certain that we've had cases where we just
> normalize things after-the-fact.
>
> This all likely isn't a big deal, but it does end up worrying me if we
> then _depend_ on that granularity thing actually giving the proper
> granularity even for odd inputs. If they can happen.
>
> Maybe we don't care?

This part seems easy, while there are two aspects here, I think they
each have just one answer:

- truncating the nanoseconds in the in-memory inode to the resolution
  supported by the file system is currently done by Linux (since 2.6.10).
  This behavior matches the Linux and POSIX documentation and
  is sensible, so there is no reason to change it. Before 2.6.10, we could
  end up with a timestamp moving backwards when an inode got
  evicted from the icache and loaded back from disk.

- the range nsec validation is currently correct, I double-checked
  the relevant corner cases. We have to be careful when we introduce
  the 64-bit time_t based system call to make sure we can deal
  with glibc using 32-bit padding in the upper bits. For 64-bit user
  space, we must keep returning -EINVAL when those bits are
  nonzero, but for 32-bit tasks (compat or native), the current plan
  is to ignore the padding and instead take only the lower 32-bit
  before performing the range check. Deepa has posted patches
  for this in the past,  but that's a differnent series.

      Arnd
