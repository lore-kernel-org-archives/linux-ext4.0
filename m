From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] fs: Improve filesystem freezing handling
Date: Fri, 13 Jan 2012 12:26:43 +1100
Message-ID: <20120113012643.GF2806@dastard>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
 <1326331253-6497-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:40589 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756792Ab2AMB0r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 20:26:47 -0500
Content-Disposition: inline
In-Reply-To: <1326331253-6497-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 12, 2012 at 02:20:50AM +0100, Jan Kara wrote:
> + *
> + * Decrement number of writers to the filesystem and wake up possible
> + * waiters wanting to freeze the filesystem.
> + */
> +void sb_end_write(struct super_block *sb)
> +{
> +#ifdef CONFIG_SMP
> +	this_cpu_dec(sb->s_writers);
> +#else
> +	preempt_disable();
> +	sb->s_writers--;
> +	preempt_enable();
> +#endif

I really dislike this type of open coded per-cpu counter
implementation. I can't see that there is no good reason to use it
over percpu_counters here which abstract all this mess away.

i.e. it is relatively rare that the per-cpu count will nest
greater than the percpu_counter batch size (needs more than 32
concurrent blocked active writes per CPU), so there is no
significant overhead to using the percpu_counters here.

Indeed, if there are that many blocked writes per CPU, then the
overhead of an occasional global counter update is going to be lost
in the noise of everything else that is going on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
