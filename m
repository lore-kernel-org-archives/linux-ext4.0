From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: remove __jbd2_journal_clean_checkpoint_list to
 solve scalability issue
Date: Thu, 11 Sep 2014 10:13:57 -0400
Message-ID: <20140911141357.GA29020@thunk.org>
References: <1410430193-6112-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20140911135147.GD30901@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
	linux-ext4@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50988 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaIKOOD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 10:14:03 -0400
Content-Disposition: inline
In-Reply-To: <20140911135147.GD30901@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 03:51:47PM +0200, Jan Kara wrote:
> 
> I'm not yet convinced that just dropping
> __jbd2_journal_clean_checkpoint_list() is the right thing to do. Some
> periodic cleaning of checkpointed entries would seem reasonable so that we
> don't save all that work for the moment we run out of space in the journal.
> I'll think how to do that in a more efficient way...

I'm sure Jan is aware of this, but for those following along, when we
completely run out of space in the journal, and we have to do a formal
checkpoint operation --- at which point, all file system activity has
to grind to a halt, at which point *all* of the CPU cores will be dead
in the water, which is bad for scalability, not to mention really
annoying users whose terminals are stalled or whose web requests are
completely stuck until the checkpoint completes.   :-)

So being able to clean up the journal so we don't have to do a forced
checkpoint operation which requires waiting for I/O operations is
rather important from a performance and usability point of view....

Cheers,

						- Ted
