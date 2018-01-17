From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 8/8] ext4: enable encryption for blocksize less than
 page size
Date: Tue, 16 Jan 2018 18:40:04 -0800
Message-ID: <20180117024004.GH4477@zzz.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
 <20180112141129.27507-9-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112141129.27507-9-chandan@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 12, 2018 at 07:41:29PM +0530, Chandan Rajendra wrote:
> Now that we have all the code to support encryption for block size less
> than page size scenario, this commit removes the conditional check in
> filesystem mount code.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ebb7edb..5a52c98 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4138,14 +4138,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  		}
>  	}
>  
> -	if ((DUMMY_ENCRYPTION_ENABLED(sbi) || ext4_has_feature_encrypt(sb)) &&
> -	    (blocksize != PAGE_SIZE)) {
> -		ext4_msg(sb, KERN_ERR,
> -			 "Unsupported blocksize for fs encryption");
> -		goto failed_mount_wq;
> -	}
> -
> -	if (DUMMY_ENCRYPTION_ENABLED(sbi) && !sb_rdonly(sb) &&
> +	if (DUMMY_ENCRYPTION_ENABLED(sbi) && !(sb->s_flags & MS_RDONLY) &&
>  	    !ext4_has_feature_encrypt(sb)) {
>  		ext4_set_feature_encrypt(sb);
>  		ext4_commit_super(sb, 1);

Why change sb_rdonly() to 'sb->s_flags & MS_RDONLY'?

Eric
