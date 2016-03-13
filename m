From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Sat, 12 Mar 2016 23:27:23 -0500
Message-ID: <20160313042723.GC29218@thunk.org>
References: <697280a570654ae0aa1723fb7d11f51e@SGPMBX1004.APAC.bosch.com>
 <20151222150037.GB18178@quack.suse.cz>
 <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
 <20160105153050.GF14464@quack.suse.cz>
 <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37574 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbcCME1c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Mar 2016 23:27:32 -0500
Content-Disposition: inline
In-Reply-To: <20160107114736.GC8380@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 07, 2016 at 12:47:36PM +0100, Jan Kara wrote:
> 
> The problem is in all kernels starting with 3.8. Attached is a patch which
> should fix the issue. Can you test whether it fixes the problem for you?

Sorry, I missed this patch because it was attached to an discussion
thread.

> The problem is that although for delayed allocated blocks we write their
> contents immediately after allocating them, there is no guarantee that
> the IO scheduler or device doesn't reorder things

I don't think that's the problem.  In the commit thread when we call
blkdev_issue_flush() that acts as a barrier so the I/O scheduler won't
reorder writes after that point, which is before we write the commit
block.  Instead, I believe the problem is in ext4_writepages:

		ext4_journal_stop(handle);
		/* Submit prepared bio */
		ext4_io_submit(&mpd.io_submit);

Once we release the handle, the commit can start --- *before* we have
a chance to submit the I/O.   Oops.

I believe if we swap these two calls, it should fix the problem Huang
was seeing.

Jan, do you agree?

					- Ted
					
