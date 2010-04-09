From: Andi Kleen <andi@firstfloor.org>
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Fri, 09 Apr 2010 17:49:54 +0200
Message-ID: <87d3y8wrq5.fsf@basil.nowhere.org>
References: <1270682478.3755.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
	Darren Hart <dvhltc@us.ibm.com>, tim.c.chen@intel.com
To: john stultz <johnstul@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:37958 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0DIPuB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Apr 2010 11:50:01 -0400
In-Reply-To: <1270682478.3755.58.camel@localhost.localdomain> (john stultz's message of "Wed, 07 Apr 2010 16:21:18 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

john stultz <johnstul@us.ibm.com> writes:
>
> Further using lockstat I was able to isolate it the contention down to
> the journal j_state_lock, and then adding some lock owner tracking, I
> was able to see that the lock owners were almost always in
> start_this_handle, and jbd2_journal_stop when we saw contention (with
> the freq breakdown being about 55% in jbd2_journal_stop and 45% in
> start_this_handle).

FWIW we've been also seeing this on larger systems without RT.
The journal locks are the number one contention in some workloads.
So it's not just a RT problem.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
