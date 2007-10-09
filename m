From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [patch 2/2] move init_ext4_proc() last and add cleanup call
	exit_ext4_proc()
Date: Tue, 09 Oct 2007 09:22:02 -0700
Message-ID: <1191946922.12131.26.camel@dyn9047017100.beaverton.ibm.com>
References: <20071009055033.145153755@au1.ibm.com>
	 <20071009061102.363619477@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com
To: markn@au1.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:55626 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbXJIQSx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2007 12:18:53 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l99GIoNH008502
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 12:18:50 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l99GIohN345772
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 10:18:50 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l99GInsn019090
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 10:18:50 -0600
In-Reply-To: <20071009061102.363619477@au1.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-10-09 at 15:50 +1000, markn@au1.ibm.com wrote:
> plain text document attachment (ext4-move-init_ext4_proc-add-
> cleanup.patch)
> The first problem that is addressed is that the addition of init_ext4_proc()
> means that the code doesn't clean up after itself on a failure of
> init_ext4_xattr(), and the second is that usually init_*_proc() should be
> the last thing called, so we move it to the end and add the cleanup call to
> exit_ext4_proc().
> 
> Signed-off-by: Mark Nelson <markn@au1.ibm.com>
> ---
>  fs/ext4/super.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> Index: ext4/fs/ext4/super.c
> ===================================================================
> --- ext4.orig/fs/ext4/super.c
> +++ ext4/fs/ext4/super.c
> @@ -2999,10 +2999,6 @@ static int __init init_ext4_fs(void)
>  {
>  	int err;
>  
> -	err = init_ext4_proc();
> -	if (err)
> -		return err;
> -
>  	err = init_ext4_xattr();
>  	if (err)
>  		return err;
> @@ -3012,7 +3008,12 @@ static int __init init_ext4_fs(void)
>  	err = register_filesystem(&ext4dev_fs_type);
>  	if (err)
>  		goto out;
> +	err = init_ext4_proc();
> +	if (err)
> +		goto out_proc;
>  	return 0;
> +out_proc:
> +	exit_ext4_proc();
>  out:
>  	destroy_inodecache();
>  out1:

Nope. You can not call exit_ext4_proc() if there is a failure
in init_ext4_proc(). If the kmem_cache_create() for ext4_pspace_cachep
fails, you would end up calling kmem_cache_destory(NULL).

The best way is to make init_ext4_proc() cleanup itself, in case
of an error. Hmm.. we are not handling proc_mkdir(EXT4_ROOT) 
failures.

Thanks,
Badari
