From: Andreas Dilger <adilger@sun.com>
Subject: Re: +	ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch
 added	to -mm tree
Date: Wed, 04 Jun 2008 23:30:43 -0600
Message-ID: <20080605053043.GO2961@webber.adilger.int>
References: <200806050437.m554bqsc025546@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: mm-commits@vger.kernel.org, duaneg@dghda.com,
	linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56188 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYFEFar (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 01:30:47 -0400
In-reply-to: <200806050437.m554bqsc025546@imap1.linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 04, 2008  21:37 -0700, Andrew Morton wrote:
> +/* Flags that should be inherited by new inodes from their parent. */
> +#define EXT2_FL_INHERITED ~(EXT2_DIRTY_FL | EXT2_ECOMPR_FL | EXT2_BTREE_FL |\
> +			    EXT2_INDEX_FL | EXT2_IMAGIC_FL | EXT2_TOPDIR_FL)

This doesn't make things much better, unless it is just as a stop-gap
measure to get into the kernel while there is more discussion about which
flags need to be inherited...  Duane did mention follow-up patches, so
I have no real objection to this patch as-is, so long as we don't consider
the matter closed.

Minor nit - "EXT2_BTREE_FL" is the long-deprecated name for "EXT2_INDEX_FL",
so we may as well just avoid it entirely here.

Yes, this patch avoids a few more of the cases that are bad, but will
again be incorrect as soon as some new flag enters use.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

