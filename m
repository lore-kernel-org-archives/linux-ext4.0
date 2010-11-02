From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: ext4_lazyinit_thread: 'ret' may be used uninitialized in this
 function
Date: Tue, 2 Nov 2010 15:16:39 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.1011021513240.16869@dhcp-lab-213.englab.brq.redhat.com>
References: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de> <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com> <20101102182911.GE25614@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0KBTQw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Nov 2010 15:16:52 -0400
In-Reply-To: <20101102182911.GE25614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2 Nov 2010, Ted Ts'o wrote:

> On Mon, Nov 01, 2010 at 04:27:26PM +0100, Lukas Czerner wrote:
> > 
> > thank you for noticing this, because I actually do not see the warning
> > (I wonder why...), but it is definitely a bug, so the trivial patch below
> > should fix that.
> 
> This is a slightly less trivial fix that eliminates the need for the
> "ret" variable entirely.
> 
> 						- Ted
> 
> commit e048924538f0c62d18306e2fea0e22dac0140f6e
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Nov 2 14:19:30 2010 -0400
> 
>     ext4: "ret" may be used uninitialized in ext4_lazyinit_thread()
>     
>     Newer GCC's reported the following build warning:
>     
>        fs/ext4/super.c: In function 'ext4_lazyinit_thread':
>        fs/ext4/super.c:2702: warning: 'ret' may be used uninitialized in this function
>     
>     Fix it by removing the need for the ret variable in the first place.
>     
>     Signed-off-by: "Lukas Czerner" <lczerner@redhat.com>
>     Reported-by: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8d1d942..4d7ef31 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2699,7 +2699,6 @@ static int ext4_lazyinit_thread(void *arg)
>  	struct ext4_li_request *elr;
>  	unsigned long next_wakeup;
>  	DEFINE_WAIT(wait);
> -	int ret;
>  
>  	BUG_ON(NULL == eli);
>  
> @@ -2723,13 +2722,12 @@ cont_thread:
>  			elr = list_entry(pos, struct ext4_li_request,
>  					 lr_request);
>  
> -			if (time_after_eq(jiffies, elr->lr_next_sched))
> -				ret = ext4_run_li_request(elr);
> -
> -			if (ret) {
> -				ret = 0;
> -				ext4_remove_li_request(elr);
> -				continue;
> +			if (time_after_eq(jiffies, elr->lr_next_sched)) {
> +				if (ext4_run_li_request(elr) != 0) {
> +					/* error, remove the lazy_init job */

It is not removed only in the case of error, but even if it hits the
last group, so I would just omit the "error" part.

> +					ext4_remove_li_request(elr);
> +					continue;
> +				}
>  			}
>  
>  			if (time_before(elr->lr_next_sched, next_wakeup))
> 

Otherwise looks good to me.

-Lukas
