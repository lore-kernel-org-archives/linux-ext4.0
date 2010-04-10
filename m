From: tytso@mit.edu
Subject: Re: ext4 dbench performance with CONFIG_PREEMPT_RT
Date: Sat, 10 Apr 2010 07:58:16 -0400
Message-ID: <20100410115816.GH1849@thunk.org>
References: <1270682478.3755.58.camel@localhost.localdomain>
 <87d3y8wrq5.fsf@basil.nowhere.org>
 <20100409233325.GF1849@thunk.org>
 <EA929A9653AAE14F841771FB1DE5A1365FE4FCD4BC@rrsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	john stultz <johnstul@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	keith maanthey <kmannth@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>
To: "Chen, Tim C" <tim.c.chen@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34000 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab0DJL72 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Apr 2010 07:59:28 -0400
Content-Disposition: inline
In-Reply-To: <EA929A9653AAE14F841771FB1DE5A1365FE4FCD4BC@rrsmsx501.amr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 09, 2010 at 05:48:23PM -0600, Chen, Tim C wrote:
>  
> Your patch did remove the contention on the j_state_lock for dbench
> in my testing with 64 threads.  The contention point now
> moves dcache_lock, which is also another tricky bottleneck.
> 
> In our other testing with FFSB that creates/rename/remove a lot of directories,
> we found that journal->j_revoke_lock was also heavily contended.
> 

Do you have lock_stat reports handy?  I'd love to take a look at them.

Thanks,

						- Ted
