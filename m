From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] update i_disksize coherently with block allocation
Date: Tue, 26 Aug 2014 08:26:40 -0400
Message-ID: <20140826122640.GI11317@thunk.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
 <1408707147-22482-6-git-send-email-dmonakhov@openvz.org>
 <20140826011310.GB11317@thunk.org>
 <87egw3ae0x.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49633 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbaHZM0u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Aug 2014 08:26:50 -0400
Content-Disposition: inline
In-Reply-To: <87egw3ae0x.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2014 at 11:47:10AM +0400, Dmitry Monakhov wrote:
> No. patch was written like this from very beginning. 
> By logic is follows. We must update i_disksize in the same transaction
> Before the patch i_disksize was updated only if requested range was fully completed.
> But we also have to update it in case of error. And patch fix what.

Ok, I'll update the commit description to make it clear that what
we're fixing is on the error path.

Thanks!!

						- Ted

P.S.  I haven't forgotten about your 1/5 patch; I'm just currently
prioritizing patches that will get pushed to Linus during the current
development cycle.  I'll do a second pass for cleanup and new feature
commits (i.e., things that aren't stable kernel fodder) after I push
fixes to Linus for -rc3.

