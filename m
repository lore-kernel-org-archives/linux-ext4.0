From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Fix overflow when updating superblock backups
 after resize
Date: Wed, 22 Oct 2014 17:00:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1410221700200.2250@localhost.localdomain>
References: <1413988148-11433-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1413988148-11433-1-git-send-email-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 22 Oct 2014, Jan Kara wrote:

> Date: Wed, 22 Oct 2014 16:29:08 +0200
> From: Jan Kara <jack@suse.cz>
> To: Ted Tso <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
>     stable@vger.kernel.org
> Subject: [PATCH] ext4: Fix overflow when updating superblock backups after
>     resize
> 
> When there are no meta block groups update_backups() will compute the
> backup block in 32-bit arithmetics thus possibly overflowing the block
> number and corrupting the filesystem. OTOH filesystems without meta
> block groups larger than 16 TB should be rare. Fix the problem by doing
> the counting in 64-bit arithmetics.

Looks good, thanks.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Coverity-id: 741252
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/resize.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index f298c60f907d..ca4588388fc3 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1081,7 +1081,7 @@ static void update_backups(struct super_block *sb, int blk_off, char *data,
>  			break;
>  
>  		if (meta_bg == 0)
> -			backup_block = group * bpg + blk_off;
> +			backup_block = ((ext4_fsblk_t)group) * bpg + blk_off;
>  		else
>  			backup_block = (ext4_group_first_block_no(sb, group) +
>  					ext4_bg_has_super(sb, group));
> 
