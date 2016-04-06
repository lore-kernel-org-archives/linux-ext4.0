From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Wed, 6 Apr 2016 18:54:24 -0400
Message-ID: <20160406225424.GK24661@htj.duckdns.org>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com>
 <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com>
 <20160404160228.GW7822@mtj.duckdns.org>
 <570584F1.10909@hpe.com>
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
In-Reply-To: <570584F1.10909@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Wed, Apr 06, 2016 at 05:51:45PM -0400, Waiman Long wrote:
> >>+	/*
> >>+	 * If a statistics count is in the middle of being updated, it
> >>+	 * is possible that the above clearing may not work. So we need
> >>+	 * to double check again to make sure that the counters are really
> >>+	 * cleared. Still there is a still a very small chance that the
> >>+	 * second clearing does not work.
> >>+	 */
> >>+	for_each_possible_cpu(cpu) {
> >>+		unsigned long *pstats =  per_cpu_ptr(pcs->stats, cpu);
> >>+		int stat;
> >>+
> >>+		for (stat = 0; stat<  pcs->nstats; stat++, pstats++)
> >>+			if (*pstats)
> >>+				*pstats = 0;
> >>+	}
> >I don't think this is acceptable.
> 
> I am not sure what you mean here by not acceptable. Please enlighten me on
> that.

Hmmm... I thought that was pretty clear.  Try-twice-and-we-are-probably-okay
is simply not acceptable.  Please make it watertight.

Thanks.

-- 
tejun
