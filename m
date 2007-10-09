From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [patch 1/2] add init_ext4_proc() stub for when CONFIG_PROC_FS
	is not set
Date: Tue, 09 Oct 2007 09:31:27 -0700
Message-ID: <1191947487.12131.33.camel@dyn9047017100.beaverton.ibm.com>
References: <20071009055033.145153755@au1.ibm.com>
	 <20071009061101.666614585@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: markn@au1.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52670 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbXJIQ2Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2007 12:28:24 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l99GSLBV002986
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 12:28:21 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l99GSF2k341312
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 10:28:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l99GSEJN006084
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 10:28:15 -0600
In-Reply-To: <20071009061101.666614585@au1.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-10-09 at 15:50 +1000, markn@au1.ibm.com wrote:
> plain text document attachment (ext4-add-init_ext4_proc-stub.patch)
> init_ext4_fs() calls init_ext4_proc() so we need a stub init_ext4_proc()
> for the case that CONFIG_PROC_FS is not set.
> Without the stub we get a build error:
> 
> fs/ext4/mballoc.c: In function 'init_ext4_proc':
> fs/ext4/mballoc.c:2837: error: 'proc_root_fs' undeclared (first use in this function)
> fs/ext4/mballoc.c:2837: error: (Each undeclared identifier is reported only once
> fs/ext4/mballoc.c:2837: error: for each function it appears in.)
> 
> Add a stub init_ext4_proc() function that does nothing but return 0
> 
> Signed-off-by: Mark Nelson <markn@au1.ibm.com>
> ---
>  fs/ext4/mballoc.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: ext4/fs/ext4/mballoc.c
> ===================================================================
> --- ext4.orig/fs/ext4/mballoc.c
> +++ ext4/fs/ext4/mballoc.c
> @@ -2825,6 +2825,7 @@ static int ext4_mb_destroy_per_dev_proc(
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PROC_FS
>  int __init init_ext4_proc(void)
>  {
>  	ext4_pspace_cachep =
> @@ -2840,6 +2841,12 @@ int __init init_ext4_proc(void)
>  
>  	return 0;
>  }
> +#else
> +int __init init_ext4_proc(void)
> +{
> +	return 0;
> +}
> +#endif
>  
>  void exit_ext4_proc(void)
>  {

Nope. I don't think we can do this :(

For example, we need to create ext4_pspace_cachep kmem cache 
for the pre-allocation to work. We can't ifdef it out.

Mingming/Amit, can you take a look at this ? It looks like
we NEED procfs support to make mballoc work. If so, we need
to add it to the dependency.


Thanks,
Badari
