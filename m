From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Assume yes when test device is not partitioned
Date: Sat, 3 Sep 2011 13:14:37 -0400
Message-ID: <20110903171437.GA2755@infradead.org>
References: <1315038723-2009-1-git-send-email-prasadjoshi.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Prasad Joshi <prasadjoshi.linux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49444
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160Ab1ICROj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Sep 2011 13:14:39 -0400
Content-Disposition: inline
In-Reply-To: <1315038723-2009-1-git-send-email-prasadjoshi.linux@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 03, 2011 at 02:02:03PM +0530, Prasad Joshi wrote:
> The patch also replaces hard coded mkfs path with MKFS_PROG variable.

Which has nothing to do with the subject of this patch, so do it
separately, with a proper rationale for it.

>+++ b/common.rc
> @@ -314,7 +314,7 @@ _scratch_mkfs()
>          $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
>  	;;
>      *)
> -	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
> +	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV

Please do this for extN only as the braindamage is in mke2fs, not
generic mkfs.

