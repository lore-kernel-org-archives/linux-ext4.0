From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: improve smp scalability for inode generation
Date: Fri, 10 Nov 2017 20:33:07 +0300
Message-ID: <87r2t6jay4.fsf@openvz.org>
References: <8760bcpdc8.fsf@openvz.org> <00F078D1-39E9-4F16-8B5B-6952645846E5@dilger.ca> <20171109032320.dnuhngfcvldliysz@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:52156 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752520AbdKJR2L (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Nov 2017 12:28:11 -0500
Received: by mail-lf0-f68.google.com with SMTP id f134so3559167lfg.8
        for <linux-ext4@vger.kernel.org>; Fri, 10 Nov 2017 09:28:11 -0800 (PST)
In-Reply-To: <20171109032320.dnuhngfcvldliysz@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> writes:

> Dmitry, can you try benchmarking this patch?
Hi,
I do not forget about your patch but it looks like some very strange
things happens since last measurements. create_unlink scenario degradates
significantly from 8-16 threads. It looks like something contented on
VFS because I see same result on xfs.
Even more I do not see this contention with 'perf lock record'. Probably
this is because some crappy locking primitives like hlist_bl which has
no lockdep/lockstat support. I'll notify you once found something.
>
> Thanks!!
>
> 						- Ted
>
> commit f0e922e7235e1b5ba6fd964e2cf8dafed3248a15
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Wed Nov 8 22:21:58 2017 -0500
>
>     ext4: improve smp scalability for inode generation
>     
>     ->s_next_generation is protected by s_next_gen_lock but its usage
>     pattern is very primitive.  We don't actually need sequentailly
>     increasing new generation numbers, so let's use prandom_u32() instead.
>     
>     Reported-by: Dmitry Monakhov <dmonakhov@openvz.org>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 53ce95b52fd8..5e6d7b6f50c7 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1355,8 +1355,6 @@ struct ext4_sb_info {
>  	int s_first_ino;
>  	unsigned int s_inode_readahead_blks;
>  	unsigned int s_inode_goal;
> -	spinlock_t s_next_gen_lock;
> -	u32 s_next_generation;
>  	u32 s_hash_seed[4];
>  	int s_def_hash_version;
>  	int s_hash_unsigned;	/* 3 if hash should be signed, 0 if not */
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index ee823022aa34..da79eb5dba40 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1138,9 +1138,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  			   inode->i_ino);
>  		goto out;
>  	}
> -	spin_lock(&sbi->s_next_gen_lock);
> -	inode->i_generation = sbi->s_next_generation++;
> -	spin_unlock(&sbi->s_next_gen_lock);
> +	inode->i_generation = prandom_u32();
>  
>  	/* Precompute checksum seed for inode metadata */
>  	if (ext4_has_metadata_csum(sb)) {
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 144bbda2b808..98ad8172dfd3 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -17,6 +17,7 @@
>  #include <linux/uuid.h>
>  #include <linux/uaccess.h>
>  #include <linux/delay.h>
> +#include <linux/random.h>
>  #include "ext4_jbd2.h"
>  #include "ext4.h"
>  #include <linux/fsmap.h>
> @@ -157,10 +158,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
>  
>  	inode->i_ctime = inode_bl->i_ctime = current_time(inode);
>  
> -	spin_lock(&sbi->s_next_gen_lock);
> -	inode->i_generation = sbi->s_next_generation++;
> -	inode_bl->i_generation = sbi->s_next_generation++;
> -	spin_unlock(&sbi->s_next_gen_lock);
> +	inode->i_generation = prandom_u32();
> +	inode_bl->i_generation = prandom_u32();
>  
>  	ext4_discard_preallocations(inode);
>  
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3a278faf5868..9f2e3eb5131f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3982,8 +3982,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	sbi->s_gdb_count = db_count;
> -	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
> -	spin_lock_init(&sbi->s_next_gen_lock);
>  
>  	timer_setup(&sbi->s_err_report, print_daily_error_info, 0);
>  
