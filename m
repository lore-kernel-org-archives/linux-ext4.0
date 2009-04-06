From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 6 Apr 2009 10:16:16 +0200
Message-ID: <20090406081616.GT5178@kernel.dk>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:38564 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbZDFIQT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 04:16:19 -0400
Content-Disposition: inline
In-Reply-To: <20090404163349.20df1208@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 04 2009, Arjan van de Ven wrote:
> On Sat, 4 Apr 2009 19:22:22 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> > 
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

Well, either you are submitting a single piece of IO (in which case you
just want to unplug or directly submit as part of the submit_bio()), or
you are submitting several IOS (in which case you just want to unplug at
the end of the IO submission, before waiting).

-- 
Jens Axboe

