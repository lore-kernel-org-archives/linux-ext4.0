From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Tue, 29 Sep 2015 10:26:31 -0400
Message-ID: <20150929142631.GA23411@mtj.duckdns.org>
References: <20150923185137.GJ26647@mtj.duckdns.org>
 <20150923210729.GA23180@mtj.duckdns.org>
 <1443082186.19983.234.camel@gmail.com>
 <20150924204529.GF25415@mtj.duckdns.org>
 <1443163749.19983.254.camel@gmail.com>
 <1443178222.10230.10.camel@gmail.com>
 <20150925154925.GH4449@mtj.duckdns.org>
 <1443254768.16309.46.camel@gmail.com>
 <20150926221413.GI3572@htj.duckdns.org>
 <1443526656.16309.49.camel@gmail.com>
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
In-Reply-To: <1443526656.16309.49.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello, Artem.

On Tue, Sep 29, 2015 at 02:37:36PM +0300, Artem Bityutskiy wrote:
> On Sat, 2015-09-26 at 18:14 -0400, Tejun Heo wrote:
> > Hello, Artem.
> > 
> > Thanks a lot for the debug dump.  Can you please test whether the
> > below patch fixes the issue?
> 
> Hi,
> 
> I've tested this, 7 out of 7 reboots successful, so it looks like this
> patch fixes the problem.

Thanks a lot for testing.  Will soon post the split patches w/ your
tested-by.

-- 
tejun
