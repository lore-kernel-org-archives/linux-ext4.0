From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Mon, 4 Jul 2016 23:38:24 -0400
Message-ID: <20160705033824.GD15193@thunk.org>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
 <20160701165339.GB6075@thunk.org>
 <20160701174041.GA30040@quack2.suse.cz>
 <20160701212634.GA14277@thunk.org>
 <20160704141435.GA29557@thunk.org>
 <20160704155107.GB12022@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52856 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbcGEDi3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jul 2016 23:38:29 -0400
Content-Disposition: inline
In-Reply-To: <20160704155107.GB12022@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 04, 2016 at 05:51:07PM +0200, Jan Kara wrote:
> On Mon 04-07-16 10:14:35, Ted Tso wrote:
> > This is what I'm currently testing; do you have objections to this?
> 
> Meh, I don't like it but it should work... Did you see any improvement with
> your change or are you just operating on the assumption that you want as
> few code while the handle is running as possible?

I haven't had a chance to try to benchmark it yet.  I've working at
home over the long (US) holiday weekend, and the high core-count
servers I need are on the internal work network, and it's pain to
access them from home.

I've just been tired of seeing the sort of analysis that can be found
at papers like:

https://www.usenix.org/system/files/conference/fast14/fast14-paper_kang.pdf

(And there's a ATC 2016 paper which shows that things haven't gotten
any better as well.)

Given that our massive lock bottlenecks come from the j_list_lock and
j_state_lock, and that most of the contention happens when we are
closing down a transaction for a commit, there is a pretty direct
correlation between handle lifetimes and the contention statistics on
the journal spinlocks.  Enough so that I've instrumented the handle
type and handle line number in the jbd2_handle_stats tracepoint, and
work to push down on the handle hold times have definitely helped our
contention numbers.

So I do have experimental evidence that reducing code while the handle
is running does matter in general.  I just don't have it for this
specific case yet....

Cheers,

							- Ted
