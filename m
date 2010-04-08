From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Thu, 8 Apr 2010 06:18:30 -0400
Message-ID: <DEFD67F2-FC52-49EF-9CBD-762CFAD94997@mit.edu>
References: <1270682478.3755.58.camel@localhost.localdomain> <20100408034631.GB23188@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: john stultz <johnstul@us.ibm.com>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:55611 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758389Ab0DHKSg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 06:18:36 -0400
In-Reply-To: <20100408034631.GB23188@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Apr 7, 2010, at 11:46 PM, tytso@MIT.EDU wrote:

> On Wed, Apr 07, 2010 at 04:21:18PM -0700, john stultz wrote:
>> Further using lockstat I was able to isolate it the contention down to
>> the journal j_state_lock, and then adding some lock owner tracking, I
>> was able to see that the lock owners were almost always in
>> start_this_handle, and jbd2_journal_stop when we saw contention (with
>> the freq breakdown being about 55% in jbd2_journal_stop and 45% in
>> start_this_handle).
> 
> Hmm....  I've taken a very close look at jbd2_journal_stop(), and I
> don't think we need to take j_state_lock() at all except if we need to
> call jbd2_log_start_commit().  t_outstanding_credits,
> h_buffer_credits, and t_updates are all documented (and verified by
> me) to be protected by the t_handle_lock spinlock.

BTW, it might be possible to remove the need to take t_handle_lock by converting t_outstanding_credits and t_updates to be atomic_t's, but that might have other performance impacts for other cases.  This patch shouldn't cause any performance regressions because we're just removing code.   As I said, I'm pretty sure it's safe but it could use more review and I should look at it again with fresh eyes, but in the meantime, it would be great if you could let us know what sort of results you get with this patch.

													- Ted

