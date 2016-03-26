From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 jbd2 state lock race condition
Date: Sat, 26 Mar 2016 11:21:29 -0400
Message-ID: <20160326152129.GC4539@thunk.org>
References: <CAF=9w3kK=kupvjVnG+dyiwYHnf530EDnQZqb+T+N+4FwW3GpfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Da-Chang Guan <dcguan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33638 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbcCZPVe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Mar 2016 11:21:34 -0400
Content-Disposition: inline
In-Reply-To: <CAF=9w3kK=kupvjVnG+dyiwYHnf530EDnQZqb+T+N+4FwW3GpfA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 25, 2016 at 06:32:47PM +0800, Da-Chang Guan wrote:
> Hi, all,
> 
>   We have a 4 core Android device has system hang issue. The stack
> trace shows system hang may caused by jbd2 state lock racing.

So this is an ancient kernel (3.7.2) --- which is extremely old.  It's
not even a stable kernel, and in fact starting this year I stopped
caring about 3.10 kernels since while it was disgraceful we are
shipping phones in 2016 using kernels dating from 2013, there are no
mobile devices I care about that will be using anything older than
3.18 going forward.

So just to set your expectations, as upstream developers we generally
only support the latest upstream kernels.  Because I've been doing
some work to add ext4 encrpytion support into Android, for a while I
suffered having to support 3.10 based device kernels.  At this point,
though, I personally have little or no interest for kernels older than
3.18.

In terms of trying to debug this, if you can reproduce the bug, you'll
be in much better shape.  Also, if you have a serial conosle and
CONFIG_MAGIC_SYSRQ is enabled, I'd suggest getting stack traces of all
the CPU's so you can see who else might be holding the lock.  If you
can't reproduce the problem, and you can't get the stack traces for
all the CPU's using the magic sysrq, I doubt there's much that can be
done to reproduce the problem.

May I suggest upgrading to at least 3.18, preferably the latest stable
kernel, which as of this writing is 3.18.29?  I am running regression
tests on 3.18, and making sure that critical bug fixes are getting
back ported to 4.4 and 3.18.  (With 3.14 and 3.10 happening if I have
time and if it's not too difficult, but starting this year, those two
kernels are much lower priority for me.)

Best regards,

>    We want to know who acquires the lock at that time so we can fix
> it.  But we don't even know how to start debug.

If you can reproduce the problem, using CONFIG_LOCKDEP will be very
helpful.  Also perhaps useful would be to build 3.7.2 on x86, and then
use xfstests to try flush out bugs.  I'm sure you will find them ---
when I first started testing a 3.10-based msm kernel, I was able to
trivially trigger kernel crashes using kvm-xfstests.  I think you'll
find it is much easier to find the bugs on x86, and then fix up the
kernel so it's not crashing there, and then see if that addresses your
problem on arm, because there is a much more powerful testing
infrastructure you can use for x86.  See:

	       http://thunk.org/gce-xfstests

If you can upgrade to a non-antique kernel, though, I think you'll
save yourself much more time.  It may be that using kvm-xfstests or
gce-xfstests to demonstrate how unstable 3.7.2 might be helpful in
pursuading your management to let you upgrade to something a bit more
recent.

Cheers,

						- Ted
