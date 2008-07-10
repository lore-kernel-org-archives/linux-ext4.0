From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fix blkid check
Date: Thu, 10 Jul 2008 08:53:39 -0400
Message-ID: <20080710125339.GE8603@mit.edu>
References: <20080708053733.GC6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44241 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754033AbYGJMxn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 08:53:43 -0400
Content-Disposition: inline
In-Reply-To: <20080708053733.GC6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied, thanks.

					- Ted

On Mon, Jul 07, 2008 at 11:37:34PM -0600, Andreas Dilger wrote:
> The blkid/tests contains new tests for swap, but the type-1 swapfile
> test depends on mkswap supporting the "-U" option to specify the UUID.
> This is not available even on relatively recent versions of mkswap
> (2.13.1 16-Jan-2008) so the test needs to be changed to handle this.
> If the "-U" option is not supported, don't verify the UUID in the blkid
> output during testing.
> 
> Signed-off-by: Andreas Dilger <adilger@sun.com>
> 
> =========================================================================
> 
> diff --git a/lib/blkid/test_probe.in b/lib/blkid/test_probe.in
> index 4ef62a2..6263bcd 100644
> --- a/lib/blkid/test_probe.in
> +++ b/lib/blkid/test_probe.in
> @@ -13,31 +13,45 @@ mkdir -p tests/tmp
>  for i in $TESTS
>  do
>  	printf "%s: " $i
> -	if test ! -f $SRCDIR/tests/$i.img.bz2 -a \
> -		! -f $SRCDIR/tests/$i.results ; 
> +	RESULTS=$SRCDIR/tests/$i.results
> +	IMAGE_BZ2=$SRCDIR/tests/$i.img.bz2
> +	IMAGE=tests/tmp/$i.img.$$
> +	if test ! -f $IMAGE_BZ2 -a ! -f $RESULTS ; 
>  	then
>  		echo "non-existent"
>  		continue
>  	fi
> -	bunzip2 < $SRCDIR/tests/$i.img.bz2 > tests/tmp/test.img.$$
>  	if [ "$i" = "swap0" ]; then
>  		# swap is native-endian, so regenerate before testing
> -		dd if=/dev/zero of=tests/tmp/test.img.$$ bs=16k count=64
> -		mkswap -v0 tests/tmp/test.img.$$ > /dev/null
> +		dd if=/dev/zero of=$IMAGE bs=16k count=64 2> /dev/null
> +		mkswap -v0 $IMAGE > /dev/null
>  	elif [ "$i" = "swap1" ]; then
>  		# swap is native-endian, so regenerate before testing
> -		dd if=/dev/zero of=tests/tmp/test.img.$$ bs=16k count=64
> -		mkswap -v1 -L SWAP-TEST -U 8ff8e77f-8553-485e-8656-58be67a81666 tests/tmp/test.img.$$ >/dev/null
> +		dd if=/dev/zero of=$IMAGE bs=16k count=64 2> /dev/null
> +		# check if mkswap supports the "-U" option
> +		if mkswap -h 2>&1 | grep -q -- '-U'; then
> +			UUID="-U 8ff8e77f-8553-485e-8656-58be67a81666"
> +		else
> +			RMUUID="| grep -v UUID"
> +			RES_TMP=$SRCDIR/tests/tmp/$i.results
> +			grep -v UUID $RESULTS > $RES_TMP
> +			RESULTS=$RES_TMP
> +			
> +		fi
> +		mkswap -v1 -L SWAP-TEST $UUID $IMAGE >/dev/null
> +	else
> +		bunzip2 < $IMAGE_BZ2 > $IMAGE
>  	fi
> -	./tst_probe tests/tmp/test.img.$$ > tests/$i.out
> -	/bin/rm -f tests/tmp/test.img.$$ tests/$i.ok tests/$i.failed
> -	cmp -s tests/$i.out $SRCDIR/tests/$i.results
> +	eval ./tst_probe $IMAGE $RMUUID > tests/$i.out
> +	/bin/rm -f $IMAGE tests/$i.ok tests/$i.failed
> +	cmp -s tests/$i.out $RESULTS
> +	unset RMUUID
>  	if [ $? = 0 ];  then
>  		echo ok
>  		touch tests/$i.ok
>  	else	
>  		echo failed
> -		diff -c tests/$i.out $SRCDIR/tests/$i.results > tests/$i.failed
> +		diff -c tests/$i.out $RESULTS > tests/$i.failed
>  	fi
>  done
>  
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
