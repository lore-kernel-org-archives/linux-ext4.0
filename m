From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Thu, 30 Nov 2017 10:27:13 -0500
Message-ID: <20171130152713.aeyxhns57lhou4de@thunk.org>
References: <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org>
 <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
 <20171129061307.f6hekryi3bppo26y@thunk.org>
 <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
 <CAFk8rvY9_-GxghCA43G9JoVqw-8NTG7-oRxEcV_cudcgDcy=rQ@mail.gmail.com>
 <20171130004816.pdzfqjluchtvfq6u@thunk.org>
 <CAFk8rvakptuN_rP5CRfLNNLEwntkvvcbdjn55O_E-RQyLUB=MQ@mail.gmail.com>
 <20171130044649.xfgwhd2wzdc5mwql@thunk.org>
 <CAFk8rvaPOd-XEOqnYSXVgp2Dw7wFYc98-q7JrdAAd-R8LJF=Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: Ashlie Martinez <ashmrtn@utexas.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47454 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752564AbdK3P1Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 30 Nov 2017 10:27:16 -0500
Content-Disposition: inline
In-Reply-To: <CAFk8rvaPOd-XEOqnYSXVgp2Dw7wFYc98-q7JrdAAd-R8LJF=Ag@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 30, 2017 at 08:51:45AM -0600, Ashlie Martinez wrote:
> 
> Even though CrashMonkey *records* all the disk operations, it doesn't
> have to replay all of them when generating crash states. For example,
> it could choose to fully replay (and preserve the ordering of) all
> operations before the 3rd barrier operation in a trace with 5
> different barrier operations in it (we dub each set of operations from
> just after the previous barrier operation up to and including the next
> barrier operation a "disk write epoch" or "disk epoch").

OK, but then it won't replay any operations after the 4th barrier
opration, correct?  And in the case where you are stopping somewhere
between the 3rd and the 4th replay, you will drop and reorder random
operations after the 3rd barrier op, but before the 4th, correct?

So what would be good is to understand where it stopped replaying
operations ---- and if you can get a strace -ttt of the workload, and
the fine-grained timestamps from block I/O trace, so we can understand
how far we had gotten in the workload.  And then, to also to include
the output of debugfs's "logdump -ac" command before the journal is
replayed.

>From a file system developer's perspective, what is most useful is
when we can see the minimal reproduction test case where Crashmonkey
is only rearranging block I/O's of the last full "disk write epock".
And getting the timestampped strace logs and block I/O logs will help
us do that.

Otherwise, we have no idea where to look for a potential problem, only
that it's one of the several I/O commands.


Anyway, looking back at your original question, is your question why
the first write isn't delay allocated?  That's because the
collapse_range operation needs to resolve any delayed allocation
writes on the portion of the extent tree which will be affected by the
collapse_range operation.  See the calls to
filemap_write_and_wait_range() in ext4_collapse_range().

Note that if you want to try to understand what is going on, there are
a large number of ext4 and jbd2 tracepoints.  Enabling these
tracepoints (you may need to omit some of the much more chatty jbd2
trace points from the ones that you enable) and dumping those
timestamps alongside the strace -ttt and block I/O timestamps should
be especially illuminating.

Cheers,

						- Ted

P.S.  Another set of tracepoints that might be useful for
understanding when delayed write allocations are getting resolved are
the writeback tracepoints --- although you can probably infer those
from the ext4_writepages traces, since when the writeback is triggered
this will trigger calls to ext4_writepages.
