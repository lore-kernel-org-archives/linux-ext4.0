From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sat, 4 Apr 2009 20:10:05 -0400
Message-ID: <20090405001005.GA7553@mit.edu>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54169 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758805AbZDEEJw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Apr 2009 00:09:52 -0400
Content-Disposition: inline
In-Reply-To: <20090404163349.20df1208@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 04, 2009 at 04:33:49PM -0700, Arjan van de Ven wrote:
> > However, the full latency fixes all the writes are synchronous, so it
> > must be the case that the delays are caused by the fact that queue is
> > getting implicitly unplugged after the synchronous write, and the
> > problem is no longer the mixing of WRITE and WRITE_SYNC requests as
> > posted in the commit log for 78f707bf.  If we remove the automatic
> > unplug for WRITE_SYNC requests, and add an explicit unplug where it is
> > needed, that should fix the performance regression for this particular
> > sqlite test case. 
> 
> removing the unplug is bound to be bad; after all we're waiting on the
> IO. But maybe it should be "make the unplug a REALLY short time".
> At least for rotating storage. For non-rotating .. I'd never wait.

Ext3 needs to submit a large number of blocks for writing with
WRITE_SYNC priority, without unplugging the queue, until they are all
submitted.  Then we want to let things rip.  (Hence the "add an
explicit unplug where it is needed".)

It may be that it's easier from an less-lines-of-the-kernels-to-change
point of view to add a WRITE_SYNC_PLUGGED which doesn't do the unplug,
and keep WRITE_SNYC as having the implicit unplug.  Or maybe it would
be better to completely separate the "send a write which is marked as
SYNC" from the "implicit unplug" in the API.

Jens, do you have an opinion/preference?

					- Ted


