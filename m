From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Thu, 08 Apr 2010 10:24:18 -0400
Message-ID: <x49ljcy9g4t.fsf@segfault.boston.devel.redhat.com>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com>
	<20100407214631.GL3206@redhat.com> <20100408110442.GK10103@kernel.dk>
	<20100408140515.GB10879@redhat.com> <20100408140944.GQ10103@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab0DHOY1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 10:24:27 -0400
In-Reply-To: <20100408140944.GQ10103@kernel.dk> (Jens Axboe's message of "Thu,
	8 Apr 2010 16:09:44 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jens Axboe <jens.axboe@oracle.com> writes:

> Precisely. The next question would be how to control the yielding. In
> this particular case, you want to be yielding to a specific cfqq. IOW,
> you essentially want to pass your slide on to that queue. The way the
> above is implemented, you could easily just switch to another unrelated
> queue. And if that is done, fairness is skewed without helping the
> yielding process at all (which was the intention).

Well, that's true in part.  Prior to this patch, the process would idle,
keeping all other cfq_queues on the system from making progress.  With
this patch, at least *somebody* else makes progress, getting you closer
to running the journal thread that you're blocked on.  Ideally, you'd
want the thread you're waiting on to get disk time next, sure.  You
would have to pass the process information down to the I/O scheduler for
that, and I'm not sure that the file system code knows which process to
hand off to.  Does it?

Do we really want to go down this road at all?  I'm not convinced.

Cheers,
Jeff
