From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Null pointer deref in do_aio_submit
Date: Fri, 10 Feb 2012 15:53:16 -0500
Message-ID: <x49aa4qcsw3.fsf@segfault.boston.devel.redhat.com>
References: <Pine.LNX.4.64.1202100921580.1530@cobra.newdream.net>
	<x49zkcqo95j.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1202101013000.1531@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214Ab2BJUxT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 15:53:19 -0500
In-Reply-To: <Pine.LNX.4.64.1202101013000.1531@cobra.newdream.net> (Sage
	Weil's message of "Fri, 10 Feb 2012 12:42:04 -0800 (PST)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sage Weil <sage@newdream.net> writes:

> On Fri, 10 Feb 2012, Jeff Moyer wrote:
>> Sage Weil <sage@newdream.net> writes:
>> 
>> > I hit the following under a reasonable simple aio workload:
>> >
>> >  - reasonably heavy load
>> >  - lots of threads doing buffered io to random files
>> >  - one thread submitting O_DIRECT aio to a single file (journal), all 
>> >    sequential (wrapping), 100MB
>> >  - probably somewhere between 1 and 50 aios outstanding at any point in 
>> >    time.
>> >
>> > The kernel was v3.2 mainline, plus unrelated btrfs and ceph patches.
>> >
>> > Is this a known issue?  Any other information that would be helpful?
>> 
>> I don't know for sure, but could you test with the following commit?
>> 69e4747ee9727d660b88d7e1efe0f4afcb35db1b
>
> I'll pull this in and see if it comes up again (this is the first time 
> I've seen the crash).

OK, thanks.

>> Also, I'll note that it looks like you are doing O_SYNC + O_DIRECT AIO.
>> I'm curious to know what apps use that particular combination.  Is this
>> just a test case, or do you have an app which does this in production?
>
> That's what ceph-osd is doing on it's journal.  Rereading the man page 
> it's not clear to me what I *should* be doing, though.  Would you use 
> O_SYNC (with O_DIRECT) only to make sure the blocks you write to are 
> allocated/reachable on crash?  (Or, say, mtime is updated?)

O_DIRECT just bypasses the page cache--it doesn't provide any guarantees
that the data is on stable storage (so that's why you'd want to also use
O_SYNC).  Given that you're continually overwriting a log, I don't think
you have to really worry about metadata, right?  So, for your case,
either you can use O_SYNC as you are doing today, or you could fsync
whenever you wanted to ensure the disk cache was flushed.

I didn't mean to imply that Ceph was doing anything wrong.  That is a
perfectly valid combination of flags/operations.

Cheers,
Jeff
