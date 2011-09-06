From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Date: Tue, 6 Sep 2011 12:48:57 +0900
Message-ID: <20110906034851.GC18425@mtj.dyndns.org>
References: <20110826072622.406d3395@kryten>
 <20110826072927.5b4781f9@kryten>
 <1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110829214609.495ee299@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33204 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1IFDtE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Sep 2011 23:49:04 -0400
Content-Disposition: inline
In-Reply-To: <20110829214609.495ee299@kryten>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 29, 2011 at 09:46:09PM +1000, Anton Blanchard wrote:
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

Applied to percpu/for-3.2.

Thanks.

-- 
tejun
