From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Date: Thu, 27 May 2010 14:32:33 -0700
Message-ID: <20100527143233.836b2c47.akpm@linux-foundation.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-2-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, jens.axboe@oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757203Ab0E0VdO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 May 2010 17:33:14 -0400
In-Reply-To: <1274784852-30502-2-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 25 May 2010 20:54:07 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: From: Jens Axboe <jens.axboe@oracle.com>
> 
> Trace queue/sched/exec parts of the writeback loop.

It would be most useful if this patchset's description provided sample
tracing output, so we can see what the patch is actually providing us.

> -#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
> -
> -/*
> - * We don't actually have pdflush, but this one is exported though /proc...
> - */
> -int nr_pdflush_threads;
> -
>  /*
>   * Passed into wb_writeback(), essentially a subset of writeback_control
>   */
> @@ -63,6 +57,16 @@ struct bdi_work {
>  	unsigned long state;		/* flag bits, see WS_* */
>  };
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/writeback.h>
> +
> +#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)

Could/should be implemented in C.

> +/*
> + * We don't actually have pdflush, but this one is exported though /proc...
> + */
> +int nr_pdflush_threads;

So this is always zero now?

We don't want to keep it forever.  Add a
printk_once("nr_pdflush_threads is deprecated") when someone reads it,
remove it in 2014.

>
> ...
>
> --- /dev/null
> +++ b/include/trace/events/writeback.h
> @@ -0,0 +1,171 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM writeback
> +
> +#if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)

Seems wrong.  If you define TRACE_HEADER_MULTI_READ then include this
header twice, things explode.  Which negates the purpose of
_TRACE_WRITEBACK_H.

> +#define _TRACE_WRITEBACK_H
> +
> +#include <linux/backing-dev.h>
> +#include <linux/writeback.h>
> +
> +TRACE_EVENT(writeback_queue,
> +
> +	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_args *args),
> +
> +	TP_ARGS(bdi, args),
> +
> +	TP_STRUCT__entry(
> +		__array(char,		name,		16)
> +		__field(long,		nr_pages)
> +		__field(int,		sb)
> +		__field(int,		sync_mode)
> +		__field(int,		for_kupdate)
> +		__field(int,		range_cyclic)
> +		__field(int,		for_background)
> +	),
> +
> +	TP_fast_assign(
> +		strncpy(__entry->name, dev_name(bdi->dev), 16);
> +		__entry->nr_pages	= args->nr_pages;
> +		__entry->sb		= !!args->sb;
> +		__entry->for_kupdate	= args->for_kupdate;
> +		__entry->range_cyclic	= args->range_cyclic;
> +		__entry->for_background	= args->for_background;
> +	),
> +
> +	TP_printk("%s: pages=%ld, sb=%d, kupdate=%d, range_cyclic=%d "
> +		  "for_background=%d", __entry->name, __entry->nr_pages,
> +			__entry->sb, __entry->for_kupdate,
> +			__entry->range_cyclic, __entry->for_background)
> +);
> +

