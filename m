From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix lazyinit thread prevent from sleep
Date: Mon, 25 Oct 2010 10:46:34 -0400
Message-ID: <20101025144634.GD16981@thunk.org>
References: <1287773865-31168-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46678 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493Ab0JYOqh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 10:46:37 -0400
Content-Disposition: inline
In-Reply-To: <1287773865-31168-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 22, 2010 at 08:57:45PM +0200, Lukas Czerner wrote:
> In my test lazyinit threat (in linux-next tree) consumes too much CPU
> (90%). The reason is that there is a bug preventing the threat to sleep
> and hence it keeps walking the li_request_list until the time for next
> scheduled request comes.
> 
> It is because the next_wakeup is originally set to jiffies - 1 so the
> thread is assuming that there is no reason to sleep, because the time
> for next scheduled event is already came, however that is not true.
> 
> I have fixed that by setting next_wakeup to MAX_JIFFY_OFFSET initially
> and than setting value of the next scheduled request (the one with the
> smallest lr_next_sched value). It has been tested and now the CPU
> utilization of lazyinit thread is under 1% (with one request in the list).
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, I've merged this into the lazy-init patch in the ext4 patch queue.

	     	    	      	  	    	  - Ted
