From: Mark Nelson <markn@au1.ibm.com>
Subject: Re: [patch 2/2] move init_ext4_proc() last and add cleanup call exit_ext4_proc()
Date: Wed, 10 Oct 2007 10:50:38 +1000
Message-ID: <470C21DE.2070302@au1.ibm.com>
References: <20071009055033.145153755@au1.ibm.com> <20071009061102.363619477@au1.ibm.com> <20071010004116.GN31713@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:60060 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbXJJAvG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2007 20:51:06 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9A0p5oQ014015
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:51:05 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9A0sdKS244154
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:54:39 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9A0p4rJ031942
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:51:04 +1000
In-Reply-To: <20071010004116.GN31713@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Tue, Oct 09, 2007 at 03:50:35PM +1000, markn@au1.ibm.com wrote:
>> The first problem that is addressed is that the addition of init_ext4_proc()
>> means that the code doesn't clean up after itself on a failure of
>> init_ext4_xattr(), and the second is that usually init_*_proc() should be
>> the last thing called, so we move it to the end and add the cleanup call to
>> exit_ext4_proc().
> 
> I've fixed the first simply by just doing this.  The order really
> doesn't matter much here, and in fact it would probably be better to
> change {init,exit}_ext4_proc() to be {init,exit}_ext4_mballoc() since
> that's actually more accurate, and you need the call to
> init_ext4_proc() even if you aren't using procfs.
> 

That makes sense. Forget my last patch then.

Next time I'll just report the build error :)


Thanks!

Mark

> I will fold this into the mballoc-core.patch.
> 
> 		      	     	    	  - Ted
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 2305af4..b247ca0 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2845,7 +2845,7 @@ static int ext4_mb_destroy_per_dev_proc(struct super_block *sb)
>  	return 0;
>  }
>  
> -int __init init_ext4_proc(void)
> +int __init init_ext4_mballoc(void)
>  {
>  	ext4_pspace_cachep =
>  		kmem_cache_create("ext4_prealloc_space",
> @@ -2863,7 +2863,7 @@ int __init init_ext4_proc(void)
>  	return 0;
>  }
>  
> -void exit_ext4_proc(void)
> +void exit_ext4_mballoc(void)
>  {
>  	/* XXX: synchronize_rcu(); */
>  	kmem_cache_destroy(ext4_pspace_cachep);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 30e2b64..5882165 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2994,13 +2994,13 @@ static int __init init_ext4_fs(void)
>  {
>  	int err;
>  
> -	err = init_ext4_proc();
> +	err = init_ext4_mballoc();
>  	if (err)
>  		return err;
>  
>  	err = init_ext4_xattr();
>  	if (err)
> -		return err;
> +		goto out2;
>  	err = init_inodecache();
>  	if (err)
>  		goto out1;
> @@ -3012,6 +3012,8 @@ out:
>  	destroy_inodecache();
>  out1:
>  	exit_ext4_xattr();
> +out2:
> +	exit_ext4_mballoc();
>  	return err;
>  }
>  
> @@ -3020,7 +3022,7 @@ static void __exit exit_ext4_fs(void)
>  	unregister_filesystem(&ext4dev_fs_type);
>  	destroy_inodecache();
>  	exit_ext4_xattr();
> -	exit_ext4_proc();
> +	exit_ext4_mballoc();
>  }
>  
>  MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
> diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
> index 6a0909f..783c6f3 100644
> --- a/include/linux/ext4_fs.h
> +++ b/include/linux/ext4_fs.h
> @@ -954,8 +954,8 @@ extern int ext4_mb_release(struct super_block *);
>  extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *, struct ext4_allocation_request *, int *);
>  extern int ext4_mb_reserve_blocks(struct super_block *, int);
>  extern void ext4_mb_discard_inode_preallocations(struct inode *);
> -extern int __init init_ext4_proc(void);
> -extern void exit_ext4_proc(void);
> +extern int __init init_ext4_mballoc(void);
> +extern void exit_ext4_mballoc(void);
>  extern void ext4_mb_free_blocks(handle_t *, struct inode *,
>  		unsigned long, unsigned long, int, unsigned long *);
>  
> 
