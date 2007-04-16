From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Check for error returned by kthread_create on creating journal thread
Date: Mon, 16 Apr 2007 12:10:26 +0100
Message-ID: <20070416111026.GA22116@infradead.org>
References: <4623289A.1000101@sw.ru> <20070416102107.GA12818@infradead.org> <462359B2.7070706@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, sct@redhat.com,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org
To: Pavel Emelianov <xemul@sw.ru>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754064AbXDPLKk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <462359B2.7070706@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 16, 2007 at 03:10:42PM +0400, Pavel Emelianov wrote:
> Christoph Hellwig wrote:
> > On Mon, Apr 16, 2007 at 11:41:14AM +0400, Pavel Emelianov wrote:
> >> If the thread failed to create the subsequent wait_event
> >> will hang forever.
> >>
> >> This is likely to happen if kernel hits max_threads limit.
> >>
> >> Will be critical for virtualization systems that limit the
> >> number of tasks and kernel memory usage within the container.
> > 
> >> --- ./fs/jbd/journal.c.jbdthreads	2007-04-16 11:17:36.000000000 +0400
> >> +++ ./fs/jbd/journal.c	2007-04-16 11:30:09.000000000 +0400
> >> @@ -211,10 +211,16 @@ end_loop:
> >>  	return 0;
> >>  }
> >>  
> >> -static void journal_start_thread(journal_t *journal)
> >> +static int journal_start_thread(journal_t *journal)
> >>  {
> >> -	kthread_run(kjournald, journal, "kjournald");
> >> +	struct task_struct *t;
> >> +
> >> +	t = kthread_run(kjournald, journal, "kjournald");
> >> +	if (IS_ERR(t))
> >> +		return PTR_ERR(t);
> >> +
> >>  	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
> > 
> > Note that this wait_event should exist at all, and the return
> 
> Should NOT you mean?

Umm, yes - of course :)

> > value of kthread_run should be assigned to journal->j_task.  Also
> > the code doesn't use the kthread primitives in other places leading
> > to crufty code.
> 
> Well, this could be done with a separate patch, I think.
