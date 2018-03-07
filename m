From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/7] ext4: eliminate sleep from shutdown ioctl
Date: Wed, 7 Mar 2018 10:07:25 +0100
Message-ID: <20180307090725.2svpxz2xu5vqt5x3@quack2.suse.cz>
References: <20180220023038.19883-1-tytso@mit.edu>
 <20180220023038.19883-5-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180220023038.19883-5-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 19-02-18 21:30:35, Theodore Ts'o wrote:
> The msleep() when processing EXT4_GOING_FLAGS_NOLOGFLUSH was a hack to
> avoid some races (that are now fixed), but in fact it introduced its
> own race.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ioctl.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 4d1b1575f8ac..16d3d1325f5b 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -498,10 +498,8 @@ static int ext4_shutdown(struct super_block *sb, unsigned long arg)
>  		break;
>  	case EXT4_GOING_FLAGS_NOLOGFLUSH:
>  		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
> -		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal)) {
> -			msleep(100);
> +		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal))
>  			jbd2_journal_abort(sbi->s_journal, 0);
> -		}
>  		break;
>  	default:
>  		return -EINVAL;
> -- 
> 2.16.1.72.g5be1f00a9a
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
