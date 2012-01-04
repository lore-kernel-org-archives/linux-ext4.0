From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: make 275 pass on ext4
Date: Wed, 04 Jan 2012 13:37:43 -0600
Message-ID: <4F04AA87.5090706@redhat.com>
References: <4F04A6E6.1090304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Eryu Guan <eguan@redhat.com>
To: xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2ADThr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 14:37:47 -0500
In-Reply-To: <4F04A6E6.1090304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/4/12 1:22 PM, Eric Sandeen wrote:
> 275 was failing on ext4 because it doesn't reliably write
> until ENOSPC due to delalloc and crummy ENOSPC handling.
> So the attempts to fill the fs would fail, and this test,
> which was expecting to have exactly 4k free for the last write
> attempt, failed as well, because it was able to write more than
> the expected 4k.

Grr self-NAK this makes it fail on xfs (?!)

-Eric

> Change a few things:
> 
> * Tidy up test description & comments
> * Keep files on scratch mount for failure analysis
> * Add a couple syncs here and there to push out delalloc
> * Make a last-ditch effort to fill fs via direct IO
> * Provide a little more detail on failure
> 
> With this change I can pass the test on ext4.
> 
> Fixing ext4's ENOSPC handling is probably another bug, but by
> working really hard to fill an ext4 fs, this test can achieve
> its specific goal.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/275 b/275
> index 214262e..3ebeabe 100755
> --- a/275
> +++ b/275
> @@ -1,8 +1,8 @@
>  #! /bin/bash
>  # FS QA Test No. 275
>  #
> -# The posix write test. when write size is larger than disk free size,
> -# should write as more as possible
> +# The posix write test.  When write size is larger than disk free size,
> +# should write as much as possible until ENOSPC.
>  #
>  #-----------------------------------------------------------------------
>  # Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
> @@ -36,7 +36,6 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _cleanup()
>  {
>  	cd /
> -	rm -f $SCRATCH_MNT/* $tmp.*
>  	_scratch_unmount
>  }
>  
> @@ -49,7 +48,7 @@ _supported_os IRIX Linux
>  _require_scratch
>  
>  echo "------------------------------"
> -echo "write lack test"
> +echo "write until ENOSPC test"
>  echo "------------------------------"
>  
>  rm -f $seq.full
> @@ -69,10 +68,15 @@ then
>  	exit
>  fi
>  
> +# Attempt to completely fill fs
>  dd if=/dev/zero of=tmp2 bs=1M >/dev/null 2>&1
> +sync
>  dd if=/dev/zero of=tmp3 bs=4K >/dev/null 2>&1
>  sync
> +# Last effort, use O_DIRECT to defeat delalloc
> +dd if=/dev/zero of=tmp4 bs=4K oflag=direct >/dev/null 2>&1
>  
> +# Should leave exactly 4k free
>  rm -f tmp1
>  sync
>  
> @@ -80,7 +84,7 @@ dd if=/dev/zero of=tmp1 bs=8K count=1 >/dev/null 2>&1
>  _filesize=`du tmp1 | awk '{print $1}'`
>  if [ $_filesize -ne 4 ]
>  then
> -	echo "write file err"
> +	echo "write file err: wrote $_filesize kbytes not 4 kbytes"
>  	status=1
>  	exit
>  fi
> diff --git a/275.out b/275.out
> index 30af43c..69b9d52 100644
> --- a/275.out
> +++ b/275.out
> @@ -1,5 +1,5 @@
>  QA output created by 275
>  ------------------------------
> -write lack test
> +write until ENOSPC test
>  ------------------------------
>  done
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

