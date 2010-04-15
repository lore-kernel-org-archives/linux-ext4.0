From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] jbd2: yield the device queue when waiting for
	journal commits
Date: Thu, 15 Apr 2010 12:33:38 +0200
Message-ID: <20100415103337.GX27497@kernel.dk>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com> <1271279826-30294-5-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	vgoyal@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52896 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0DOKdj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Apr 2010 06:33:39 -0400
Content-Disposition: inline
In-Reply-To: <1271279826-30294-5-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 14 2010, Jeff Moyer wrote:
> This patch gets CFQ back in line with deadline for iozone runs, especially
> those testing small files + fsync timings.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  fs/jbd2/journal.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index c03d4dc..ce46df6 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -41,6 +41,7 @@
>  #include <linux/hash.h>
>  #include <linux/log2.h>
>  #include <linux/vmalloc.h>
> +#include <linux/blkdev.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/jbd2.h>
> @@ -580,6 +581,11 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
>  	while (tid_gt(tid, journal->j_commit_sequence)) {
>  		jbd_debug(1, "JBD: want %d, j_commit_sequence=%d\n",
>  				  tid, journal->j_commit_sequence);
> +                /*
> +		 * Give up our I/O scheduler time slice to allow the journal
> +		 * thread to issue I/O.
> +		 */
> +                blk_yield(journal->j_dev->bd_disk->queue);
>  		wake_up(&journal->j_wait_commit);
>  		spin_unlock(&journal->j_state_lock);
>  		wait_event(journal->j_wait_done_commit,

White space problem here.

-- 
Jens Axboe

