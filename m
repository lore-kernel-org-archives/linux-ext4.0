From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Mon, 4 Apr 2016 14:09:31 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1604041408110.16930@east.gentwo.org>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com> <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com> <57021969.8050504@kyup.com> <5702A053.5030404@hpe.com>
Content-Type: text/plain; charset=US-ASCII
Cc: Nikolay Borisov <kernel@kyup.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <waiman.long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5702A053.5030404@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 4 Apr 2016, Waiman Long wrote:

> > > +	if ((unsigned int)stat>= pcs->nstats)
> > > +		return;
> > > +	preempt_disable();
> > > +	pstat = this_cpu_ptr(&pcs->stats[stat]);
> > > +	*pstat += cnt;
> > > +	preempt_enable();
> > > +}
> > pstat = get_cpu_ptr(&pcs->stats[stat]);
> > *pstat += cnt;
> > put_cpu_ptr(&pcs->stats[stat]);
> >
> > It will generate identical code but this one uses APIs, making the
> > intention clearer. But as I said this is just a minor nit.
> >
> > you can add my Reviewed-by: Nikolay Borisov<kernel@kyup.com>  for this
> > particular patch.
>
> Yes, that will certainly make it look nicer. I will update the patch once I
> get feedback from my other ext4 patches.

Why not

   this_cpu_add(pci->stats[stat], cnt)

This is a single instruction on x86.
