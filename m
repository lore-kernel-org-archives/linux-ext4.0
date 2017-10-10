From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Convert timers to use timer_setup()
Date: Tue, 10 Oct 2017 13:20:50 +0200
Message-ID: <20171010112050.GB3667@quack2.suse.cz>
References: <20171005004846.GA23025@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171005004846.GA23025@beast>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 04-10-17 17:48:46, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.com>
> Cc: linux-ext4@vger.kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
> This requires commit 686fef928bba ("timer: Prepare to change timer
> callback argument type") in v4.14-rc3, but should be otherwise
> stand-alone.
> ---
>  fs/jbd2/journal.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 7d5ef3bf3f3e..d2a85c9720e9 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -165,11 +165,11 @@ static void jbd2_superblock_csum_set(journal_t *j, journal_superblock_t *sb)
>   * Helper function used to manage commit timeouts
>   */
>  
> -static void commit_timeout(unsigned long __data)
> +static void commit_timeout(struct timer_list *t)
>  {
> -	struct task_struct * p = (struct task_struct *) __data;
> +	journal_t *journal = from_timer(journal, t, j_commit_timer);
>  
> -	wake_up_process(p);
> +	wake_up_process(journal->j_task);
>  }
>  
>  /*
> @@ -197,8 +197,7 @@ static int kjournald2(void *arg)
>  	 * Set up an interval timer which can be used to trigger a commit wakeup
>  	 * after the commit interval expires
>  	 */
> -	setup_timer(&journal->j_commit_timer, commit_timeout,
> -			(unsigned long)current);
> +	timer_setup(&journal->j_commit_timer, commit_timeout, 0);
>  
>  	set_freezable();
>  
> -- 
> 2.7.4
> 
> 
> -- 
> Kees Cook
> Pixel Security
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
