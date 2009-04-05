From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sun, 5 Apr 2009 13:06:48 -0700
Message-ID: <20090405130648.3266a468@infradead.org>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>
	<alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
	<20090404135719.GA9812@mit.edu>
	<20090404151649.GE5178@kernel.dk>
	<alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
	<20090404173412.GF5178@kernel.dk>
	<alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>
	<20090404180108.GH5178@kernel.dk>
	<20090404232222.GA7480@mit.edu>
	<20090404163349.20df1208@infradead.org>
	<20090405001005.GA7553@mit.edu>
	<alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>
	<20090405115629.521057fc@infradead.org>
	<alpine.LFD.2.00.0904051227120.4023@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758182AbZDEUFq@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904051227120.4023@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 5 Apr 2009 12:34:32 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 5 Apr 2009, Arjan van de Ven wrote:
> >
> > > See get_request():
> > 
> > our default number of requests is so low that we very regularly hit
> > the limit. In addition to setting kjournald to higher priority, I
> > tend to set the number of requests to 4096 or so to improve
> > interactive performance on my own systems. That way at least the
> > elevator has a chance to see the requests ;-)
> 
> That's insane. 

4096 is an absolutely insane value that hides some of the problem

> Long queues make the problem harder to hit, yes. But
> it also tends to make the problem them a million times worse when you
> _do_ hit it.

There is a dilemma though. By not having the IO needs in a queue,
to some degree, they haven't gone away; they just are invisible.

Now there is also a throttling value in having these limits, to
slow down "regular" processes that would cause too much IO.
Except that we have the dirty limit for that in the VM, and except that
most actual IO is done by pdflush and other kernel threads, with the
dirtying of data asynchronous to that.

I would contend that for most common cases, not giving callers a request
immediately does not change or throttle the actual IO that is in want
of being sent to the device. All it does is reduce visibility of the IO
need so less grouping of adjacent and prioritization can be done by the
elevator.
 
> I would suggest looking instead at trying to have separate allocation 
> pools for bulk and "sync" IO. Instead of having just one rq->rq_pool,
> we could easily have a rq->rq_bulk_pool and rq->rq_sync_pool.

Well that or have pools for a few buckets of priority level.
The risk of this is that someone like pdflush might get stuck on a low
priority queue, and thus cannot send the IO it might have wanted to
send into a higher priority queue. I fear that any such limits will in
general punish the wrong guy; after all number 129 is punished, not the
guy who put numbers 1 to 128 in the queue.

I wonder if it wouldn't be a better solution to give insight of the
queue length in use to pdflush, and have pdflush decide what kind of IO
to submit based on the length, rather than having it just block.

Just think of the sync() or fsync() cases.
The total amount of IO that those calls will cause is pretty much
fixed: the data that is "relevantly dirty" at the time of the call.
Holding things back at the request allocation level does not change
that, all it changes is that we delay merging requests that are
adjacent, sort on priority, etc.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
