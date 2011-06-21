From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Tue, 21 Jun 2011 20:26:25 +0900
Message-ID: <4E007FE1.8000704@sx.jp.nec.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34010 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab1FUL2z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 07:28:55 -0400
In-Reply-To: <20110617031814.GA31884@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/06/17 12:18, Ted Ts'o wrote:
> It perhaps might be useful to also articulate what are the goals of
> this metric.  Is just just to decide which files should be
> defragmented, and which should be left alone?  Or do you want to be
> able to compare which file is "worse off"?

I decided to implement a fragmentation score for the two purposes:
one is for filefrag that outputs the score to decide which files should be
defragmented, and the other is for e4defrag that compares two files'
fragmentation to prevent the worse fragmentation.

> I can imagine two files that have a score of 100%, but one is much
> worse off than the other.  Does that matter?  It may or might not,
> depending how you plan to use the fragmentation score, both now and in
> the future.  So it might be good to explicitly declare what are the
> goals for this metrics, and its planned use cases.

Certainly, the same fragmentation score doesn't always mean the same
fragmentation. Just as Andreas said, "fragments per MB" is a good idea. It's
easy to understand, and other filesystem also would be able to use it without
change. Moreover, there is no worry about what threshold we use to
the application.

What do you think about this idea?

Regards,
Kazuya Mio
