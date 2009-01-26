From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/11] quota: Improve locking
Date: Mon, 26 Jan 2009 11:04:27 +0100
Message-ID: <20090126100427.GA2726@duck.suse.cz>
References: <1232129299-22018-1-git-send-email-jack@suse.cz> <1232129299-22018-2-git-send-email-jack@suse.cz> <20090123234912.f78d75a0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090123234912.f78d75a0.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 23-01-09 23:49:12, Andrew Morton wrote:
> On Fri, 16 Jan 2009 19:08:09 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> >  static DEFINE_SPINLOCK(dq_list_lock);
> > +static DEFINE_SPINLOCK(dq_state_lock);
> >  DEFINE_SPINLOCK(dq_data_lock);
> 
> The chances are very good that two or even three of these locks will
> all get placed into the same cacheline in main memory.  The effects
> will be quite bad if different CPUs (or, worse, different nodes) are
> taking these locks.
>
> For single, kernel-wide locks like these I think we should almost
> always pad out to a cacheline.
  I never thought about this. Thanks for the idea.

> With __cacheline_aligned_in_smp, rather than __cacheline_aligned. 
> Because spinlocks do take space even in uniprocessor builds.
  I've added this to my list of quota cleanups.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
