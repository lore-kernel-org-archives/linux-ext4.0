From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] tests: check backing filesystem can handle large file
Date: Fri, 8 Nov 2013 08:04:20 +0800
Message-ID: <20131108000327.GA13332@gmail.com>
References: <1383806104-26239-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52394 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3KHABx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Nov 2013 19:01:53 -0500
Received: by mail-pa0-f46.google.com with SMTP id kl14so55662pab.19
        for <linux-ext4@vger.kernel.org>; Thu, 07 Nov 2013 16:01:52 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1383806104-26239-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 06, 2013 at 11:35:04PM -0700, Andreas Dilger wrote:
> The new resize tests create 2TB test files, but tmpfs in kernels
> before 3.1 have a max file size of 256GB.  Ext3 may also have
> a size limit for smaller blocksize filesystems.
> 
> Fix the resize_test script to verify that $TMPFILE can be resized
> to the final test size, and if that fails try creating the file on
> the local filesystem instead of in $TMPDIR.  If that cannot hold
> the large filesystem, skip the test.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

I have tested this patch on my sand box against a ext3 file system on
e2fsprogs dir and /tmp dir.
Tested-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks for fixing this,
                                                - Zheng

> ---
>  tests/r_64bit_big_expand/script    |    8 ++++++--
>  tests/r_bigalloc_big_expand/script |    8 ++++++--
>  tests/r_ext4_big_expand/script     |    8 ++++++--
>  tests/scripts/resize_test          |   15 +++++++++++++++
>  4 files changed, 33 insertions(+), 6 deletions(-)
> 
> diff --git a/tests/r_64bit_big_expand/script b/tests/r_64bit_big_expand/script
> index 3b34a62..51f36e9 100644
> --- a/tests/r_64bit_big_expand/script
> +++ b/tests/r_64bit_big_expand/script
> @@ -10,10 +10,14 @@ E2FSCK=../e2fsck/e2fsck
>  
>  . $cmd_dir/scripts/resize_test
>  
> -if resize_test
> -then
> +resize_test
> +RC=$?
> +if [ $RC -eq 0 ]; then
>  	echo "$test_name: $test_description: ok"
>  	touch $test_name.ok
> +elif [ $RC -eq 111 ]; then
> +	echo "$test_name: $test_description: skipped"
> +	touch $test_name.ok
>  else
>  	echo "$test_name: $test_description: failed"
>  	touch $test_name.failed
> diff --git a/tests/r_bigalloc_big_expand/script b/tests/r_bigalloc_big_expand/script
> index 2b9cc63..56c8c15 100644
> --- a/tests/r_bigalloc_big_expand/script
> +++ b/tests/r_bigalloc_big_expand/script
> @@ -10,10 +10,14 @@ RESIZE2FS_OPTS=-f
>  
>  . $cmd_dir/scripts/resize_test
>  
> -if resize_test
> -then
> +resize_test
> +RC=$?
> +if [ $RC -eq 0 ]; then
>  	echo "$test_name: $test_description: ok"
>  	touch $test_name.ok
> +elif [ $RC -eq 111 ]; then
> +	echo "$test_name: $test_description: skipped"
> +	touch $test_name.ok
>  else
>  	echo "$test_name: $test_description: failed"
>  	touch $test_name.failed
> diff --git a/tests/r_ext4_big_expand/script b/tests/r_ext4_big_expand/script
> index fb31d7a..a4f8fe6 100644
> --- a/tests/r_ext4_big_expand/script
> +++ b/tests/r_ext4_big_expand/script
> @@ -10,10 +10,14 @@ E2FSCK=../e2fsck/e2fsck
>  
>  . $cmd_dir/scripts/resize_test
>  
> -if resize_test
> -then
> +resize_test
> +RC=$?
> +if [ $RC -eq 0 ]; then
>  	echo "$test_name: $test_description: ok"
>  	touch $test_name.ok
> +elif [ $RC -eq 111 ]; then
> +	echo "$test_name: $test_description: skipped"
> +	touch $test_name.ok
>  else
>  	echo "$test_name: $test_description: failed"
>  	touch $test_name.failed
> diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
> index 964150e..30532a5 100755
> --- a/tests/scripts/resize_test
> +++ b/tests/scripts/resize_test
> @@ -4,6 +4,21 @@ resize_test () {
>  
>  rm -f $TMPFILE
>  touch $TMPFILE
> +
> +# Verify that the $TMP filesystem handles $SIZE_2 sparse files.
> +# If that fails, try the local filesystem instead.
> +if truncate -s $SIZE_2 $TMPFILE 2> /dev/null; then
> +        > $TMPFILE
> +else
> +	rm $TMPFILE
> +	export TMPFILE=$(TMPDIR=. mktemp -t $test_name.XXXXXX.tmp)
> +	touch $TMPFILE
> +	if ! truncate -s $SIZE_2 $TMPFILE 2> /dev/null; then
> +		rm $TMPFILE
> +		return 111
> +	fi
> +fi
> +
>  echo $MKE2FS $FEATURES -qF $TMPFILE $SIZE_1 > $LOG
>  $MKE2FS $FEATURES -qF $TMPFILE $SIZE_1 >> $LOG
>  
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
