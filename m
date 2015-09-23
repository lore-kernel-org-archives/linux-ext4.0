From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 13:57:23 -0400
Message-ID: <20150923175723.GC26647@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <1443016253.19983.230.camel@gmail.com>
 <20150923170238.GG3318@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Artem Bityutskiy <dedekind1@gmail.com>, axboe@kernel.dk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	kernel-team@fb.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150923170238.GG3318@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello, Ted.

On Wed, Sep 23, 2015 at 01:02:38PM -0400, Theodore Ts'o wrote:
> Also note this performance regression reported by Dexuan Cui
> 
> 	https://lkml.org/lkml/2015/9/23/333
> 
> I didn't notice these problems since I my userspace doesn't enable the
> writeback cgroup.  (In fact I don't know how to do it using Debian
> Jessie.)

The thing is I don't think they're either.

> Tejun, can you please take a look at this and give me a
> recommendation?  I'm willing to wait a day or two while we try to fix
> the problem, but past that point I'd like to have a fix or revert this
> commit before Linus releases the next -rc release.

Yeap, looking at them both.  Will update as soon as I know more.

Thanks.

-- 
tejun
