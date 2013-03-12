From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: torrent hash failures since 3.9.0-rc1
Date: Tue, 12 Mar 2013 11:00:58 +0800
Message-ID: <20130312030057.GA6142@gmail.com>
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
 <20130311211833.GC15478@thunk.org>
 <20130311213837.GA438@x4>
 <20130311231227.GA319@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130311231227.GA319@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 12, 2013 at 12:12:27AM +0100, Markus Trippelsdorf wrote:
> On 2013.03.11 at 22:38 +0100, Markus Trippelsdorf wrote:
> > On 2013.03.11 at 17:18 -0400, Theodore Ts'o wrote:
> > > On Mon, Mar 11, 2013 at 09:46:25PM +0100, Markus Trippelsdorf wrote:
> > > > > BTW, I'm currently running 3.9-rc2 with some additional fixes from the
> > > > > ext4 dev branch, and I'm not able to reproduce the problem using
> > > > > rtorrent on my laptop.  How reliably is it reproducing for you?  Are
> > > > > you seeing the problem every time you try this?
> > > > 
> > > > Yes, it's 100% reproducible for me. If I boot a 3.8 kernel the issue
> > > > vanishes.
> > > 
> > > Would you be willing to try an experiment? 
> > > 
> > > Try pulling down the master branch from the ext4 git tree here:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
> > > 
> > > This contains all of the ext4 changes which are in 3.9-rc1, based on
> > > top of 3.8-rc3.  See if it reproduces there.  If it does, then it
> > > would tend to confirm the hypothesis that the issue was introduced by
> > > one of the ext4 patches that we merged during the 3.9-rc1 merge
> > > window... and then, since if you can reproduce the problem, if you
> > > could do a git bisect to find the guilty commit, that would really
> > > greatly appreciated.
> > > 
> > > If you can't reproduce it from the ext4.git tree, then the problem is
> > > probably caused by some other change that was introduced between 3.8
> > > and 3.9-rc1.
> > 
> > I've started a full bisection from v3.8 to todays git tree. It will take
> > ~13 steps. However it's already late here in Germany. I will continue
> > the bisection tomorrow and report back.
> 
> The issue started with:
> 
> 74cd15cd02708c7188581f279f33a98b2ae8d322 is the first bad commit
> commit 74cd15cd02708c7188581f279f33a98b2ae8d322
> Author: Zheng Liu <wenqing.lz@taobao.com>
> Date:   Mon Feb 18 00:32:55 2013 -0500
> 
>     ext4: reclaim extents from extent status tree
> 
> Please note that my local rtorrent version was configured with
> "--with-posix-fallocate". I'm not sure if distributions also enable this
> flag, but it could explain why Ted and Dave weren't able to reproduce
> the problem so far.

Hi Markus,

Thanks for reporting this problem.  My deepest apologies.

As Ted suggested, could you please try to use ext4 git tree?  I want to
make sure whether this bug has been fixed by my lastest patch series or
not.

Thanks in advance,
                                                - Zheng
