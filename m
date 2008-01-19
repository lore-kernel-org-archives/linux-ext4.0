From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Sat, 19 Jan 2008 02:24:15 -0800 (PST)
Message-ID: <544455.59143.qm@web32602.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mel Gorman <mel@csn.ul.ie>, Fengguang Wu <wfg@mail.ustc.edu.cn>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	James.Bottomley@steeleye.com
To: Mike Snitzer <snitzer@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:45624 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752902AbYASKYQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Jan 2008 05:24:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message ----
> From: Mike Snitzer <snitzer@gmail.com>
> To: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Mel Gorman <mel@csn.ul.ie>; Martin Knoblauch <spamtrap@knobisoft.de>; Fengguang Wu <wfg@mail.ustc.edu.cn>; Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; James.Bottomley@steeleye.com
> Sent: Friday, January 18, 2008 11:47:02 PM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> > I can fire up 2.6.24-rc8 in short order to see if things are vastly
> > improved (as Martin seems to indicate that he is happy with
> > AACRAID on 2.6.24-rc8).  Although even Martin's AACRAID
> > numbers from 2.6.19.2
> 
 > are still quite good (relative to mine).  Martin can you share any tuning
> > you may have done to get AACRAID to where it is for you right now?
Mike,

 I have always been happy with the AACRAID box compared to the CCISS system. Even with the "regression" in 2.6.24-rc1..rc5 it was more than acceptable to me. For me the differences between 2.6.19  and 2.6.24-rc8 on the AACRAID setup are:

- 11% (single stream) to 25% (dual/triple stream) regression in DIO. Something I do not care much about. I just measure it for reference.
+ the very nice behaviour when writing to different targets (mix3), which I attribute to Peter's per-dbi stuff.

 And until -rc6 I was extremely pleased with the cool speedup I saw on my CCISS boxes. This would have been the next "production" kernel for me. But lets discuss this under a seperate topic. It has nothing to do with the original wait-io issue.

 Oh, before I forget. There has been no tuning for the AACRAID. The system is an IBM x3650 with built in AACRAID and battery backed write cache. The disks are 6x142GB/15krpm in a RAID5 setup. I see one big difference between your an my tests. I do 1MB writes to simulate the behaviour of the real applications, while yours seem to be much smaller.
 
Cheers
Martin
