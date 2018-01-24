From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH v6 3/4] vfs: Add timestamp_truncate() api
Date: Wed, 24 Jan 2018 09:47:13 -0800
Message-ID: <CABeXuvqfr7gFGv6s61Xa-Bhz4HQqL1FfzGT+5oVpOuTxo0wthg@mail.gmail.com>
References: <20180122020426.2988-1-deepa.kernel@gmail.com> <20180122020426.2988-4-deepa.kernel@gmail.com>
 <CA+55aFyNbcS8k3x1WrZ1-Ymtr6OpnCJ8NUZXBUCfacwWXYzC+g@mail.gmail.com>
 <CABeXuvogBWfTzteb8RFAGnW_HGLQX=hVUj0_SZ-TP1ZeNj=OHA@mail.gmail.com> <CAK8P3a2+WO70nUW4xAAW-Lmc9OzcjERhKm8zZiBTcscKWzocdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2+WO70nUW4xAAW-Lmc9OzcjERhKm8zZiBTcscKWzocdg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 24, 2018 at 3:56 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Jan 23, 2018 at 5:25 PM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>> On Mon, Jan 22, 2018 at 12:25 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Sun, Jan 21, 2018 at 6:04 PM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>>>> +               t.tv_nsec -= t.tv_nsec % gran;
>>>
>>> This doesn't actuall ywork if tv_nsec is negative.
>>
>> Right.
>>
>>> Which may not be an issue in most cases, but did somebody check
>>> utimensat() or whatever?
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
>
> which is the same as the Linux man page and what the kernel actually
> does for all the syscalls. The POSIX description seems a bit ambiguous
> to whether it also expects or allows EINVAL for utimes() with a tv_usec
> over 1000000 microseconds, or if it just applies to the utimensat and
> futimens(). Older descriptions that only explain utimes() don't mention
> the range check on tv_usec either.

Right. This is in keeping with the kernel implementation of the
corresponding syscalls.

But, this timespec_truncate() is being called from current_time() and
will be extended to other calls.

C99 says
"When integers are divided, the result of the / operator is the
algebraic quotient with any fractional part discarded (often called
"truncation toward zero"). If the quotient a/b is representable, the
expression (a/b)*b + a%b shall equal a."

Also, we are already checking for gran being non-zero and in the
nanoseconds range.

So I think the right answer here is to add a comment that the function
expects timespec to be normalized, and the functions calling it can
take care of validation.

-Deepa
