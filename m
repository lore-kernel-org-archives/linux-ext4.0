From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] ext4: fall back to vmalloc() for large allocations
Date: Sun, 17 Jul 2011 23:12:34 -0600
Message-ID: <A8CDAA23-61C6-4823-ADB1-7D36CBAFC025@whamcloud.com>
References: <1310506846-25843-1-git-send-email-adilger@whamcloud.com> <20110718012556.GJ2717@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Yu Jian <yujian@whamcloud.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38500 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1GRFMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 01:12:37 -0400
Received: by pzk3 with SMTP id 3so3706164pzk.5
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 22:12:37 -0700 (PDT)
In-Reply-To: <20110718012556.GJ2717@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-17, at 7:25 PM, Ted Ts'o wrote:
> On Tue, Jul 12, 2011 at 03:40:46PM -0600, Andreas Dilger wrote:
>> For very large ext4 filesystems (128TB and larger) kmalloc() of
>> some per-group structures can fail at mount time due to memory
>> fragmentation.  If kmalloc() fails, fall back to vmalloc() for
>> the s_group_info and s_group_desc arrays.
>> 
>> Signed-off-by: Yu Jian <yujian@whamcloud.com>
>> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> 
> Andreas, was this patch authored by Yu Jian or by you?

Yu Jian wrote it with help from me, and I made some modifications afterward,
so I put both of our names down.

>> 	sbi->s_buddy_cache = new_inode(sb);
>> 	if (sbi->s_buddy_cache == NULL) {
>> -		printk(KERN_ERR "EXT4-fs: can't get new inode\n");
>> +		ext4_msg(sb, KERN_ERR, "can't get new inode\n");
>> 		goto err_freesgi;
>> 	}
> 
> Using ext4_msg instead of printk is good, but that really should be a
> separate patch.

> 
>> -	sbi->s_buddy_cache->i_ino = get_next_ino();
>> +	/* To avoid potentially colliding with an valid on-disk inode number,
>> +	 * use EXT4_BAD_INO for the buddy cache inode number.  This inode is
>> +	 * not in the inode hash, so it should never be found by iget(), but
>> +	 * this will avoid confusion if it ever shows up during debugging. */
>> +	sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
> 
> This should be a separate patch.

Sure.

>> @@ -2457,12 +2472,6 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>> 		i++;
>> 	} while (i <= sb->s_blocksize_bits + 1);
>> 
>> -	/* init file for buddy data */
>> -	ret = ext4_mb_init_backend(sb);
>> -	if (ret != 0) {
>> -		goto out;
>> -	}
>> -
>> 	spin_lock_init(&sbi->s_md_lock);
>> 	spin_lock_init(&sbi->s_bal_lock);
>> 
>> @@ -2487,6 +2496,11 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>> 		spin_lock_init(&lg->lg_prealloc_lock);
>> 	}
>> 
>> +	/* init file for buddy data */
>> +	ret = ext4_mb_init_backend(sb);
>> +	if (ret != 0)
>> +		goto out;
>> +
>> 	if (sbi->s_proc)
>> 		proc_create_data("mb_groups", S_IRUGO, sbi->s_proc,
>> 				 &ext4_mb_seq_groups_fops, sb);
> 
> Why are you moving ext4_mb_init_backend()?  This should be a separate
> patch, with an explanation of what is going on....

In ext4_mb_init(), if the s_locality_group allocation fails it will
currently cause the allocations made in ext4_mb_init_backend() to
be leaked.  Moving the ext4_mb_init_backend() allocation after the
s_locality_group allocation avoids that problem.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



