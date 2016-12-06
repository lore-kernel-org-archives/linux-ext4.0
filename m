From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] sched: move IO scheduling accounting from
 io_schedule_timeout() to __schedule()
Date: Tue, 6 Dec 2016 16:30:32 -0500
Message-ID: <20161206213032.GC26314@mtj.duckdns.org>
References: <1477673892-28940-1-git-send-email-tj@kernel.org>
 <1477673892-28940-2-git-send-email-tj@kernel.org>
 <20161028182712.GM3142@twins.programming.kicks-ass.net>
 <20161028190702.GL3157@twins.programming.kicks-ass.net>
 <20161028191231.GA29044@htj.duckdns.org>
 <20161029032126.GH3568@worktop.programming.kicks-ass.net>
 <20161031164556.GC26364@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <htejun@fb.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mingo@redhat.com, axboe@kernel.dk,
        tytso@mit.edu, jack@suse.com, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, mingbo@fb.com
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161031164556.GC26364@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Mon, Oct 31, 2016 at 10:45:56AM -0600, Tejun Heo wrote:
> Tracking the owners of mutexes and rwsems does help quite a bit.  I
> don't think it's as simple as inheriting io sleep state from the
> current owner tho.  The owner might be running or in a non-IO sleep
> when others try to grab the mutex.  It is an option to ignore those
> cases but this would have a real possibility to lead to surprising
> results in some corner cases.  If we choose to propagate dynamically,
> it becomes an a lot more complex problem and I don't think it'd be
> justfiable.
> 
> Unless there can be a simple enough and reliable solution, I think
> it'd be better to stick with explicit marking.

Just posted the fixed version for the first patch.  Any more thoughts
on this?

Thanks.

-- 
tejun
