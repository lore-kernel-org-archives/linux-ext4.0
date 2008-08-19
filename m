From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH 1/2] add hrtimer_sleep_ns helper function
Date: Tue, 19 Aug 2008 15:22:16 -0400
Message-ID: <20080819192215.GB21749@unused.rdu.redhat.com>
References: <20080806190819.GH27394@unused.rdu.redhat.com> <20080819191508.GD8318@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
	rwheeler@redhat.com, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	linux-ext4@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080819191508.GD8318@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 19, 2008 at 01:15:08PM -0600, Matthew Wilcox wrote:
> On Wed, Aug 06, 2008 at 03:08:19PM -0400, Josef Bacik wrote:
> > -static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
> > +static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode,
> > +				int interruptible)
> >  {
> >  	hrtimer_init_sleeper(t, current);
> >  
> >  	do {
> > -		set_current_state(TASK_INTERRUPTIBLE);
> > +		set_current_state(interruptible ? TASK_INTERRUPTIBLE :
> > +				  TASK_UNINTERRUPTIBLE);
> 
> I don't see any users (in this patch or the next) of people wanting
> uninterruptible nanosleeps.  We shouldn't be introducing new
> TASK_UNINTERRUPTIBLE users, but instead using TASK_KILLABLE if the user
> really can't cope with signals in a sensible manner.
>

Hmm doh, sorry about that the 2/2 patch of this series should be passing 0 not 1
since we need to be uninterruptible.  I figured this sort of thing would be used
by fs's/device drivers where TASK_UNINTERRUPTIBLE is desired.  If that is not
appropriate let me know and I can use TASK_KILLABLE or whatever else the
preference is.  Thanks,

Josef 
