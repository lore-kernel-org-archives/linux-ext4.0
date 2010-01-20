From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 performance benchmarks
Date: Wed, 20 Jan 2010 13:01:17 -0600
Message-ID: <4B5752FD.40207@redhat.com>
References: <4B56B7FD.4080506@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: surbhi.palande@canonical.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab0ATTB1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jan 2010 14:01:27 -0500
In-Reply-To: <4B56B7FD.4080506@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Surbhi Palande wrote:
> Hi Guys,
> 
> The following article says that ext4 performance has plummeted
> since the 2.6.31 kernel. Can someone please comment on this?
> 
> http://www.phoronix.com/scan.php?page=article&item=ext4_then_now&num=1

For what it's worth, I don't put much if any stock in these benchmarks.

Against my better judgement I grepped the code to see what they actually
ran (iozone -s 2048M -i0 -i1 -f testfile AFAICT) and I saw no such
regression.  Of course I don't have an atom CPU to test on ...

> Are large reads giving a lower performance for the kernels post 2.6.30?
> Is this performance attributed to some particular ext4 features/patches?

No idea what their issue is, they don't fully characterize the test
environment - at least not in a way that's easy for me to reproduce.
If the results contained the commandline that was run, the raw output,
and an archive of test environment information it'd be a big help -
otherwise we're just chasing ghosts.

(for example: did ubuntu change the default scheduler between .30
and .31?  Frankly, I'm not going to go look)

In other words there's not enough context in their results to
answer your question.

> Does anyone maintain the benchmarking results for ext4 after any
> feature/big patches are applied?

It gets spot-checked, but we could always do a better job.

-Eric
