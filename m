From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix interaction between i_size, fallocate, and
 delalloc after a crash
Date: Thu, 12 Oct 2017 16:38:59 +0200
Message-ID: <20171012143859.GA31488@quack2.suse.cz>
References: <1503830683-21455-1-git-send-email-amir73il@gmail.com>
 <59C8D147.1060608@cn.fujitsu.com>
 <CAOQ4uxgnK3mGKG+owRUNGyDVOCeicArwaufGgwXaSVxC26+peQ@mail.gmail.com>
 <CAFk8rvYvrGo6SjA6e0yj0XL_BARMmZoofB5kESM4EY4S2n-==w@mail.gmail.com>
 <59D5DEE0.6080506@cn.fujitsu.com>
 <CAFk8rvbi3MHbRBtaZVTJKDcORaDTtMpwy2X2ZdXTZt=LE5smZw@mail.gmail.com>
 <CAOQ4uxgc77_P472KEyHfAXSOE6DD7c=2VrJWBJT6ahiSYb=iJQ@mail.gmail.com>
 <CAFk8rvYtyraezVEP1e3LFEE+9t5YoRH2YwjKxex8hgSY74Lw7A@mail.gmail.com>
 <20171007032917.bntgnubthdstmrrt@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ashlie Martinez <ashmrtn@utexas.edu>,
        Amir Goldstein <amir73il@gmail.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Vijay Chidambaram <vvijay03@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46295 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752977AbdJLOjB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 12 Oct 2017 10:39:01 -0400
Content-Disposition: inline
In-Reply-To: <20171007032917.bntgnubthdstmrrt@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> commit 3912e7b44cf77e9452d4d0cb6c1da9c7043bb7f1
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Fri Oct 6 23:09:55 2017 -0400
> 
>     ext4: fix interaction between i_size, fallocate, and delalloc after a crash
>     
>     If there are pending writes subject to delayed allocation, then i_size
>     will show size after the writes have completed, while i_disksize
>     contains the value of i_size on the disk (since the writes have not
>     been persisted to disk).
>     
>     If fallocate(2) is called with the FALLOC_FL_KEEP_SIZE flag, either
>     with or without the FALLOC_FL_ZERO_RANGE flag set, and the new size
>     after the fallocate(2) is between i_size and i_disksize, then after a
>     crash, if a journal commit has resulted in the changes made by the
>     fallocate() call to be persisted after a crash, but the delayed
>     allocation write has not resolved itself, i_size would not be updated,
>     and this would cause the following e2fsck complaint:
>     
>     Inode 12, end of extent exceeds allowed value
>             (logical block 33, physical block 33441, len 7)
>     
>     This can only take place on a sparse file, where the fallocate(2) call
>     is allocating blocks in a range which is before a pending delayed
>     allocation write which is extending i_size.  Since this situation is
>     quite rare, and the window in which the crash must take place is
>     typically < 30 seconds, in practice this condition will rarely happen.
>     
>     Nevertheless, it can be triggered in testing, and in particular by
>     xfstests generic/456.
>     
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>     Reported-by: Amir Goldstein <amir73il@gmail.com>
>     Cc: stable@vger.kernel.org

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 97f0fd06728d..07bca11749d4 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4794,7 +4794,8 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	}
>  
>  	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> -	     offset + len > i_size_read(inode)) {
> +	    (offset + len > i_size_read(inode) ||
> +	     offset + len > EXT4_I(inode)->i_disksize)) {
>  		new_size = offset + len;
>  		ret = inode_newsize_ok(inode, new_size);
>  		if (ret)
> @@ -4965,7 +4966,8 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	}
>  
>  	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> -	     offset + len > i_size_read(inode)) {
> +	    (offset + len > i_size_read(inode) ||
> +	     offset + len > EXT4_I(inode)->i_disksize)) {
>  		new_size = offset + len;
>  		ret = inode_newsize_ok(inode, new_size);
>  		if (ret)
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
