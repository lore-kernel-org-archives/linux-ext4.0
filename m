From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] sched: move IO scheduling accounting from
 io_schedule_timeout() to __schedule()
Date: Mon, 31 Oct 2016 10:45:56 -0600
Message-ID: <20161031164556.GC26364@mtj.duckdns.org>
References: <1477673892-28940-1-git-send-email-tj@kernel.org>
 <1477673892-28940-2-git-send-email-tj@kernel.org>
 <20161028182712.GM3142@twins.programming.kicks-ass.net>
 <20161028190702.GL3157@twins.programming.kicks-ass.net>
 <20161028191231.GA29044@htj.duckdns.org>
 <20161029032126.GH3568@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <htejun@fb.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mingo@redhat.com, axboe@kernel.dk,
        tytso@mit.edu, jack@suse.com, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, mingbo@fb.com
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34376 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944302AbcJaQqF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2016 12:46:05 -0400
Content-Disposition: inline
In-Reply-To: <20161029032126.GH3568@worktop.programming.kicks-ass.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Sat, Oct 29, 2016 at 05:21:26AM +0200, Peter Zijlstra wrote:
> On Fri, Oct 28, 2016 at 03:12:32PM -0400, Tejun Heo wrote:
> > Hello, Peter.
> > 
> > On Fri, Oct 28, 2016 at 09:07:02PM +0200, Peter Zijlstra wrote:
> > > One alternative is to inherit the iowait state of the task we block on.
> > > That'll not get rid of the branches much, but it will remove the new
> > > mutex APIs.
> > 
> > Yeah, thought about that briefly but we don't necessarily track mutex
> 
> This one I actually fixed and should be in -next. And it would be
> sufficient to cover the use case here.

Tracking the owners of mutexes and rwsems does help quite a bit.  I
don't think it's as simple as inheriting io sleep state from the
current owner tho.  The owner might be running or in a non-IO sleep
when others try to grab the mutex.  It is an option to ignore those
cases but this would have a real possibility to lead to surprising
results in some corner cases.  If we choose to propagate dynamically,
it becomes an a lot more complex problem and I don't think it'd be
justfiable.

Unless there can be a simple enough and reliable solution, I think
it'd be better to stick with explicit marking.

Thanks.

-- 
tejun
