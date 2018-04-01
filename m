From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: Re: [PATCH 1/2] ext4: always initialize the crc32c checksum driver
Date: Sun, 1 Apr 2018 15:19:20 +0300
Message-ID: <6214c9da-a4bc-f332-ca61-939a16c7f6ce@gmail.com>
References: <20180326044906.13286-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180326044906.13286-1-tytso@mit.edu>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 26.03.2018 07:49, Theodore Ts'o wrote:
> The extended attribute code now uses the crc32c checksum for hashing
> purposes, so we should just always always initialize it.  We also want
> to prevent NULL pointer dereferences if one of the metadata checksum
> features is enabled after the file sytsem is originally mounted.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=199183
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/super.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9d1da40c1f62..7cd022c344d1 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3492,15 +3492,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	/* Load the checksum driver */
> -	if (ext4_has_feature_metadata_csum(sb) ||
> -	    ext4_has_feature_ea_inode(sb)) {
> -		sbi->s_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
> -		if (IS_ERR(sbi->s_chksum_driver)) {
> -			ext4_msg(sb, KERN_ERR, "Cannot load crc32c driver.");
> -			ret = PTR_ERR(sbi->s_chksum_driver);
> -			sbi->s_chksum_driver = NULL;
> -			goto failed_mount;
> -		}
> +	sbi->s_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
> +	if (IS_ERR(sbi->s_chksum_driver)) {
> +		ext4_msg(sb, KERN_ERR, "Cannot load crc32c driver.");
> +		ret = PTR_ERR(sbi->s_chksum_driver);
> +		sbi->s_chksum_driver = NULL;
> +		goto failed_mount;
>  	}


Why do you need to do all the manual initialization of the crc32c
lowlevel driver, when you can just make ext4 select LIBCRC32c and in the
code just use crc32c? Refer to include/linux/crc32c.h for the interface
and lib/libcrc32c.c for the low-level details.


>  
>  	/* Check superblock checksum */
> 
