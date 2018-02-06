From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 3/3] fs : ext2: super: fixed '==' instead '='
 braces,whitespace coding style issue.
Date: Tue, 6 Feb 2018 12:45:10 -0800
Message-ID: <e4b13bd3-0611-252b-ee8f-f35f6bbbc198@infradead.org>
References: <20180206203317.14435-1-devesh.pradhan1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: devesh.pradhan1@gmail.com, jack@suse.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180206203317.14435-1-devesh.pradhan1@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/06/2018 12:33 PM, devesh.pradhan1@gmail.com wrote:
> From: devesh pradhan <devesh.pradhan1@gmail.com>
> 
> fixed coding style issue.

I think there is more here than coding style fixes.

Also, did you do any testing after making these changes?


> Signed-off-by: devesh pradhan <devesh.pradhan1@gmail.com>
> ---
>  fs/ext2/super.c | 59 ++++++++++++++++++++++++++-------------------------------
>  1 file changed, 27 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 554c98b8a93a..cb80bcb693a9 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c

> @@ -864,7 +860,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	/*
> -	 * If the superblock doesn't start on a hardware sector boundary,

Why is this change being made?

> +	 * If the superblock doesn't start on a hardware sector boundary
>  	 * calculate the offset.  
>  	 */
>  	if (blocksize != BLOCK_SIZE) {
> @@ -874,7 +870,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		logic_sb_block = sb_block;
>  	}
>  
> -	if (!(bh = sb_bread(sb, logic_sb_block))) {
> +	if (!(bh == sb_bread(sb, logic_sb_block))) {

I'm pretty sure this one was meant to be '=', as in "assignment."
It could be split into 2 lines of code to clarify what it is doing.

>  		ext2_msg(sb, KERN_ERR, "error: unable to read superblock");
>  		goto failed_sbi;
>  	}
> @@ -904,8 +900,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  #ifdef CONFIG_EXT2_FS_POSIX_ACL
>  	if (def_mount_opts & EXT2_DEFM_ACL)
>  		set_opt(opts.s_mount_opt, POSIX_ACL);
> -#endif
> -	
> +#endif	

above line adds trailing whitespace. :(

> +
>  	if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_PANIC)
>  		set_opt(opts.s_mount_opt, ERRORS_PANIC);
>  	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_CONTINUE)

> @@ -949,7 +944,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  			le32_to_cpu(features));
>  		goto failed_mount;
>  	}
> -	if (!sb_rdonly(sb) && (features = EXT2_HAS_RO_COMPAT_FEATURE(sb, ~EXT2_FEATURE_RO_COMPAT_SUPP))){
> +	if (!sb_rdonly(sb) && (features == EXT2_HAS_RO_COMPAT_FEATURE(sb, ~EXT2_FEATURE_RO_COMPAT_SUPP))) {

That one is most likely correct before the patch.

>  		ext2_msg(sb, KERN_ERR, "error: couldn't mount RDWR because of "
>  		       "unsupported optional features (%x)",
>  		       le32_to_cpu(features));

thanks,
-- 
~Randy
