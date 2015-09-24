From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Thu, 24 Sep 2015 11:09:46 +0300
Message-ID: <1443082186.19983.234.camel@gmail.com>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
	 <1434495193-31182-3-git-send-email-tj@kernel.org>
	 <20150722035620.GD2944@thunk.org> <1443012552.19983.209.camel@gmail.com>
	 <20150923180934.GE26647@mtj.duckdns.org>
	 <20150923185137.GJ26647@mtj.duckdns.org>
	 <20150923210729.GA23180@mtj.duckdns.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, axboe@kernel.dk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	kernel-team@fb.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150923210729.GA23180@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2015-09-23 at 17:07 -0400, Tejun Heo wrote:
> Hello,
> 
> So, this should make the regression go away.  It doesn't fix the
> underlying bugs but they shouldn't get triggered by people not
> experimenting with cgroup.

Tejun,

this hits the nail on the head and makes the problem go away.

I've tested the tip of Linuses tree (v4.3-rc2+) plus this patch - no
data corruption after reboots.

I've tested just the tip of Linuses tree (v4.3-rc2+) without this
patch, and I do see the data corruption after reboots.

Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Artem.
