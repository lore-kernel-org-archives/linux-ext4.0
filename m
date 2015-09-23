From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 13:02:38 -0400
Message-ID: <20150923170238.GG3318@thunk.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <1443016253.19983.230.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	kernel-team@fb.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443016253.19983.230.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 23, 2015 at 04:50:53PM +0300, Artem Bityutskiy wrote:
> On Wed, 2015-09-23 at 15:49 +0300, Artem Bityutskiy wrote:
> > On Tue, 2015-07-21 at 23:56 -0400, Theodore Ts'o wrote:
> > > > v2: Updated for MS_CGROUPWB -> SB_I_CGROUPWB.
> > > > 
> > > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > > > Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> > > > Cc: linux-ext4@vger.kernel.org
> > > 
> > > Thanks, applied.
> > 
> > Hi, this patch introduces a regression - a major one, I'd say.
> > 
> > Symptoms: copy a bunch of file, run sync, then run 'reboot', and
> > after
> > you boot up the copied files are corrupted. So basically the user
> > -visible symptom is that 'sync' does not work.
> 
> Just FYI, this is the issue I briefly reported last Fri:
> 
> https://lkml.org/lkml/2015/9/18/640

Also note this performance regression reported by Dexuan Cui

	https://lkml.org/lkml/2015/9/23/333

I didn't notice these problems since I my userspace doesn't enable the
writeback cgroup.  (In fact I don't know how to do it using Debian
Jessie.)

Tejun, can you please take a look at this and give me a
recommendation?  I'm willing to wait a day or two while we try to fix
the problem, but past that point I'd like to have a fix or revert this
commit before Linus releases the next -rc release.

						- Ted
