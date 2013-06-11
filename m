From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [RFC PATCH 0/4] ext4/jbd2: several possible mainline fixes
Date: Mon, 10 Jun 2013 23:09:45 -0400
Message-ID: <CAP=VYLo5yCaMVRHMe2tHON6OEC8X6FWxGeh1N+qQXSbUm2btqA@mail.gmail.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com> <20130610233850.GA21795@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:34219 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3FKDKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jun 2013 23:10:17 -0400
In-Reply-To: <20130610233850.GA21795@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 10, 2013 at 7:38 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 10, 2013 at 03:31:59PM -0400, Paul Gortmaker wrote:
>> Using jbd_debug() it seems that I end up with jbd2_log_do_checkpoint
>> and jbd2_journal_commit_transaction running into each other.  In one of
>> my attached patches, I show they overlap to the point of interrupting
>> each others jbd_debug messages.  Maybe that doesn't matter?
>
> That should be OK.  We do allow a new transactions while we are
> committing an older transaction, and if this requires more space, a
> checkpoint could start.  I'm not sure why you're apparently seeing a
> deadlock under RT-linux, though.
>
>> Stuck waiting/spinning somewhere in jbd2_journal_commit_transaction.
>> As near as I can tell, it never got to phase 3 of commit_transaction.
>>
>> Since jbd2_journal_commit_transaction is such a large function,
>> I'm tempted to break it up some, just to ease my debugging (compare
>> 0x1c20 to the smaller numbers around it).  Perhaps there would be
>> interest in such kinds of patches for mainline?
>
> Instead of breaking it up, can you just use addr2line, i.e.:
>
> % addr2line -a ffffffff8046a067 -i -e vmlinux
> 0xffffffff8046a067
> ./include/linux/buffer_head.h:287
> ./fs/ext4/inode.c:5585
> ./fs/ext4/inode.c:5963
>
> I find this to be incredibly useful, since with the -i option it will
> handle inline functions correctly.  In the above example there are two

Thanks, I wasn't aware of the "-i" -- and had simply been using
gdb directly with "l *jbd2_journal_commit_transaction+0x<offset>"
which shows what inline we were in, but it still wasn't clear to me
yet what was going on, that we were stuck there.

> levels of inlining, one explicitly marked inline in
> include/linux/buffer.h, and one implicit inlining taking place because
> we had a static function in fs/ext4/inode.c that was only called by
> one caller.
>
> Because of gcc's implicit inlining, just breaking up the function by
> itself wouldn't be enough, unless you explicitly marked the new static
> functions with noinline; but that introduces inefficiencies.  If the
> only reason you want to do this is to make it easier to figure out a
> stack trace, addr2line really is your friend....

That was one reason -- the other is that I was thinking if sensible
functional boundaries in the source could be made between the
chunks marked as phase 1 --> phase N, then people like me who
are new to reading that bit of code might come away feeling more
confident that they understood it correctly.  Anyway, it was just a
thought...

I will keep people posted as to what (if?) I finally figure out
about RT+jbd2.  I have reproduced it on a completely different
machine (dual socket numa xeon with dual disks as raid0, vs.
the original single disk, single socket, COTS dell optiplex).

It still takes a massively parallel yocto build, combined with a
large "rm -rf" elsewhere to trigger it though (and even multiple
tries of the above).  So it is hard to say with confidence that
it is "found and fixed" based on build results alone -- when 5
full yocto builds can pass w/o any issue at all.  :(

But thanks for the input though!
Paul.
--

>
> Cheers,
>
>                                         - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
