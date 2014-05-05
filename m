From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 15/37] mke2fs: set block_validity as a default mount
 option
Date: Mon, 5 May 2014 19:24:14 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405051921290.31228@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231400.31890.27469.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbaEERYU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 13:24:20 -0400
In-Reply-To: <20140501231400.31890.27469.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 May 2014, Darrick J. Wong wrote:

> Date: Thu, 01 May 2014 16:14:00 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 15/37] mke2fs: set block_validity as a default mount option
> 
> The block_validity mount option spot-checks block allocations against
> a bitmap of known group metadata blocks.  This helps us to prevent
> self-inflicted catastrophic failures such as trying to "share"
> critical metadata (think bitmaps) with file data, which usually
> results in filesystem destruction.
> 
> In order to test the overhead of the mount option, I re-used the speed
> tests in the metadata checksum testing script.  In short, the program
> creates what looks like 15 copies of a kernel source tree, except that
> it uses fallocate to strip out the overhead of writing the file data
> so that we can focus on metadata overhead.  On a 64G RAM disk, the
> overhead was generally about 0.9% and at most 1.6%.  On a 160G USB
> disk, the overhead was about 0.8% and peaked at 1.2%.
> 
> When I changed the test to write out files instead of merely
> fallocating space, the overhead was negligible.

I like that, but I think we need to run more performance testing on
that to make sure that it really does not break something.

Eric, will you be able to run your performance tests with
block_validity option and compare it with baseline to see whether it
really does not change anything ?

I'll try to run my tests as well.

We really need generic performance test suite, I hope that Dave will
send his performance addition to xfstests soon so we can start
adding tests.

Thanks!
-Lukas

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  misc/mke2fs.conf.in |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
> index 4c5dba7..de0250d 100644
> --- a/misc/mke2fs.conf.in
> +++ b/misc/mke2fs.conf.in
> @@ -1,6 +1,6 @@
>  [defaults]
>  	base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr
> -	default_mntopts = acl,user_xattr
> +	default_mntopts = acl,user_xattr,block_validity
>  	enable_periodic_fsck = 0
>  	blocksize = 4096
>  	inode_size = 256
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
