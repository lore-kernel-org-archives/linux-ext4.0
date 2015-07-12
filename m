From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v2 block/for-4.2/writeback] ext4: implement cgroup
 writeback support
Date: Sun, 12 Jul 2015 14:05:20 -0400
Message-ID: <20150712180520.GE18734@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	kernel-team@fb.com, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: axboe@kernel.dk
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434495193-31182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Tue, Jun 16, 2015 at 06:53:11PM -0400, Tejun Heo wrote:
> This is v2.  The only change from the last take[L] is
> 
> * Updated to reflect the earlier MS_CGROUPWB -> SB_I_CGROUPWB change.
> 
> This patchset implements cgroup writeback support for ext4, which is
> enabled for writeback and ordered data modes.  This patchset contains
> the following two patches.

Ted, these two patches apply cleanly on top of the current mainline
and thus can be routed either through ext4 or block tree.  What do you
think?

Thanks.

-- 
tejun
