From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 6 Apr 2009 07:48:13 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904060739570.4023@localhost.localdomain>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
 <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090406081616.GT5178@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Arjan van de Ven <arjan@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbZDFOvi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2009 10:51:38 -0400
In-Reply-To: <20090406081616.GT5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Mon, 6 Apr 2009, Jens Axboe wrote:
> 
> Well, either you are submitting a single piece of IO (in which case you
> just want to unplug or directly submit as part of the submit_bio()), or
> you are submitting several IOS (in which case you just want to unplug at
> the end of the IO submission, before waiting).

That's not true.

The plugging is often across multiple threads. It didn't _use_ to be (we 
always unplugged at wait), but it is now. Nothing else explains why that 
patch by Ted makes such a big throughput thing, because the code did

      ret = submit_bh(WRITE_SYNC, bh);
      wait_on_buffer(bh);

ie it very much submits a _single_ IO, and waits on it. If plugging made a 
difference, that means that unplugging was delayed so long that somebody 
else does IO too - ie it gets delayed past a wait event.

So according to your own rules, that submit_bh() _should_ use WRITE_SYNC, 
but something bad happens if it does. I'm not quite seeing _what_, though, 
unless there are multiple processes trying to dirty the _same_ buffer, and 
they win if they all can dirty it without doing IO on it in between (and 
then the write turns into just one write).

		Linus

