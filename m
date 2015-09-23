From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 13:25:35 -0400
Message-ID: <20150923172535.GC25218@ret.masoncoding.com>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "Theodore Ts'o" <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
	<axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <lizefan@huawei.com>,
	<cgroups@vger.kernel.org>, <hannes@cmpxchg.org>,
	<kernel-team@fb.com>, <adilger.kernel@dilger.ca>,
	<linux-ext4@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443012552.19983.209.camel@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 23, 2015 at 03:49:12PM +0300, Artem Bityutskiy wrote:
> On Tue, 2015-07-21 at 23:56 -0400, Theodore Ts'o wrote:
> > > v2: Updated for MS_CGROUPWB -> SB_I_CGROUPWB.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > > Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> > > Cc: linux-ext4@vger.kernel.org
> > 
> > Thanks, applied.
> 
> Hi, this patch introduces a regression - a major one, I'd say.
> 
> Symptoms: copy a bunch of file, run sync, then run 'reboot', and after
> you boot up the copied files are corrupted. So basically the user
> -visible symptom is that 'sync' does not work.

Hi Artem,

Are you doing a hard shutdown (reboot -nf)?  If you're doing a friendly
shutdown, is the FS unmounting cleanly?

> 
> I quite an effort to bisect it, but it led me to this patch.

I bet it was a long bisect.  Trying to see if the same patch to btrfs
has similar impacts.

-chris
