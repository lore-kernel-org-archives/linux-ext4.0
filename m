From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHSET v2 block/for-4.2/writeback] ext4: implement cgroup
 writeback support
Date: Fri, 17 Jul 2015 09:21:59 +1000
Message-ID: <20150716232159.GN7943@dastard>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <20150712180520.GE18734@mtj.duckdns.org>
 <20150716194058.GZ15934@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org, axboe@kernel.dk
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150716194058.GZ15934@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 16, 2015 at 03:40:58PM -0400, Tejun Heo wrote:
> On Sun, Jul 12, 2015 at 02:05:20PM -0400, Tejun Heo wrote:
> > Ted, these two patches apply cleanly on top of the current mainline
> > and thus can be routed either through ext4 or block tree.  What do you
> > think?
> 
> ping?

Tejun, is this all that needs to be done to support cgroup aware
writeback in a filesystem (i.e. wbc_init_bio, wbc_account_io in the
writepage path, superblock flag)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
