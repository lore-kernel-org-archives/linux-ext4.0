From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] add hrtimer_sleep_ns helper function
Date: Tue, 19 Aug 2008 13:15:08 -0600
Message-ID: <20080819191508.GD8318@parisc-linux.org>
References: <20080806190819.GH27394@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, rwheeler@redhat.com,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50718 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbYHSTPK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2008 15:15:10 -0400
Content-Disposition: inline
In-Reply-To: <20080806190819.GH27394@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 06, 2008 at 03:08:19PM -0400, Josef Bacik wrote:
> -static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
> +static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode,
> +				int interruptible)
>  {
>  	hrtimer_init_sleeper(t, current);
>  
>  	do {
> -		set_current_state(TASK_INTERRUPTIBLE);
> +		set_current_state(interruptible ? TASK_INTERRUPTIBLE :
> +				  TASK_UNINTERRUPTIBLE);

I don't see any users (in this patch or the next) of people wanting
uninterruptible nanosleeps.  We shouldn't be introducing new
TASK_UNINTERRUPTIBLE users, but instead using TASK_KILLABLE if the user
really can't cope with signals in a sensible manner.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
