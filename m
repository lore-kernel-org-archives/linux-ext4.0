From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext3 leaking buffer_heads
Date: Mon, 23 Mar 2009 17:00:37 -0500
Message-ID: <49C80685.9060800@redhat.com>
References: <49C7E959.4010000@cs.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Don Porter <porterde@cs.utexas.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45618 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZCWWBH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Mar 2009 18:01:07 -0400
In-Reply-To: <49C7E959.4010000@cs.utexas.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don Porter wrote:
> Hi,
> 
> It appears that the ext3 journal code has a slow leak of buffer_head 
> structs.  Try this simple script:
> 
> perl -e 'while(1){ `sync`; }'
> 
> and monitor the count of allocated buffer_head structs in 
> /proc/slabinfo, and it seems to increase without bound.  Even after this 
> script is killed and the machine is left idle for several minutes, the 
> count of buffer heads doesn't substantially decrease.
> 
> Looking around at various machines I have access to, the count of 
> allocated buffer_heads roughly correlates with uptime when using ext3.  
> This is a slow leak - one would likely have to run this script for a day 
> or more to drain enough lowmem to cause problems.
> 
> Other info:  I have only tried this on x86 machines, but I have tried 
> both 2.6.22.6 and 2.6.28.8, and both have the problem.  I am running 
> Ubuntu 7.10 on top of these kernels, but the kernels were built directly 
> from kernel.org tarballs.
> 
> Any advice or help with this issue is greatly appreciated. 

Without investigating too far yet, I did try this, and did indeed see
the buffer_head usage go up while the script runs.

However, if I did:

# echo 3 > /proc/sys/vm/drop_caches

before the script, and noted the total nr. of buffer heads in use, and
then did it again after the script had been running a while, I got back
to the same (low) count of buffer heads in use.   So I don't think this
is a leak as in "the system has lost all accounting of these buffer
heads" at least... but it'd be interesting to know what the reason for
the increase is, I'm not sure offhand.

-Eric



