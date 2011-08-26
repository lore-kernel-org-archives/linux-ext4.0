From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Date: Fri, 26 Aug 2011 11:00:16 +0200
Message-ID: <20110826090016.GD2632@htj.dyndns.org>
References: <20110826072622.406d3395@kryten>
 <20110826072927.5b4781f9@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, eric.dumazet@gmail.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110826072927.5b4781f9@kryten>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 26, 2011 at 07:29:27AM +1000, Anton Blanchard wrote:
> 
> When testing on a 1024 thread ppc64 box I noticed a large amount of
> CPU time in ext4 code.
> 
> ext4_has_free_blocks has a fast path to avoid summing every free and
> dirty block per cpu counter, but only if the global count shows more
> free blocks than the maximum amount that could be stored in all the
> per cpu counters.
> 
> Since percpu_counter_batch scales with num_online_cpus() and the maximum
> amount in all per cpu counters is percpu_counter_batch * num_online_cpus(),
> this breakpoint grows at O(n^2).
> 
> This issue will also hit with users of percpu_counter_compare which
> does a similar thing for one percpu counter.
> 
> I chose to cap percpu_counter_batch at 1024 as a conservative first
> step, but we may want to reduce it further based on further benchmarking.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Yeah, capping the upper bound seems reasonable but can you please add
some comment explaining why the upper bound is necessary there?

Thank you.

-- 
tejun
