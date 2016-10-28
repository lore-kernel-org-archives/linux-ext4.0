From: Tejun Heo <htejun@fb.com>
Subject: Re: [PATCH 1/4] sched: move IO scheduling accounting from
 io_schedule_timeout() to __schedule()
Date: Fri, 28 Oct 2016 15:12:32 -0400
Message-ID: <20161028191231.GA29044@htj.duckdns.org>
References: <1477673892-28940-1-git-send-email-tj@kernel.org>
 <1477673892-28940-2-git-send-email-tj@kernel.org>
 <20161028182712.GM3142@twins.programming.kicks-ass.net>
 <20161028190702.GL3157@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Tejun Heo <tj@kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <mingo@redhat.com>, <axboe@kernel.dk>,
        <tytso@mit.edu>, <jack@suse.com>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <mingbo@fb.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161028190702.GL3157@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello, Peter.

On Fri, Oct 28, 2016 at 09:07:02PM +0200, Peter Zijlstra wrote:
> One alternative is to inherit the iowait state of the task we block on.
> That'll not get rid of the branches much, but it will remove the new
> mutex APIs.

Yeah, thought about that briefly but we don't necessarily track mutex
or other synchronization construct owners, things get gnarly with
rwsems (the inode ones sometimes end up in a similar situation), and
we'll probably end up dealing with some surprising propagations down
the line.  That said, getting such automatic propagation working would
be great.

Thanks.

-- 
tejun
