From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 01/42] percpu counter: clean up
	percpu_counter_sum_and_set()
Date: Thu, 9 Oct 2008 12:52:33 -0400
Message-ID: <20081009165233.GH17512@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu> <1223525160-9887-2-git-send-email-tytso@mit.edu> <1223542372.7382.30.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52508 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752861AbYJIQwg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 12:52:36 -0400
Content-Disposition: inline
In-Reply-To: <1223542372.7382.30.camel@lappy.programming.kicks-ass.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 09, 2008 at 10:52:52AM +0200, Peter Zijlstra wrote:
> On Thu, 2008-10-09 at 00:05 -0400, Theodore Ts'o wrote:
> > From: Mingming Cao <cmm@us.ibm.com>
> > 
> > percpu_counter_sum_and_set() and percpu_counter_sum() is the same except
> > the former updates the global counter after accounting.  Since we are
> > taking the fbc->lock to calculate the precise value of the counter in
> > percpu_counter_sum() anyway, it should simply set fbc->count too, as the
> > percpu_counter_sum_and_set() does.
> > 
> > This patch merge these two interfaces into one.
> 
> I totally missed the patch introducing this _and_set() horror, but this
> does look like a good cleanup.

Note: this patch was in the -mm tree (Andrew signed off on it), but
given that a number of ext4 patches depend on it, we have a copy of it
in the ext4 tree.

						- Ted
