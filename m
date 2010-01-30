From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: 223 - test file alignment on stripe geometry
Date: Sat, 30 Jan 2010 05:52:36 -0500
Message-ID: <20100130105236.GA18286@infradead.org>
References: <4B621529.20708@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51306 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab0A3Kwi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jan 2010 05:52:38 -0500
Content-Disposition: inline
In-Reply-To: <4B621529.20708@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +# real QA test starts here
> +_supported_fs xfs ext4

I'd make this generic and just do the notrun in scratch_mkfs_geom for
non-supported filesystems.

> +scratch_mkfs_geom()
> +{

And I'd throw this one into common.rc.

> +=== Testing size 1073745920 falloc on 128k stripe ===
> +SCRATCH_MNT/file-1073745920-falloc: well-aligned
> diff --git a/common.rc b/common.rc
> index 6424871..97513cc 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -292,7 +292,7 @@ _scratch_mkfs()
>          $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
>  	;;
>      *)
> -	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
> +	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV

Hmm, doesn't this change break other testcase?  Anyway needs some
rationale in the changelog.

> index 0000000..fa005b2
> --- /dev/null
> +++ b/src/fibmap.c

This is a bit misnamed as it's not a generic fibmap tool but rather
a specific tool comparing the bmap to the sunit alignment.
