From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Thu, 17 Jan 2008 09:51:22 -0800 (PST)
Message-ID: <998992.73288.qm@web32604.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web32604.mail.mud.yahoo.com ([68.142.207.231]:42588 "HELO
	web32604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751595AbYAQRvX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2008 12:51:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message ----
> From: Mike Snitzer <snitzer@gmail.com>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>; Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; Linus Torvalds <torvalds@linux-foundation.org>
> Sent: Thursday, January 17, 2008 5:11:50 PM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> 
> I've backported Peter's perbdi patchset to 2.6.22.x.  I can share it
> with anyone who might be interested.
> 
> As expected, it has yielded 2.6.24-rcX level scaling.  Given the test
> result matrix you previously posted, 2.6.22.x+perbdi might give you
> what you're looking for (sans improved writeback that 2.6.24 was
> thought to be providing).  That is, much improved scaling with better
> O_DIRECT and network throughput.  Just a thought...
> 
> Unfortunately, my priorities (and computing resources) have shifted
> and I won't be able to thoroughly test Fengguang's new writeback patch
> on 2.6.24-rc8... whereby missing out on providing
> justification/testing to others on _some_ improved writeback being
> included in 2.6.24 final.
> 
> Not to mention the window for writeback improvement is all but closed
> considering the 2.6.24-rc8 announcement's 2.6.24 final release
> timetable.
> 
Mike,

 thanks for the offer, but the improved throughput is my #1 priority nowadays.
And while the better scaling for different targets is nothing to frown upon, the
much better scaling when writing to the same target would have been the big
winner for me.

 Anyway, I located the "offending" commit. Lets see what the experts say.


Cheers
Martin
