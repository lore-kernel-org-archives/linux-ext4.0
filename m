From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Fri, 18 Jan 2008 15:00:28 -0500
Message-ID: <170fa0d20801181200p50556132v3a9bafc9ad9e8c91@mail.gmail.com>
References: <166634.14296.qm@web32603.mail.mud.yahoo.com>
	 <20080118160123.GB11840@csn.ul.ie>
	 <alpine.LFD.1.00.0801180931250.2957@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Mel Gorman" <mel@csn.ul.ie>,
	"Martin Knoblauch" <spamtrap@knobisoft.de>,
	"Fengguang Wu" <wfg@mail.ustc.edu.cn>,
	"Peter Zijlstra" <peterz@infradead.org>, jplatte@naasa.net,
	"Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	James.Bottomley@steeleye.com
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.248]:49775 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760724AbYARUAb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jan 2008 15:00:31 -0500
Received: by hs-out-2122.google.com with SMTP id 54so925351hsz.5
        for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2008 12:00:30 -0800 (PST)
In-Reply-To: <alpine.LFD.1.00.0801180931250.2957@woody.linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 18, 2008 12:46 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 18 Jan 2008, Mel Gorman wrote:
> >
> > Right, and this is consistent with other complaints about the PFN of the
> > page mattering to some hardware.
>
> I don't think it's actually the PFN per se.
>
> I think it's simply that some controllers (quite probably affected by both
> driver and hardware limits) have some subtle interactions with the size of
> the IO commands.
>
> For example, let's say that you have a controller that has some limit X on
> the size of IO in flight (whether due to hardware or driver issues doesn't
> really matter) in addition to a limit on the size of the scatter-gather
> size. They all tend to have limits, and they differ.
>
> Now, the PFN doesn't matter per se, but the allocation pattern definitely
> matters for whether the IO's are physically contiguous, and thus matters
> for the size of the scatter-gather thing.
>
> Now, generally the rule-of-thumb is that you want big commands, so
> physical merging is good for you, but I could well imagine that the IO
> limits interact, and end up hurting each other. Let's say that a better
> allocation order allows for bigger contiguous physical areas, and thus
> fewer scatter-gather entries.
>
> What does that result in? The obvious answer is
>
>   "Better performance obviously, because the controller needs to do fewer
>    scatter-gather lookups, and the requests are bigger, because there are
>    fewer IO's that hit scatter-gather limits!"
>
> Agreed?
>
> Except maybe the *real* answer for some controllers end up being
>
>   "Worse performance, because individual commands grow because they don't
>    hit the per-command limits, but now we hit the global size-in-flight
>    limits and have many fewer of these good commands in flight. And while
>    the commands are larger, it means that there are fewer outstanding
>    commands, which can mean that the disk cannot scheduling things
>    as well, or makes high latency of command generation by the controller
>    much more visible because there aren't enough concurrent requests
>    queued up to hide it"
>
> Is this the reason? I have no idea. But somebody who knows the AACRAID
> hardware and driver limits might think about interactions like that.
> Sometimes you actually might want to have smaller individual commands if
> there is some other limit that means that it can be more advantageous to
> have many small requests over a few big onees.
>
> RAID might well make it worse. Maybe small requests work better because
> they are simpler to schedule because they only hit one disk (eg if you
> have simple striping)! So that's another reason why one *large* request
> may actually be slower than two requests half the size, even if it's
> against the "normal rule".
>
> And it may be that that AACRAID box takes a big hit on DIO exactly because
> DIO has been optimized almost purely for making one command as big as
> possible.
>
> Just a theory.

Oddly enough, I'm seeing the opposite here with 2.6.22.16 w/ AACRAID
configured with 5 LUNS (each 2disk HW RAID0, 1024k stripesz).  That
is, with dd the avgrqsiz (from iostat) shows DIO to be ~130k whereas
non-DIO is a mere ~13k! (NOTE: with aacraid, max_hw_sectors_kb=192)

DIO cmdline:  dd if=/dev/zero of=/dev/sdX bs=8192k count=1k
non-DIO cmdline: dd if=/dev/zero of=/dev/sdX bs=8192k count=1k

DIO is ~80MB/s on all 5 LUNs for a total of ~400MB/s
non-DIO is only ~12MB on all 5 LUNs for a mere ~70MB/s aggregate
(deadline w/ nr_requests=32)

Calls into question the theory of small requests being beneficial for
AACRAID.  Martin, what are you seeing for the avg request size when
you're conducting your AACRAID tests?

I can fire up 2.6.24-rc8 in short order to see if things are vastly
improved (as Martin seems to indicate that he is happy with AACRAID on
2.6.24-rc8).  Although even Martin's AACRAID numbers from 2.6.19.2 are
still quite good (relative to mine).  Martin can you share any tuning
you may have done to get AACRAID to where it is for you right now?

regards,
Mike
