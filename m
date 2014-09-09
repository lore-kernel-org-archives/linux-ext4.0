From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] ext4: use mkfs.ext4 -F instead of piping in yes
Date: Tue, 9 Sep 2014 19:49:15 +0800
Message-ID: <20140909114915.GT2977@dhcp-13-216.nay.redhat.com>
References: <1410092942-22201-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbaIILtZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Sep 2014 07:49:25 -0400
Content-Disposition: inline
In-Reply-To: <1410092942-22201-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 07, 2014 at 08:29:02AM -0400, Theodore Ts'o wrote:
> Using "yes | mkfs.ext4 ..." results in the error message results in
> the test failing, at least for some versions of e2fsprogs:
> 
>     +yes: standard output: Broken pipe
>     +yes: write error
> 
> It better to use the -F option, which will eliminate the questions.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> Cc: Eryu Guan <eguan@redhat.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>

Thanks,
Eryu
> ---
>  tests/ext4/003 | 2 +-
>  tests/ext4/306 | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/ext4/003 b/tests/ext4/003
> index 572e685..a2e9d75 100755
> --- a/tests/ext4/003
> +++ b/tests/ext4/003
> @@ -43,7 +43,7 @@ _require_ext4_bigalloc
>  
>  rm -f $seqres.full
>  
> -yes | mkfs.ext4 -O bigalloc -C 65536  -g 256 $SCRATCH_DEV 512m \
> +mkfs.ext4 -F -O bigalloc -C 65536  -g 256 $SCRATCH_DEV 512m \
>  	>> $seqres.full 2>&1
>  _scratch_mount || _fail "couldn't mount fs"
>  
> diff --git a/tests/ext4/306 b/tests/ext4/306
> index fd50b0e..fd5c3a2 100755
> --- a/tests/ext4/306
> +++ b/tests/ext4/306
> @@ -48,7 +48,7 @@ _require_scratch
>  rm -f $seqres.full
>  
>  # Make a small ext4 fs with extents disabled & mount it
> -yes | mkfs.ext4 -O ^extents,^64bit $SCRATCH_DEV 512m >> $seqres.full 2>&1
> +mkfs.ext4 -F -O ^extents,^64bit $SCRATCH_DEV 512m >> $seqres.full 2>&1
>  _scratch_mount || _fail "couldn't mount fs"
>  
>  # Create a small non-extent-based file
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
