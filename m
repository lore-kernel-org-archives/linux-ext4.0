From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] allocate struct ext4_allocation_context from a kmem
	cache to save stack space
Date: Thu, 07 Feb 2008 16:11:53 -0800
Message-ID: <1202429513.3840.12.camel@localhost.localdomain>
References: <47A9E8CA.2070404@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57974 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959AbYBHALz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2008 19:11:55 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m180BrSf025254
	for <linux-ext4@vger.kernel.org>; Thu, 7 Feb 2008 19:11:53 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m180BqE6232788
	for <linux-ext4@vger.kernel.org>; Thu, 7 Feb 2008 19:11:52 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m180Bq9J027057
	for <linux-ext4@vger.kernel.org>; Thu, 7 Feb 2008 19:11:52 -0500
In-Reply-To: <47A9E8CA.2070404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-02-06 at 11:05 -0600, Eric Sandeen wrote:
> struct ext4_allocation_context is rather large, and this bloats
> the stack of many functions which use it.  Allocating it from
> a named slab cache will alleviate this.
> 
> For example, with this change (on top of the noinline patch sent earlier):
> 
> -ext4_mb_new_blocks		200
> +ext4_mb_new_blocks		 40
> 
> -ext4_mb_free_blocks		344
> +ext4_mb_free_blocks		168
> 
> -ext4_mb_release_inode_pa	216
> +ext4_mb_release_inode_pa	 40
> 
> -ext4_mb_release_group_pa	192
> +ext4_mb_release_group_pa	 24
> 
> Most of these stack-allocated structs are actually used only for
> mballoc history; and in those cases often a smaller struct would do.
> So changing that may be another way around it, at least for those
> functions, if preferred.  For now, in those cases where the ac
> is only for history, an allocation failure simply skips the history
> recording, and does not cause any other failures.
> 
> Comments?
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Index: linux-2.6.24-rc6-mm1/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.24-rc6-mm1.orig/fs/ext4/mballoc.c
> +++ linux-2.6.24-rc6-mm1/fs/ext4/mballoc.c
> @@ -419,6 +419,7 @@
>  #define MB_DEFAULT_GROUP_PREALLOC	512
> 
>  static struct kmem_cache *ext4_pspace_cachep;
> +static struct kmem_cache *ext4_ac_cachep;
> 
>  #ifdef EXT4_BB_MAX_BLOCKS
>  #undef EXT4_BB_MAX_BLOCKS
> @@ -2958,11 +2959,18 @@ int __init init_ext4_mballoc(void)
>  	if (ext4_pspace_cachep == NULL)
>  		return -ENOMEM;
> 
> -#ifdef CONFIG_PROC_FS
> +	ext4_ac_cachep =
> +		kmem_cache_create("ext4_alloc_context",
> +				     sizeof(struct ext4_allocation_context),
> +				     0, SLAB_RECLAIM_ACCOUNT, NULL);
> +	if (ext4_ac_cachep == NULL) {
> +		kmem_cache_destroy(ext4_pspace_cachep);
> +		return -ENOMEM;
> +	}
> +
>  	proc_root_ext4 = proc_mkdir(EXT4_ROOT, proc_root_fs);
>  	if (proc_root_ext4 == NULL)
>  		printk(KERN_ERR "EXT4-fs: Unable to create %s\n", EXT4_ROOT);
> -#endif
> 
>  	return 0;
>  }
> @@ -2971,9 +2979,8 @@ void exit_ext4_mballoc(void)
>  {
>  	/* XXX: synchronize_rcu(); */
>  	kmem_cache_destroy(ext4_pspace_cachep);
> -#ifdef CONFIG_PROC_FS
> +	kmem_cache_destroy(ext4_ac_cachep);
>  	remove_proc_entry(EXT4_ROOT, proc_root_fs);
> -#endif
>  }
> 
> 

Do you intend to remove the #ifdef CONFIG_PROC_FS, or it's a accident? I
think we need keep that to allow ext4 build without procfs configured.

Other than this, the patch looks fine to me.:)

Mingming
