From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 6 Apr 2009 10:13:56 +0200
Message-ID: <20090406081356.GS5178@kernel.dk>
References: <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu> <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain> <49D8E71F.6000703@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:38543 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZDFIN6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 04:13:58 -0400
Content-Disposition: inline
In-Reply-To: <49D8E71F.6000703@rtr.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 05 2009, Mark Lord wrote:
> Linus Torvalds wrote:
>>
>> Non-rotational media would tend to want the unplugging, but the block  
>> layer already does that (ie in __make_request() we already do:
>>
>>         if (unplug || blk_queue_nonrot(q))
>>                 __generic_unplug_device(q);
>>
>> so non-rotational devices get unplugged whether the request was a  
>> unplugging request or not).
> ..
>
> Mmm.. except that Jeff's SSD doesn't appear to identify itself
> as a non-rotating media.  I suppose there's a way to "quirk" that
> somewhere, though.

You can quirk it in userspace, just have it set the 'rotational' sysfs
file to 0 if it matches make/model/whatever.

-- 
Jens Axboe

