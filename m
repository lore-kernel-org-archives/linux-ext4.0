From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Fri, 18 Jan 2008 09:46:26 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0801180931250.2957@woody.linux-foundation.org>
References: <166634.14296.qm@web32603.mail.mud.yahoo.com> <20080118160123.GB11840@csn.ul.ie>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Martin Knoblauch <spamtrap@knobisoft.de>,
	Fengguang Wu <wfg@mail.ustc.edu.cn>,
	Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	James.Bottomley@steeleye.com
To: Mel Gorman <mel@csn.ul.ie>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbYARRsG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2008 12:48:06 -0500
In-Reply-To: <20080118160123.GB11840@csn.ul.ie>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 18 Jan 2008, Mel Gorman wrote:
> 
> Right, and this is consistent with other complaints about the PFN of the
> page mattering to some hardware.

I don't think it's actually the PFN per se.

I think it's simply that some controllers (quite probably affected by both 
driver and hardware limits) have some subtle interactions with the size of 
the IO commands.

For example, let's say that you have a controller that has some limit X on 
the size of IO in flight (whether due to hardware or driver issues doesn't 
really matter) in addition to a limit on the size of the scatter-gather 
size. They all tend to have limits, and they differ.

Now, the PFN doesn't matter per se, but the allocation pattern definitely 
matters for whether the IO's are physically contiguous, and thus matters 
for the size of the scatter-gather thing.

Now, generally the rule-of-thumb is that you want big commands, so 
physical merging is good for you, but I could well imagine that the IO 
limits interact, and end up hurting each other. Let's say that a better 
allocation order allows for bigger contiguous physical areas, and thus 
fewer scatter-gather entries.

What does that result in? The obvious answer is

  "Better performance obviously, because the controller needs to do fewer 
   scatter-gather lookups, and the requests are bigger, because there are 
   fewer IO's that hit scatter-gather limits!"

Agreed?

Except maybe the *real* answer for some controllers end up being

  "Worse performance, because individual commands grow because they don't 
   hit the per-command limits, but now we hit the global size-in-flight 
   limits and have many fewer of these good commands in flight. And while 
   the commands are larger, it means that there are fewer outstanding 
   commands, which can mean that the disk cannot scheduling things 
   as well, or makes high latency of command generation by the controller 
   much more visible because there aren't enough concurrent requests 
   queued up to hide it"

Is this the reason? I have no idea. But somebody who knows the AACRAID 
hardware and driver limits might think about interactions like that. 
Sometimes you actually might want to have smaller individual commands if 
there is some other limit that means that it can be more advantageous to 
have many small requests over a few big onees.

RAID might well make it worse. Maybe small requests work better because 
they are simpler to schedule because they only hit one disk (eg if you 
have simple striping)! So that's another reason why one *large* request 
may actually be slower than two requests half the size, even if it's 
against the "normal rule".

And it may be that that AACRAID box takes a big hit on DIO exactly because 
DIO has been optimized almost purely for making one command as big as 
possible.

Just a theory.

		Linus
