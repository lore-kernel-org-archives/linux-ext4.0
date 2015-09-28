From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Mon, 28 Sep 2015 17:39:13 -0400
Message-ID: <20150928213913.GH2589@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <20150923180934.GE26647@mtj.duckdns.org>
 <20150923185137.GJ26647@mtj.duckdns.org>
 <20150923210729.GA23180@mtj.duckdns.org>
 <1443082186.19983.234.camel@gmail.com>
 <d6cf09f352a84b8d811da55fbc64a869@SIXPR30MB031.064d.mgd.msft.net>
 <20150924204736.GG25415@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "dedekind1@gmail.com" <dedekind1@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"lizefan@huawei.com" <lizefan@huawei.com>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"kernel-team@fb.com" <kernel-team@fb.com>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dexuan Cui <decui@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150924204736.GG25415@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Thu, Sep 24, 2015 at 04:47:36PM -0400, Tejun Heo wrote:
> On Thu, Sep 24, 2015 at 08:40:18AM +0000, Dexuan Cui wrote:
> > I can confirm the patch fixes my "slow write" issue too.
> > 
> > Tested-by: Dexuan Cui <decui@microsoft.com>
> 
> Yeah, this should make it go away w/o using cgroup writeback
> explicitly; however, I think the proper solution for cgroup writeback
> is moving bandwidth estimation from memory domain to io domain so that
> two separate bw estimations wouldn't interfere with each other leading
> to unexpected outcomes.  I'll work on the changes.

So, this one actually turns out to be mostly caused by enabling cgroup
writeback when it shouldn't be.  balance_dirty_pages() ended up
looking at a different bdi_writeback from the actual writeback path so
the throttling was completley off, so making sure that cgroup
writeback doesn't get turned on traditional hierarchies is the right
solution here.

While auditing the behavior, I noticed a couple non-critical issues.
Will post patches to fix them soon.

Thanks.

-- 
tejun
