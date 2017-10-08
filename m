From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext2/super: Fix a possible sleep-in-atomic bug in
 parse_options
Date: Mon, 9 Oct 2017 09:20:07 +1100
Message-ID: <20171008222007.GX15067@dastard>
References: <1507339246-13067-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, jack@suse.com, sagi@grimberg.me,
        james.smart@broadcom.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507339246-13067-1-git-send-email-baijiaju1990@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Oct 07, 2017 at 09:20:46AM +0800, Jia-Ju Bai wrote:
> The kernel may sleep under a spinlock, and the function call path is:
> ext2_remount
>   parse_options
>     match_int
>       match_number (lib/parser.c)
>         kmalloc(GFP_KERNEL) --> may sleep
> 
> To fix it, GFP_KERNEL is replaced with GFP_ATOMIC.
> This bug is found by my static analysis tool and my code review.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> ---
>  lib/parser.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/parser.c b/lib/parser.c
> index 3278958..bc6e2ce 100644
> --- a/lib/parser.c
> +++ b/lib/parser.c
> @@ -133,7 +133,7 @@ static int match_number(substring_t *s, int *result, int base)
>  	long val;
>  	size_t len = s->to - s->from;
>  
> -	buf = kmalloc(len + 1, GFP_KERNEL);
> +	buf = kmalloc(len + 1, GFP_ATOMIC);

That seems like the wrong thing to do.

The problem is that ext2_remount is running it's internal
parse_options() under a spinlock, rather than doing the parsing with
no locks held and then only taking the locks when it needs to change
the superblock state.

At a quick glance, I don't see any other filesystem with the same
problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
