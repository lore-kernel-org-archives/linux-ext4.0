From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: add check for inodes_count overflow in new resize
 ioctl
Date: Mon, 22 Apr 2013 11:55:45 -0300
Message-ID: <20130422145539.GB519@andromeda.usersys.redhat.com>
References: <1366599425-11561-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1366599425-11561-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Sun, Apr 21, 2013 at 10:57:05PM -0400, Theodore Ts'o wrote:
> Addresses-Red-Hat-Bugzilla: #913245
> 
> Reported-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/resize.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 08d2312..b27c96d 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1882,6 +1882,10 @@ retry:
>  		return 0;
>  
>  	n_group = ext4_get_group_number(sb, n_blocks_count - 1);
> +	if (n_group > (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
> +		ext4_warning(sb, "resize would cause inodes_count overflow");
> +		return -EINVAL;
> +	}
>  	ext4_get_group_no_and_offset(sb, o_blocks_count - 1, &o_group, &offset);
>  
>  	n_desc_blocks = num_desc_blocks(sb, n_group + 1);
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
