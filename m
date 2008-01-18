From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Fri, 18 Jan 2008 11:01:11 -0800 (PST)
Message-ID: <903015.63912.qm@web32611.mail.mud.yahoo.com>
References: <alpine.LFD.1.00.0801180931250.2957@woody.linux-foundation.org>
Reply-To: spamtrap@knobisoft.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Martin Knoblauch <spamtrap@knobisoft.de>,
	Fengguang Wu <wfg@mail.ustc.edu.cn>,
	Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	James.Bottomley@steeleye.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web32611.mail.mud.yahoo.com ([68.142.207.238]:28691 "HELO
	web32611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757770AbYARTBN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2008 14:01:13 -0500
In-Reply-To: <alpine.LFD.1.00.0801180931250.2957@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--- Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 18 Jan 2008, Mel Gorman wrote:
> > 
> > Right, and this is consistent with other complaints about the PFN
> > of the page mattering to some hardware.
> 
> I don't think it's actually the PFN per se.
> 
> I think it's simply that some controllers (quite probably affected by
> both  driver and hardware limits) have some subtle interactions with
> the size of  the IO commands.
> 
> For example, let's say that you have a controller that has some limit
> X on  the size of IO in flight (whether due to hardware or driver
> issues doesn't  really matter) in addition to a limit on the size
> of the scatter-gather  size. They all tend to have limits, and
> they differ.
> 
> Now, the PFN doesn't matter per se, but the allocation pattern
> definitely  matters for whether the IO's are physically
> contiguous, and thus matters  for the size of the scatter-gather
> thing.
> 
> Now, generally the rule-of-thumb is that you want big commands, so 
> physical merging is good for you, but I could well imagine that the
> IO  limits interact, and end up hurting each other. Let's say that a
> better  allocation order allows for bigger contiguous physical areas,
> and thus  fewer scatter-gather entries.
> 
> What does that result in? The obvious answer is
> 
>   "Better performance obviously, because the controller needs to do
> fewer scatter-gather lookups, and the requests are bigger, because
> there are     fewer IO's that hit scatter-gather limits!"
> 
> Agreed?
> 
> Except maybe the *real* answer for some controllers end up being
> 
>   "Worse performance, because individual commands grow because they
> don't  hit the per-command limits, but now we hit the global
> size-in-flight limits and have many fewer of these good commands in
> flight. And while the commands are larger, it means that there
> are fewer outstanding commands, which can mean that the disk
> cannot scheduling things as well, or makes high latency of command
> generation by the controller much more visible because there aren't
> enough concurrent requests queued up to hide it"
> 
> Is this the reason? I have no idea. But somebody who knows the
> AACRAID hardware and driver limits might think about interactions
> like that. Sometimes you actually might want to have smaller 
> individual commands if there is some other limit that means that
> it can be more advantageous to have many small requests over a
> few big onees.
> 
> RAID might well make it worse. Maybe small requests work better
> because they are simpler to schedule because they only hit one
> disk (eg if you have simple striping)! So that's another reason
> why one *large* request may actually be slower than two requests
> half the size, even if it's against the "normal rule".
> 
> And it may be that that AACRAID box takes a big hit on DIO
> exactly because DIO has been optimized almost purely for making
> one command as big as possible.
> 
> Just a theory.
> 
> 		Linus

 just to make one thing clear - I am not so much concerned about the
performance of AACRAID. It is OK with or without Mel's patch. It is
better with Mel's patch. The regression in DIO compared to 2.6.19.2 is
completely independent of Mel's stuff.

 What interests me much more is the behaviour of the CCISS+LVM based
system. Here I see a huge benefit of reverting Mel's patch.

 I dirtied the system after reboot as Mel suggested (24 parallel kernel
build) and repeated the tests. The dirtying did not make any
difference. Here are the results:

Test      -rc8    -rc8-without-Mels-Patch
dd1       57      94
dd1-dir   87      86
dd2       2x8.5   2x45
dd2-dir   2x43    2x43
dd3       3x7     3x30
dd3-dir   3x28.5  3x28.5
mix3      59,2x25 98,2x24

 The big IO size with Mel's patch really has a devastating effect on
the parallel write. Nowhere near the value one would expect, while the
numbers are perfect without Mel's patch as in rc1-rc5. To bad I did not
see this earlier. Maybe we could have found a solution for .24.

 At least, rc1-rc5 have shown that the CCISS system can do well. Now
the question is which part of the system does not cope well with the
larger IO sizes? Is it the CCISS controller, LVM or both. I am open to
suggestions on how to debug that. 

Cheers
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
