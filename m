From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Thu, 7 Apr 2016 14:58:27 -0400
Message-ID: <20160407185827.GH7822@mtj.duckdns.org>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com>
 <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com>
 <20160404160228.GW7822@mtj.duckdns.org>
 <570584F1.10909@hpe.com>
 <20160406225424.GK24661@htj.duckdns.org>
 <57068395.1080703@hpe.com>
 <20160407160623.GF7822@mtj.duckdns.org>
 <5706AC71.3080801@hpe.com>
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
In-Reply-To: <5706AC71.3080801@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello, Waiman.

On Thu, Apr 07, 2016 at 02:52:33PM -0400, Waiman Long wrote:
> As long as atomic reset is an optional feature that caller can choose at
> init time, I am OK to provide this functionality. I just don't want it to be
> the default because of the performance overhead.

Please take a look at how percpu-ref coordinates global
synchronization.  The hot path overhead is one branch which is
extremely easy to predict and shouldn't show up anywhere.  If you're
gonna provide reset at all (which btw always kinda baffles me, what's
wrong with taking a snapshot value and taking delta from there?), you
need to make it actually work reliably.

Thanks.

-- 
tejun
