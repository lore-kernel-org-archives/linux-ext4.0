From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Thu, 24 Sep 2015 16:48:06 -0400
Message-ID: <20150924204806.GH25415@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <20150923180934.GE26647@mtj.duckdns.org>
 <20150923185137.GJ26647@mtj.duckdns.org>
 <20150923210729.GA23180@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, axboe@kernel.dk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	kernel-team@fb.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150923210729.GA23180@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 23, 2015 at 05:07:29PM -0400, Tejun Heo wrote:
> inode_cgwb_enabled() gates cgroup writeback support.  If it returns
> true, each inode is attached to the corresponding memory domain which
> gets mapped to io domain.  It currently only tests whether the
> filesystem and bdi support cgroup writeback; however, cgroup writeback
> support doesn't work on traditional hierarchies and thus it should
> also test whether memcg and iocg are on the default hierarchy.
> 
> This caused traditional hierarchy setups to hit the cgroup writeback
> path inadvertently and ended up creating separate writeback domains
> for each memcg and mapping them all to the root iocg uncovering a
> couple issues in the cgroup writeback path.
> 
> cgroup writeback was never meant to be enabled on traditional
> hierarchies.  Make inode_cgwb_enabled() test whether both memcg and
> iocg are on the default hierarchy.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Artem Bityutskiy <dedekind1@gmail.com>
> Reported-by: Dexuan Cui <decui@microsoft.com>
> Link: http://lkml.kernel.org/g/1443012552.19983.209.camel@gmail.com
> Link: http://lkml.kernel.org/g/f30d4a6aa8a546ff88f73021d026a453@SIXPR30MB031.064d.mgd.msft.net

Applying to cgroup/for-4.3-fixes.

Thanks.

-- 
tejun
