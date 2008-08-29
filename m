From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: ext3: Fix ext3 block reservation early ENOSPC issue
Date: Fri, 29 Aug 2008 09:01:15 -0400
Message-ID: <170fa0d20808290601l7af9568v7998613cc85cecaa@mail.gmail.com>
References: <1219964631.6384.70.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>, tytso <tytso@mit.edu>
To: "Mingming Cao" <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:44062 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYH2NBR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Aug 2008 09:01:17 -0400
Received: by wa-out-1112.google.com with SMTP id j37so462024waf.23
        for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 06:01:16 -0700 (PDT)
In-Reply-To: <1219964631.6384.70.camel@mingming-laptop>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2008 at 7:03 PM, Mingming Cao <cmm@us.ibm.com> wrote:
> From: Mingming Cao <cmm@us.ibm.com>
>
> ext3: Fix ext3 nomballoc allocator for ENOSPC
>
> We could run into ENOSPC error on ext3, even when there is free blocks
> on the filesystem.
>
> The problem is triggered in the case the goal block group has 0 free blocks
> , and the rest block groups are skipped due to the check of "free_blocks
> < windowsz/2". Current code could fall back to non reservation allocation
> to prevent early ENOSPC after examing all the block groups with reservation on
> , but this code was  bypassed if the reservation window is turned off already,
> which is true in this case.

Looks great, nice catch!

Minor nit, the patch description should reference "free_blocks <= (windowsz/2)"


> This patch fixed two issues:
> 1) We don't need to turn off block reservation if the goal block group has
> 0 free blocks left and continue search for the rest of block groups.
>
> Current code the intention is to turn off the block reservation if the
>  goal allocation group has a few (some) free blocks left (not enough
> for make the desired reservation window),to try to allocation in the
>  goal block group, to get better locality. But if the goal blocks have
> 0 free blocks,  it should leave the block reservation on, and continues
> search for the next block groups,rather than turn off block reservation
> completely.
>
> 2) we don't need to check the window size if the block reservation is off.
>
> The problem was originally found and fixed in ext4.
>
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
>
> ---
>  fs/ext3/balloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.27-rc3/fs/ext3/balloc.c
> ===================================================================
> --- linux-2.6.27-rc3.orig/fs/ext3/balloc.c      2008-08-12 18:55:39.000000000 -0700
> +++ linux-2.6.27-rc3/fs/ext3/balloc.c   2008-08-28 15:52:09.000000000 -0700
> @@ -1547,6 +1547,7 @@
>         * turn off reservation for this allocation
>         */
>        if (my_rsv && (free_blocks < windowsz)
> +               && (free_blocks > 0)
>                && (rsv_is_empty(&my_rsv->rsv_window)))
>                my_rsv = NULL;

Should the comment block right above this change be adjusted with
something like?:

         /*
-         * if there is not enough free blocks to make a new resevation
-         * turn off reservation for this allocation
+         * if there is not enough free blocks to make a new reservation
+         * turn off reservation for this allocation; if the current block
+         * group has 0 free blocks keep reservation enabled and search
+         * the rest of the block groups
          */

Mike
