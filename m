From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/4] percpu_stats: Enable 64-bit counts in 32-bit
 architectures
Date: Mon, 11 Apr 2016 18:17:00 -0400
Message-ID: <20160411221700.GP24661@htj.duckdns.org>
References: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com>
 <1460132182-11690-3-git-send-email-Waiman.Long@hpe.com>
 <20160408164747.GM24661@htj.duckdns.org>
 <5707EB44.9020703@hpe.com>
 <20160408174628.GN24661@htj.duckdns.org>
 <5707FC52.3070707@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Christoph Lameter <cl@linux.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <waiman.long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5707FC52.3070707@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello, Waiman.

On Fri, Apr 08, 2016 at 02:45:38PM -0400, Waiman Long wrote:
> The percpu_stats construct allows minimal overhead in maintaining statistics
> counts. The percpu_counter construct, on the other hand, has a higher
> performance overhead and a bit more complex to set up and tear down when

If you're referring to the preemption on/off, as I wrote before, we'll
probably be able to improve that with this_cpu_add_return so that the
only extra overhead is an easily predictable branch which is extremely
cheap.  It's better to improve common constructs anyway.

> more than one statistics counts are needed. In fact, my first draft of the

And yeah, it can be cumbersome to set up and tear down multiple
percpu_counters.  If there are enough consumers, we can extend
percpu_counter to handle multiple counters, right?

Thanks.

-- 
tejun
