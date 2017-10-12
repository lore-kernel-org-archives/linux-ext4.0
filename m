From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Convert timers to use timer_setup()
Date: Thu, 12 Oct 2017 16:58:26 +0200
Message-ID: <20171012145826.GC31488@quack2.suse.cz>
References: <20171005005254.GA23668@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171005005254.GA23668@beast>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 04-10-17 17:52:54, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
> This requires commit 686fef928bba ("timer: Prepare to change timer
> callback argument type") in v4.14-rc3, but should be otherwise
> stand-alone.
> ---
>  fs/ext4/super.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index b104096fce9e..1bc7ff8157d8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2791,14 +2791,11 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
>   * This function is called once a day if we have errors logged
>   * on the file system
>   */
> -static void print_daily_error_info(unsigned long arg)
> +static void print_daily_error_info(struct timer_list *t)
>  {
> -	struct super_block *sb = (struct super_block *) arg;
> -	struct ext4_sb_info *sbi;
> -	struct ext4_super_block *es;
> -
> -	sbi = EXT4_SB(sb);
> -	es = sbi->s_es;
> +	struct ext4_sb_info *sbi = from_timer(sbi, t, s_err_report);
> +	struct super_block *sb = sbi->s_sb;
> +	struct ext4_super_block *es = sbi->s_es;
>  
>  	if (es->s_error_count)
>  		/* fsck newer than v1.41.13 is needed to clean this condition. */
> @@ -3980,8 +3977,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
>  	spin_lock_init(&sbi->s_next_gen_lock);
>  
> -	setup_timer(&sbi->s_err_report, print_daily_error_info,
> -		(unsigned long) sb);
> +	timer_setup(&sbi->s_err_report, print_daily_error_info, 0);
>  
>  	/* Register extent status tree shrinker */
>  	if (ext4_es_register_shrinker(sbi))
> -- 
> 2.7.4
> 
> 
> -- 
> Kees Cook
> Pixel Security
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
