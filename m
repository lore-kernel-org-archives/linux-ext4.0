From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sat, 4 Apr 2009 15:18:26 -0400
Message-ID: <20090404191826.GE9812@mit.edu>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33033 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZDDTSe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Apr 2009 15:18:34 -0400
Content-Disposition: inline
In-Reply-To: <20090404151649.GE5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 04, 2009 at 05:16:50PM +0200, Jens Axboe wrote:
> Big nack on this patch. Ted, this is EXACTLY where I told you we saw big
> write regressions (sqlite performance drops by a factor of 4-5). Do a
> git log on fs/buffer.c and see the original patch (which does what your
> patch does) and the later revert. 

You mean this revert, right?

commit 78f707bfc723552e8309b7c38a8d0cc51012e813
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Feb 17 13:59:08 2009 +0100

    block: revert part of 18ce3751ccd488c78d3827e9f6bf54e6322676fb
    
    The above commit added WRITE_SYNC and switched various places to using
    that for committing writes that will be waited upon immediately after
    submission. However, this causes a performance regression with AS and CFQ
    for ext3 at least, since sync_dirty_buffer() will submit some writes with
    WRITE_SYNC while ext3 has sumitted others dependent writes without the sync
    flag set. This causes excessive anticipation/idling in the IO scheduler
    because sync and async writes get interleaved, causing a big performance
    regression for the below test case (which is meant to simulate sqlite
    like behaviour)....

OK, let me test things out first, but note that with the changes that
Linus has already accepted, this may not be an issue --- since we've
now fixed ext3 to submit those dependent writes with the SYNC flag
now.  So I'm not sure the performance regression still applies, but
I'll test using the test case supplied in the rest of the commit log
and get back to you.

						- Ted
