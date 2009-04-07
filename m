From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Tue, 7 Apr 2009 11:22:47 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904071121060.27889@localhost.localdomain>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
 <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu>
 <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain> <49D8E71F.6000703@rtr.ca> <49D91B31.90300@garzik.org> <20090405164831.7ad01c20@infradead.org> <49D99775.9030104@garzik.org> <alpine.LFD.2.00.0904071107500.27889@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Arjan van de Ven <arjan@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758469AbZDGS2U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 14:28:20 -0400
In-Reply-To: <alpine.LFD.2.00.0904071107500.27889@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Tue, 7 Apr 2009, Linus Torvalds wrote:
> 
> Something like this might be a good idea. 

And it clearly is "something like".

> I've seen several SSD's that do _not_ do that whole RPM == 1 thing, but 
> they have "SSD" in their names. 
> 
> I forget how the ID is stored (I have this memory of it being big-endian 
> 16-bit words or something crazy like that?), but aside from fixing up that 
> kind of crazyness, maybe something like this is worth it?

Yeah, just checked. My memory wasn't wrong, and that code can not possibly 
work. Not only isn't that whole field generally NUL-terminated at all, my 
recollection of odd 16-bit byte ordering was right.

So that patch is crap. 

But the _concept_ may be worth pursuing. 

			Linus
