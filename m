From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: make ext4_add_dirent_to_inline function return
 0
Date: Tue, 09 Jul 2013 09:47:12 +0800
Message-ID: <51DB6BA0.7000800@tao.ma>
References: <1373328699-23037-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy13-pub.unifiedlayer.com ([69.89.16.30]:33103 "HELO
	oproxy13-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751245Ab3GIBrZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jul 2013 21:47:25 -0400
In-Reply-To: <1373328699-23037-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/09/2013 08:11 AM, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Currently ext4_add_dirent_to_inline() function returns 1 to indicate
> that a new directory entry has been added.  But it sounds reasonable
> to return 0 in this function.  Meanwhile we also can eliminate a if
> statement in ext4_add_entry() function when a directory entry has added
> correctly.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Tao Ma <tm@tao.ma>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inline.c |    2 +-
>  fs/ext4/namei.c  |    6 +-----
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index b8a0746..5a27d32 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1027,7 +1027,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
>  	ext4_update_dx_flag(dir);
>  	dir->i_version++;
>  	ext4_mark_inode_dirty(handle, dir);
> -	return 1;
> +	return 0;
>  }
>  
>  static void *ext4_get_inline_xattr_pos(struct inode *inode,
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index ab2f6dc..2a6a736 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1901,12 +1901,8 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
>  
>  	if (ext4_has_inline_data(dir)) {
>  		retval = ext4_try_add_inline_entry(handle, dentry, inode);
> -		if (retval < 0)
> +		if (retval <= 0)
Sorry, I guess you misread the codes here. If we get 0 here, it means
that ext4_try_add_inline_entry can't add this entry into the inline
data, but there is no error, so please go on with the normal case. "1"
means we have successfully done the work. So your change is wrong.

Thanks,
Tao
>  			return retval;
> -		if (retval == 1) {
> -			retval = 0;
> -			return retval;
> -		}
>  	}
>  
>  	if (is_dx(dir)) {
> 

