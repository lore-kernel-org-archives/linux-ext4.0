From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 14:51:37 -0400
Message-ID: <20150923185137.GJ26647@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <20150923180934.GE26647@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org,
	kernel-team-b10kYP2dOMg@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150923180934.GE26647-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 23, 2015 at 02:09:34PM -0400, Tejun Heo wrote:
> Hello, Artem.
> 
> On Wed, Sep 23, 2015 at 03:49:12PM +0300, Artem Bityutskiy wrote:
> > I use Fedora 22 with all the latest package updates, and I only change
> > the kernel there.
> 
> What's your cgroup setup like?  Are you trying out the unified
> hierarchy?  Given that you didn't mention that, I'm guessing you
> aren't which makes me pretty head-scratchy because I don't see how the
> actual behavior would change depending on that flag.  I'll dig more.

Ugh... never mind.  I spotted what I did wrong.  The sync thing still
needs figuring out (it still should have worked) but fixing the
regression should be easy.  Will update soon.

Thanks.

-- 
tejun
