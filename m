From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: ignore i_size_high for directories
Date: Sat, 17 Jan 2009 07:57:06 +0800
Message-ID: <20090116235706.GK13929@webber.adilger.int>
References: <1232125148-13785-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:34373 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbZAPX5S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Jan 2009 18:57:18 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n0GNvC8q024045
	for <linux-ext4@vger.kernel.org>; Fri, 16 Jan 2009 15:57:17 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KDL0020195ONN00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 16 Jan 2009 15:57:12 -0800 (PST)
In-reply-to: <1232125148-13785-1-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 16, 2009  11:59 -0500, Theodore Ts'o wrote:
> Directories are not allowed to be bigger than 2TB, so don't use

... bigger than 2GB?

> i_size_high when reading the inode.  E2fsck should complain about
> these inodes, but the simplest thing to do for the kernel is simply to
> not consult i_size_high for directory inodes.

Actually, it would be preferable to allow directories to grow beyond
the 2GB limit.  2GB only allows about 30M files.  While the htree code
is currently limited to only 2 levels deep, if you have 8kB+ block
size it is possible to have directories larger than 2GB with only
2 levels of htree.

>  static inline loff_t ext4_isize(struct ext4_inode *raw_inode)
>  {
> +	if (S_ISDIR(le16_to_cpu(raw_inode->i_mode)))
> +		return (loff_t) le32_to_cpu(raw_inode->i_size_lo);
> +	else
> +		return ((loff_t)le32_to_cpu(raw_inode->i_size_high) << 32) |
> +			le32_to_cpu(raw_inode->i_size_lo);

If you are going to limit this it should be "if (!S_ISREG(...))"
instead of "if (S_ISDIR(...))" because none of the special files
should use i_size_high - e2fsck will clear a special inode if
it has a non-zero size.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

