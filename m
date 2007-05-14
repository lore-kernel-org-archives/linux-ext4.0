From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] resolve duplicate flag no for PG_lazyfree
Date: Sun, 13 May 2007 22:46:30 -0700
Message-ID: <20070513224630.3cd0cb54.akpm@linux-foundation.org>
References: <379110250.28666@ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Rik van Riel <riel@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Fengguang Wu <fengguang.wu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754848AbXENFqt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2007 01:46:49 -0400
In-Reply-To: <379110250.28666@ustc.edu.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 14 May 2007 10:37:18 +0800 Fengguang Wu <fengguang.wu@gmail.com> wrote:

> PG_lazyfree and PG_booked shares the same bit.
> 
> Either it is a bug that shall fixed by the following patch, or
> the situation should be explicitly documented?
> 
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  include/linux/page-flags.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.21-mm2.orig/include/linux/page-flags.h
> +++ linux-2.6.21-mm2/include/linux/page-flags.h
> @@ -91,7 +91,7 @@
>  #define PG_buddy		19	/* Page is free, on buddy lists */
>  #define PG_booked		20	/* Has blocks reserved on-disk */
>  
> -#define PG_lazyfree		20	/* MADV_FREE potential throwaway */
> +#define PG_lazyfree		21	/* MADV_FREE potential throwaway */
>  
>  /* PG_owner_priv_1 users should have descriptive aliases */
>  #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */

That's an accident: PG_lazyfree got added but the out-of-tree ext4 patches
didn't get updated.

otoh, the intersection between pages which are PageBooked() and pages which
are PageLazyFree() should be zreo, so it'd be good to actually formalise
this reuse within the ext4 patches.

otoh2, PageLazyFree() could have reused PG_owner_priv_1.

Rik, Ted: any thoughts?  We do need to scrimp on page flags: when we
finally run out, we're screwed.
