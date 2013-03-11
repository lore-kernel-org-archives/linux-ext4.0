From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: torrent hash failures since 3.9.0-rc1
Date: Mon, 11 Mar 2013 22:38:37 +0100
Message-ID: <20130311213837.GA438@x4>
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
 <20130311211833.GC15478@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130311211833.GC15478@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013.03.11 at 17:18 -0400, Theodore Ts'o wrote:
> On Mon, Mar 11, 2013 at 09:46:25PM +0100, Markus Trippelsdorf wrote:
> > > BTW, I'm currently running 3.9-rc2 with some additional fixes from the
> > > ext4 dev branch, and I'm not able to reproduce the problem using
> > > rtorrent on my laptop.  How reliably is it reproducing for you?  Are
> > > you seeing the problem every time you try this?
> > 
> > Yes, it's 100% reproducible for me. If I boot a 3.8 kernel the issue
> > vanishes.
> 
> Would you be willing to try an experiment? 
> 
> Try pulling down the master branch from the ext4 git tree here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
> 
> This contains all of the ext4 changes which are in 3.9-rc1, based on
> top of 3.8-rc3.  See if it reproduces there.  If it does, then it
> would tend to confirm the hypothesis that the issue was introduced by
> one of the ext4 patches that we merged during the 3.9-rc1 merge
> window... and then, since if you can reproduce the problem, if you
> could do a git bisect to find the guilty commit, that would really
> greatly appreciated.
> 
> If you can't reproduce it from the ext4.git tree, then the problem is
> probably caused by some other change that was introduced between 3.8
> and 3.9-rc1.

I've started a full bisection from v3.8 to todays git tree. It will take
~13 steps. However it's already late here in Germany. I will continue
the bisection tomorrow and report back.

-- 
Markus
