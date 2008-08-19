From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH 1/2] add hrtimer_sleep_ns helper function
Date: Tue, 19 Aug 2008 15:39:47 -0400
Message-ID: <20080819193947.GC21749@unused.rdu.redhat.com>
References: <20080806190819.GH27394@unused.rdu.redhat.com> <20080819191508.GD8318@parisc-linux.org> <20080819192215.GB21749@unused.rdu.redhat.com> <20080819193657.GE8318@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
	rwheeler@redhat.com, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	linux-ext4@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080819193657.GE8318@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 19, 2008 at 01:36:57PM -0600, Matthew Wilcox wrote:
> On Tue, Aug 19, 2008 at 03:22:16PM -0400, Josef Bacik wrote:
> > On Tue, Aug 19, 2008 at 01:15:08PM -0600, Matthew Wilcox wrote:
> > > I don't see any users (in this patch or the next) of people wanting
> > > uninterruptible nanosleeps.  We shouldn't be introducing new
> > > TASK_UNINTERRUPTIBLE users, but instead using TASK_KILLABLE if the user
> > > really can't cope with signals in a sensible manner.
> > 
> > Hmm doh, sorry about that the 2/2 patch of this series should be passing 0 not 1
> > since we need to be uninterruptible.
> 
> I think that's taught us that '0' and '1' are insufficiently
> descriptive, and we should either be passing in a state (ie
> do_nanosleep(x, y, TASK_FOO), or have separate do_nanosleep_killable()
> and do_nanosleep_interruptible()).
> 
> > I figured this sort of thing would be used
> > by fs's/device drivers where TASK_UNINTERRUPTIBLE is desired.  If that is not
> > appropriate let me know and I can use TASK_KILLABLE or whatever else the
> > preference is.  Thanks,
> 
> We should be trying to accommodate the user's wishes wherever possible.
> If they say kill -9, they really mean it, and we should stop waiting.
> Now, I don't think we should abort the journal_stop().  That's probably
> going too far in this instance.  But we should stop waiting for other
> tasks to join in, and finish up as quickly as possible.

Fair enough, I will make the changes in the next round, thanks much.

Josef
