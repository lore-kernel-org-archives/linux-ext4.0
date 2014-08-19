From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH] ext4: remove a duplicate call in ext4_init_new_dir()
Date: Wed, 20 Aug 2014 01:21:55 +0800
Message-ID: <B0F97F2C-631A-4D01-97EC-E6687D4E674D@gmail.com>
References: <1407856709-18612-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:65474 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaHSRWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2014 13:22:04 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so10112409pab.26
        for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2014 10:21:59 -0700 (PDT)
In-Reply-To: <1407856709-18612-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Any comments on this cleanup patch?

> From: Wang Shilong <wshilong@ddn.com>
> 
> ext4_journal_get_write_access() has just been called in ext4_append()
> calling it again here is duplicated.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
> fs/ext4/namei.c | 4 ----
> 1 file changed, 4 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3520ab8..6d0d01f 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2390,10 +2390,6 @@ static int ext4_init_new_dir(handle_t *handle, struct inode *dir,
> 	dir_block = ext4_append(handle, inode, &block);
> 	if (IS_ERR(dir_block))
> 		return PTR_ERR(dir_block);
> -	BUFFER_TRACE(dir_block, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, dir_block);
> -	if (err)
> -		goto out;
> 	de = (struct ext4_dir_entry_2 *)dir_block->b_data;
> 	ext4_init_dot_dotdot(inode, de, blocksize, csum_size, dir->i_ino, 0);
> 	set_nlink(inode, 2);
> -- 
> 1.9.3
> 

Best Regards,
Wang Shilong

