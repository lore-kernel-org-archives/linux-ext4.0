From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 16:48:46 -0400
Message-ID: <20150923204846.GI3318@thunk.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <20150923172535.GC25218@ret.masoncoding.com>
 <CAF4G-tKEcnVw76-ZU77AjmBDGybLnNEOKjkJtYBN67es0wb30g@mail.gmail.com>
 <20150923175337.GD25218@ret.masoncoding.com>
 <20150923182432.GH3318@thunk.org>
 <CAF4G-t+E89a_A3RzQYB9wXxqE6nM0t7wN6fNmLABZ70=ivHTRQ@mail.gmail.com>
 <CAF4G-tL9Es57dTE7bDbUdYeQxPYgKct1zn_Zbn8+S9JHMfbsng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <clm@fb.com>, linux-ext4@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk,
	Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org,
	adilger.kernel@dilger.ca, kernel-team@fb.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF4G-tL9Es57dTE7bDbUdYeQxPYgKct1zn_Zbn8+S9JHMfbsng@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 23, 2015 at 10:47:16PM +0300, Artem Bityutskiy wrote:
> And, by the way, I forgot this detail - I cut AC power off at the
> end, then put it back on after a 20 seconds delay. I mean, this is a
> clean reboot, but with power cut at the end.

Is this reproducible without the power cut?  And what model SSD are
you using, and are you sure that it has Power Loss Protection (many
SSD vendors use power loss protection as the price discrimination
feature between consumer-grade SSD and enterprise-grade SSD's that
cost $$$).  If this problem wasn't showing up with 4.2, and is only
failing with 4.3-rcX, then it might not be a hardware issue --- but
it's also possible that there was a timing issue which was hiding a
hardware problem.  So for the purposes of debugging, removing the
power cut from the set of variables is a useful thing to do.

      	       	       	  	       	 	- Ted
