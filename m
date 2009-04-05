From: Mark Lord <lkml@rtr.ca>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sun, 05 Apr 2009 13:15:11 -0400
Message-ID: <49D8E71F.6000703@rtr.ca>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu> <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:40104 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZDERPO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Apr 2009 13:15:14 -0400
In-Reply-To: <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linus Torvalds wrote:
>
> Non-rotational media would tend to want the unplugging, but the block 
> layer already does that (ie in __make_request() we already do:
> 
>         if (unplug || blk_queue_nonrot(q))
>                 __generic_unplug_device(q);
> 
> so non-rotational devices get unplugged whether the request was a 
> unplugging request or not).
..

Mmm.. except that Jeff's SSD doesn't appear to identify itself
as a non-rotating media.  I suppose there's a way to "quirk" that
somewhere, though.

:/
