From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ratelimit the file system mounted message
Date: Mon, 17 Aug 2015 10:50:56 -0400
Message-ID: <20150817145056.GC27202@thunk.org>
References: <1439665197-10766-1-git-send-email-tytso@mit.edu>
 <20150817011215.GA714@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eryu Guan <eguan@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34030 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbbHQOu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Aug 2015 10:50:59 -0400
Content-Disposition: inline
In-Reply-To: <20150817011215.GA714@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 17, 2015 at 11:12:15AM +1000, Dave Chinner wrote:
> On Sat, Aug 15, 2015 at 02:59:57PM -0400, Theodore Ts'o wrote:
> > The xfstests ext4/305 will mount and unmount the same file system over
> > 4,000 times, and each one of these will cause a system log message.
> > Ratelimit this message since if we are getting more than a few dozen
> > of these messages, they probably aren't going to be helpful.
> 
> Perhaps you should look at fixing the test or making it a more
> targetted reproducer. Tests that do "loop doing something basic
> while looping doing something else basic for X minutes to try to
> trip a race condition" aren't very good regression tests....

The problem what we are specifically testing is a race where one
process is reading from a proc fs file while the file system is being
unmounted:

commit f7922730727844c6dee837bd1a64221342fef1d1
Author: Eryu Guan <eguan@redhat.com>
Date:   Mon Apr 1 10:57:43 2013 +0000

    xfstests ext4 305: test read /proc/fs/ext4/<dev>/mb_groups while the fs is being unmounted
    
    Regression test for commit:
    9559996 ext4: remove mb_groups before tearing down the buddy_cache
    
    Signed-off-by: Eryu Guan <eguan@redhat.com>
    Reviewed-by: Rich Johnston <rjohnston@sgi.com>
    [rjohnston@sgi.com renumbered test to next in group sequence]
    Signed-off-by: Rich Johnston <rjohnston@sgi.com>

I don't see a better way of doing the test off the top of my head,
though.... and to be honest I'm not sure how much value the test
really has, since it's the sort of thing that can easily be checked by
inspection, and it seems rather unlikely we would regress here.

BTW, out of curiosity I reverted 9559996 and tried running ext4/305
many times, on a variety of different VM's ranging from 1 to 8 CPU's,
and using both a SSD and a laptop HDD.

In all cases, ext3/305 reliably reproduced the failure within 30
mount/unmount cycles, and in most cases, under a dozen cycles.  (i.e.,
under two seconds, and usually in a fraction of a second).  So I'm not
entirely sure why the test was written to run the loop for 3 minutes
and thousands of mount/unmount cycles.

Eryu, you wrote the test; any thoughts?  At the very least I'd suggest
cutting the test down so that it runs for at most 2 seconds, if for no
other reason than to speed up regression test runs.

						- Ted

