From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] add hrtimer_sleep_ns helper function
Date: Tue, 19 Aug 2008 13:36:57 -0600
Message-ID: <20080819193657.GE8318@parisc-linux.org>
References: <20080806190819.GH27394@unused.rdu.redhat.com> <20080819191508.GD8318@parisc-linux.org> <20080819192215.GB21749@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, rwheeler@redhat.com,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59557 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYHSThN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2008 15:37:13 -0400
Content-Disposition: inline
In-Reply-To: <20080819192215.GB21749@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 19, 2008 at 03:22:16PM -0400, Josef Bacik wrote:
> On Tue, Aug 19, 2008 at 01:15:08PM -0600, Matthew Wilcox wrote:
> > I don't see any users (in this patch or the next) of people wanting
> > uninterruptible nanosleeps.  We shouldn't be introducing new
> > TASK_UNINTERRUPTIBLE users, but instead using TASK_KILLABLE if the user
> > really can't cope with signals in a sensible manner.
> 
> Hmm doh, sorry about that the 2/2 patch of this series should be passing 0 not 1
> since we need to be uninterruptible.

I think that's taught us that '0' and '1' are insufficiently
descriptive, and we should either be passing in a state (ie
do_nanosleep(x, y, TASK_FOO), or have separate do_nanosleep_killable()
and do_nanosleep_interruptible()).

> I figured this sort of thing would be used
> by fs's/device drivers where TASK_UNINTERRUPTIBLE is desired.  If that is not
> appropriate let me know and I can use TASK_KILLABLE or whatever else the
> preference is.  Thanks,

We should be trying to accommodate the user's wishes wherever possible.
If they say kill -9, they really mean it, and we should stop waiting.
Now, I don't think we should abort the journal_stop().  That's probably
going too far in this instance.  But we should stop waiting for other
tasks to join in, and finish up as quickly as possible.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
