From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sat, 4 Apr 2009 08:57:28 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu>
 <20090404151649.GE5178@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125AbZDDP76 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Apr 2009 11:59:58 -0400
In-Reply-To: <20090404151649.GE5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sat, 4 Apr 2009, Jens Axboe wrote:
> 
> Big nack on this patch. Ted, this is EXACTLY where I told you we saw big
> write regressions (sqlite performance drops by a factor of 4-5). Do a
> git log on fs/buffer.c and see the original patch (which does what your
> patch does) and the later revert. No idea why you are now suggestion
> making that exact change?!

Jens, if I can re-create the 'fsync' times (I haven't yet), then the 
default scheduler _will_ be switched to AS.

> Low latency is nice, but not at the cost of 4-5x throughput for real
> world cases.

I'm sorry, but that fsync thing _is_ a real-world case, and it's the one 
that a hell of a lot more people care about than some idiotic sqlite 
throughput issue.

You have a test-case now. Consider it a priority, or consider CFQ to be a 
"for crazy servers that only care about throughput".

Quite frankly, the fact that I can see _seconds_ of latencies with a 
really good SSD is not acceptable. The fact that it is by design is even 
less so.

Latency is more important than throughput. It's that simple.

			Linus
