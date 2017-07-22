From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: Re: [PATCH] ext4: fix dir_nlink behaviour
Date: Sat, 22 Jul 2017 15:38:41 +0200
Message-ID: <59735561.9020305@partition-saving.com>
References: <1500677367-82142-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, eggert@cs.ucla.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:21472 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbdGVNeu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 22 Jul 2017 09:34:50 -0400
In-Reply-To: <1500677367-82142-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> The dir_nlink feature has been enabled by default for new ext4
> filesystems since e2fsprogs-1.41 in 2008, and was automatically
> enabled by the kernel for older ext4 filesystems since the
> dir_nlink feature was added with ext4 in kernel 2.6.28+ when
> the subdirectory count exceeded EXT4_LINK_MAX.
> 
> We shouldn't really be enabling filesystem features automatically,
> as this prevents the administrator from disabling the feature at
> format time, or via tune2fs.  This should not affect many users by
> this point, but allows limiting subdirectory counts to those that
> can strictly fit into i_links_count rather than using "1" to
> indicate that the number of links on the directory is not tracked.
> This avoids a bug in glibc fts_read() that incorrectly optimizes
> the directory traversal for such directories.
> 
> This also addresses a minor bug in ext4_inc_count() where i_nlinks
> was wrapped at (EXT4_LINK_MAX - 1) links rather than allowing the
> full EXT4_LINK_MAX links on the parent directory (including "."
> and "..") before storing i_links_count = 1.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=196405
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> ---
>  fs/ext4/ext4.h  |  3 ++-
>  fs/ext4/namei.c | 21 ++++++++++++---------
>  2 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8e80461..e163b87 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2016,7 +2016,8 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
>  
>  #define is_dx(dir) (ext4_has_feature_dir_index((dir)->i_sb) && \
>  		    ext4_test_inode_flag((dir), EXT4_INODE_INDEX))
> -#define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)
> +#define EXT4_DIR_LINK_MAX(dir) unlikely((dir)->i_nlink >= EXT4_LINK_MAX && \
> +		    !(ext4_has_feature_dir_nlink((dir)->i_sb) && is_dx(dir)))
>  #define EXT4_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2 || (dir)->i_nlink == 1)
>  
>  /* Legal values for the dx_root hash_version field: */
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index b81f7d4..566c149 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2351,19 +2351,22 @@ static int ext4_delete_entry(handle_t *handle,
>  }
>  
>  /*
> - * DIR_NLINK feature is set if 1) nlinks > EXT4_LINK_MAX or 2) nlinks == 2,
> - * since this indicates that nlinks count was previously 1.
> + * Set directory link count to 1 if nlinks > EXT4_LINK_MAX, or if nlinks == 2
> + * since this indicates that nlinks count was previously 1 to avoid overflowing
> + * the 16-bit i_links_count field on disk.  Directories with i_nlink == 1 mean
> + * that subdirectory link counts are not being maintained accurately.
> + *
> + * The caller has already checked for i_nlink overflow in case the DIR_LINK
> + * feature is not enabled and returned -EMLINK.  The is_dx() check is a proxy
> + * for checking S_ISDIR(inode) (since the INODE_INDEX feature will not be set
> + * on regular files) and to avoid creating huge/slow non-HTREE directories.
>   */
>  static void ext4_inc_count(handle_t *handle, struct inode *inode)
>  {
>  	inc_nlink(inode);
> -	if (is_dx(inode) && inode->i_nlink > 1) {
> -		/* limit is 16-bit i_links_count */
> -		if (inode->i_nlink >= EXT4_LINK_MAX || inode->i_nlink == 2) {
> -			set_nlink(inode, 1);
> -			ext4_set_feature_dir_nlink(inode->i_sb);
> -		}
> -	}
> +	if (is_dx(inode) &&
> +	    (inode->i_nlink > EXT4_LINK_MAX || inode->i_nlink == 2))
> +		set_nlink(inode, 1);
>  }
>  
>  /*

Hello,

Is the change of the check from (inode->i_nlink >= EXT4_LINK_MAX) to 
(inode->i_nlink > EXT4_LINK_MAX) really needed?
That just allows reaching the EXT4_LINK_MAX in case the nlink feature is enabled 
and what does it change? At next call, it will be set to 1 so that just delays 
the wrap for 1 directory.
It shall be noticed that in case nlink feature is absent, the EXT4_LINK_MAX 
value will be reached (so the limit is correct), and if it is present, reaching 
this value or one less is quite irrevelant as you can create more links than that.

ext4_link does the same check and it is modified from >= to > also, in case 
nlink feature is absent that will allow reaching EXT4_LINK_MAX+1.

If you look at vfs layer, vfs_mkdir does the check against max_links with >= and 
so if you reach the value, you will never be able to create a new directory even 
if nlink feature is present. Actually it is not a problem because ext4 does not 
set the s_max_links value in vfs (do not know why as ext2 set it perhaps because 
there is no limit if nlink is set?), but it could be some latent bug if someday 
somebody thinks it could be a good idea to set it.

Regards,

Damien
