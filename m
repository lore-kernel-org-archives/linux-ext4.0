From: "Chen, Tim C" <tim.c.chen@intel.com>
Subject: RE: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Fri, 9 Apr 2010 17:48:23 -0600
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365FE4FCD4BC@rrsmsx501.amr.corp.intel.com>
References: <1270682478.3755.58.camel@localhost.localdomain>
 <87d3y8wrq5.fsf@basil.nowhere.org> <20100409233325.GF1849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: john stultz <johnstul@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: "tytso@mit.edu" <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54167 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab0DIXsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Apr 2010 19:48:25 -0400
In-Reply-To: <20100409233325.GF1849@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 

>tytso@mit.edu wrote 
>
>Yeah, I'm very much aware of that.  What worries me is that locking
>problems in the jbd2 layer could be very hard to debug, so we need to
>make sure we have some really good testing as we make any changes.
>
>Not taking the j_state_lock spinlock in jbd2_stop_lock() was relatively
>easy to prove to be safe, but I'm really worried about
>start_this_handle() the locking around that is going to be subtle, and
>it's not just the specific fields in the transaction and journal
>handle.
>
>And even with the jbd2_stop_lock() change, I'd really prefer some
>pretty exhaustive testing, including power fail testing, just to make
>sure we're in practice when/if we make more subtle or more invasive
>changes to the jbd2 layer...
>
>So I'm mot waving the red flag, but the yellow flag (as they would say
>in auto racing circles).
>

Your patch did remove the contention on the j_state_lock for dbench
in my testing with 64 threads.  The contention point now
moves dcache_lock, which is also another tricky bottleneck.

In our other testing with FFSB that creates/rename/remove a lot of directories,
we found that journal->j_revoke_lock was also heavily contended.

Tim