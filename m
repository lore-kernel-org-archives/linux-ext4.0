From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCHSET v2 block/for-4.2/writeback] ext4: implement cgroup
 writeback support
Date: Thu, 16 Jul 2015 21:37:31 -0400
Message-ID: <20150717013731.GF22531@thunk.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <20150712180520.GE18734@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org,
	adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150712180520.GE18734-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 12, 2015 at 02:05:20PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jun 16, 2015 at 06:53:11PM -0400, Tejun Heo wrote:
> > This is v2.  The only change from the last take[L] is
> > 
> > * Updated to reflect the earlier MS_CGROUPWB -> SB_I_CGROUPWB change.
> > 
> > This patchset implements cgroup writeback support for ext4, which is
> > enabled for writeback and ordered data modes.  This patchset contains
> > the following two patches.
> 
> Ted, these two patches apply cleanly on top of the current mainline
> and thus can be routed either through ext4 or block tree.  What do you
> think?

I'll take them through the ext4 tree.

						- Ted
