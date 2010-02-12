From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2.6.32.7] ext4: number of blocks for fiemap
Date: Fri, 12 Feb 2010 14:49:40 -0700
Message-ID: <4D0CB743-94B6-49AB-B838-BCDD2EC8C3ED@sun.com>
References: <1257360161.22057.16.camel@michlmayr>
 <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
 <1257371050.13852.28.camel@michlmayr> <4B701793.9010005@canonical.com>
 <1266000136.4310.36.camel@michlmayr>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	surbhi.palande@canonical.com,
	"linux-kernel@vger.kernel.org Mailinglist"
	<linux-kernel@vger.kernel.org>, 474597@bugs.launchpad.net
To: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56751 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab0BLVt4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Feb 2010 16:49:56 -0500
In-reply-to: <1266000136.4310.36.camel@michlmayr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-12, at 11:42, Leonard Michlmayr wrote:
> fs/ext4/extents.c:ext4_fiemap rounds the length of the requested range
> down to blocksize. This is not the true number of blocks that cover  
> the
> requested region. This problem is especially impressive if the user
> requests only the first byte of a file: not a single extent will be
> reported.
>
> Solution:
> Calculate the last byte of the region and round to blocksize. Then get
> the number of blocks by subtracting last_blk - start_blk and adding 1
> for the first block. (The variable last_blk is introduced just for
> easier reading.) This patch will fix this.
>
> I already suggested this patch some time ago, this is the same patch  
> for
> a more recent kernel version.
>
> Signed-off-by: Leonard Michlmayr <leonard.michlmayr@gmail.com>
>
> diff -rup linux-2.6.32.7/fs/ext4/extents.c linux-2.6.32.7-lm/fs/ext4/ 
> extents.c
> --- linux-2.6.32.7/fs/ext4/extents.c	2010-01-29 00:06:20.000000000  
> +0100
> +++ linux-2.6.32.7-lm/fs/ext4/extents.c	2010-02-11  
> 21:26:40.000000000 +0100
> @@ -3711,6 +3711,7 @@ int ext4_fiemap(struct inode *inode, str
> 		__u64 start, __u64 len)
> {
> 	ext4_lblk_t start_blk;
> +	ext4_lblk_t last_blk;
> 	ext4_lblk_t len_blks;
> 	int error = 0;
>
> @@ -3726,7 +3727,9 @@ int ext4_fiemap(struct inode *inode, str
> 		error = ext4_xattr_fiemap(inode, fieinfo);
> 	} else {
> 		start_blk = start >> inode->i_sb->s_blocksize_bits;
> -		len_blks = len >> inode->i_sb->s_blocksize_bits;
> +		/* the last byte in the range is (start + len - 1) */
> +		last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
> +		len_blks = last_blk - start_blk + 1;


If "last_blk" is only used in this one place, please put the  
declaration inside the scope of the "else" clause.  Looks fine  
otherwise.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

