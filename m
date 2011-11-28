From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: make xattr test 020 generic
Date: Mon, 28 Nov 2011 06:01:58 -0500
Message-ID: <20111128110158.GB13766@infradead.org>
References: <4ECD4579.4080706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51700
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab1K1LCA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 06:02:00 -0500
Content-Disposition: inline
In-Reply-To: <4ECD4579.4080706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 23, 2011 at 01:11:53PM -0600, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 020 can be made generic by limiting the total attribute space
> used in the tests as appropriate.  Unless we know we have a
> large-xattr-capable fs, limit total space to a bit under one
> fs block.
> 
> Now passes for me on ext3, ext4, btrfs, as well as xfs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> - ---
> 
> incidentally the test used to send a 100k xattr value to
> the attr command on xfs; it wrote only 64k but did not complain.
> Feature or bug?
> 
> diff --git a/020 b/020
> index 56b9c3c..d196318 100755
> - --- a/020
> +++ b/020
> @@ -80,7 +80,7 @@ _attr_list()
>  
>  
>  # real QA test starts here
> - -_supported_fs xfs udf
> +_supported_fs generic
>  _supported_os Linux
>  
>  _require_attrs
> @@ -119,9 +119,19 @@ _attr_list $testfile
>  
>  echo "*** add lots of attributes"
>  v=0
> - -while [ $v -lt 1000 ]
> +
> +# set maximum total attr space based on fs type
> +if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" ]; then
> +	NUMATTRS=1000
> +else # Assume max ~1 block of attrs
> +	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	# user.attribute_XXX="value.XXX" is about 32 bytes; leave some overhead
> +	let NUMATTRS=$BLOCK_SIZE/40
> +fi

I'd prefer if we define the limits in common.rc - we shouldn't have to
spread too much fs knowledege over individual tests.

> +if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" -o "$FSTYP" == "btrfs" ]; then
> +	ATTRVAL_SIZE=64
> +else # Assume max ~1 block of attrs
> +	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	# leave a little overhead
> +	let ATTRVAL_SIZE=$BLOCK_SIZE-256
> +fi

same for this one.

Except for that these changes looks fine to me.
