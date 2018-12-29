Return-Path: <SRS0=Jm56=PG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44932 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbeL2FIz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Dec 2018 00:08:55 -0500
Date: Sat, 29 Dec 2018 13:08:46 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Liu Bo <obuil.liubo@gmail.com>, fstests@vger.kernel.org
Subject: Re: [PATCH] ext4/034: adjust commit which fixes the problem tested
 by ext4/034
Message-ID: <20181229050846.GC21777@desktop>
References: <20181226160805.8987-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181226160805.8987-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 26, 2018 at 11:08:05AM -0500, Theodore Ts'o wrote:
> Also add a requirment that fallocate and fiemap is supported.
> (Fallocate isn't the case when we are emulating ext3, for example.)
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: Liu Bo <obuil.liubo@gmail.com>

Patch looks good, but I assume you meant to send it to
fstests@vger.kernel.org not linux-fstests@mit.edu :)

Thanks,
Eryu

> ---
>  tests/ext4/034 | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/ext4/034 b/tests/ext4/034
> index 5c34d0d9..f9e4bfaf 100755
> --- a/tests/ext4/034
> +++ b/tests/ext4/034
> @@ -8,7 +8,7 @@
>  # "-o dioread_nolock,nodelalloc" is used.
>  #
>  # The bug was fixed by commit
> -# "Ext4: fix ENOSPC when both quota and dioread_nolock are enabled"
> +# "ext4: make sure enough credits are reserved for dioread_nolock writes"
>  #
>  seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
> @@ -41,6 +41,8 @@ _supported_os Linux
>  _require_scratch
>  _require_quota
>  _require_nobody
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "fiemap"
>  _require_xfs_io_command "syncfs"
>  
>  echo "Format and mount"
> -- 
> 2.19.1
> 
