From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 15:03:15 -0400
Message-ID: <20150923190315.GL26647@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <20150923172535.GC25218@ret.masoncoding.com>
 <CAF4G-tKEcnVw76-ZU77AjmBDGybLnNEOKjkJtYBN67es0wb30g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>,
	kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAF4G-tKEcnVw76-ZU77AjmBDGybLnNEOKjkJtYBN67es0wb30g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Hello, Artem.

On Wed, Sep 23, 2015 at 08:41:25PM +0300, Artem Bityutskiy wrote:
> $ sync
> $ reboot
> 
> is exactly the sequence.

Can you please test with 4.3-rc2 and see whether the issue is
reproducible?  The multi-wb wait logic rewrite was merged during rc1
and I'm wondering whether this is a bug in the old implementation.

Thanks.

-- 
tejun
