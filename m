From: Paul Gortmaker <paul.gortmaker@gmail.com>
Subject: Re: [PATCH 1/4] jbd2/journal_commit_transaction: relocate state lock
 to incorporate all users
Date: Mon, 10 Jun 2013 22:45:50 -0400
Message-ID: <CAP=VYLroGDmJLPvb3RL+FRN_F+zMBOdMyY8GpnLt2vVYE+900Q@mail.gmail.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370892723-30860-2-git-send-email-paul.gortmaker@windriver.com> <20130611021230.GA23966@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20130611021230.GA23966@thunk.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 10, 2013 at 10:12 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 10, 2013 at 03:32:00PM -0400, Paul Gortmaker wrote:
>> The state lock is taken after we are doing an assert on the state
>> value, not before.  It is also taken after the jbd_debug() call.
>> Noting that jbd_debug() is implemented with two separate printk()
>> calls, it can lead to corrupted and misleading debug output like
>> the following (see lines marked with "*"):
>
> This is only a cosmetic fix, but instead of trying to fix it by moving
> a lock --- which would only fix this issue, but there are probably
> others cases where this might be an issue, I'd suggest fixing it with
> something like this:
>
> /* in fs/jbd2/journal.c */
> void __jbd2_debug(int level, const char *func, unsigned int line, const char *fmt, ...)
> {
>         struct va_format vaf;
>         va_list args;
>
>         if (level < jbd2_journal_enable_debug)
>                 return;
>         va_start(args, fmt);
>         vaf.fmt = fmt;
>         vaf.va = &args
>         printk(KERN_DEBUG, "jbd2: (%s, %u): %pV\n", func, line, &vaf);
>         va_end(args);
> }
>
> /* in jbd2.h */
>
> #define jbd_debug(n, fmt, a...) __jbd2_debug((n), __func__, __LINE__, (fmt), ##a)
>
> Could you give this approach a try?

Sure, I will do so tomorrow -  but since it can't be reproduced
on-demand, all I'll be able to do is to watch for independent
calls with very close time stamps, and confirm they were not
interleaved.

What about the state assert being done outside of the state
lock?   Should I keep that as a separate patch so that the
assert isn't checking what could possibly be a transient value?

Thanks,
Paul.
--

>
> Thanks,
>
>                                                         - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
