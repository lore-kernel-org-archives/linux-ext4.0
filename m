From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests: basic fallocate boundary tests
Date: Sun, 21 Jun 2009 15:16:57 -0400
Message-ID: <20090621191657.GA19596@infradead.org>
References: <4A370C2C.6030404@sandeen.net> <20090620175824.GA3984@infradead.org> <4A3D55C3.6020902@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZFUTQz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Jun 2009 15:16:55 -0400
Content-Disposition: inline
In-Reply-To: <4A3D55C3.6020902@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 20, 2009 at 04:33:55PM -0500, Eric Sandeen wrote:
> hmm this is really testing that xfs_io in particular has fallocate...
> so maybe like this?
> 
> diff --git a/common.rc b/common.rc
> index 39350b3..55aecd6 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -704,6 +704,18 @@ _require_user()
>      [ "$?" == "0" ] || _notrun "$qa_user user not defined."
>  }
>  
> +# check that xfs_io, glibc, kernel, and filesystem all (!) support
> +# fallocate
> +#
> +_require_xfs_io_falloc()
> +	testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $TEST_DIR/$tmp.io 2>&1`
> +	rm -f $TEST_DIR/$tmp.io 2>&1 > /dev/null
> +	echo $testio | grep -q "not found" && \
> +		_notrun "xfs_io fallocate support is missing"
> +	echo $testio | grep -q "Operation not supported" && \
> +		_notrun "xfs_io fallocate command failed (old kernel/wrong fs?)"
> +}

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

