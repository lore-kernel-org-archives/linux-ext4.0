From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Fri, 18 Jan 2008 11:23:15 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0801181109410.2957@woody.linux-foundation.org>
References: <903015.63912.qm@web32611.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mel Gorman <mel@csn.ul.ie>, Fengguang Wu <wfg@mail.ustc.edu.cn>,
	Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	James.Bottomley@steeleye.com
To: Martin Knoblauch <spamtrap@knobisoft.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47031 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758982AbYARTYI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2008 14:24:08 -0500
In-Reply-To: <903015.63912.qm@web32611.mail.mud.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 18 Jan 2008, Martin Knoblauch wrote:
>
>  just to make one thing clear - I am not so much concerned about the
> performance of AACRAID. It is OK with or without Mel's patch. It is
> better with Mel's patch. The regression in DIO compared to 2.6.19.2 is
> completely independent of Mel's stuff.
> 
>  What interests me much more is the behaviour of the CCISS+LVM based
> system. Here I see a huge benefit of reverting Mel's patch.

Ok, I just got your usage cases confused.

The argument stays the same: some controllers/drivers may have subtle 
behavioural differences that come from the IO limits themselves.

So it wasn't AACRAID, it was CCISS+LVM. The argument is the same: it may 
well be that the *bigger* IO sizes are actually what hurts, even if the 
conventional wisdom is traditionally that bigger submissions are better.

>  At least, rc1-rc5 have shown that the CCISS system can do well. Now
> the question is which part of the system does not cope well with the
> larger IO sizes? Is it the CCISS controller, LVM or both. I am open to
> suggestions on how to debug that. 

I think you need to ask the MD/DM people for suggestions.. Who aren't cc'd 
here.

		Linus
