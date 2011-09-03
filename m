From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Assume yes when test device is not partitioned
Date: Sat, 3 Sep 2011 13:52:59 -0400
Message-ID: <20110903175259.GA3461@thunk.org>
References: <1315038723-2009-1-git-send-email-prasadjoshi.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Prasad Joshi <prasadjoshi.linux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40146 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab1ICRxD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Sep 2011 13:53:03 -0400
Content-Disposition: inline
In-Reply-To: <1315038723-2009-1-git-send-email-prasadjoshi.linux@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 03, 2011 at 02:02:03PM +0530, Prasad Joshi wrote:
> @@ -333,7 +333,7 @@ _scratch_mkfs_sized()
>  	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
>  	;;
>      ext2|ext3|ext4|ext4dev)
> -	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> +	yes | ${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
>  	;;
>      btrfs)
>  	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV

Why don't you just pass -f to mke2fs.ext[234]?

							- Ted
