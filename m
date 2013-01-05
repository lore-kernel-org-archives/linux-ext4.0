From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 3/3] ext4: remove duplicate assignment in ext4_init_new_dir()
Date: Sat, 05 Jan 2013 16:05:31 +0800
Message-ID: <50E7DECB.7080707@tao.ma>
References: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com> <1357371781-18194-3-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Tao Ma <boyu.mt@taobao.com>
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy13-pub.unifiedlayer.com ([69.89.16.30]:48356 "HELO
	oproxy13-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754706Ab3AEIMO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2013 03:12:14 -0500
In-Reply-To: <1357371781-18194-3-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/05/2013 03:43 PM, Guo Chao wrote:
> It should be a typo unless I miss something.
> 
> Cc: Tao Ma <boyu.mt@taobao.com>
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
oh, you are right. Thanks for the fix. And I really can't recall how I
messed this up.

Acked-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/namei.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index e249a47..db3b1e9 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2368,7 +2368,6 @@ static int ext4_init_new_dir(handle_t *handle, struct inode *dir,
>  	}
>  
>  	inode->i_size = EXT4_I(inode)->i_disksize = blocksize;
> -	dir_block = ext4_bread(handle, inode, 0, 1, &err);
>  	if (!(dir_block = ext4_bread(handle, inode, 0, 1, &err))) {
>  		if (!err) {
>  			err = -EIO;
> 

