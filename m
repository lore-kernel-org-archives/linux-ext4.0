From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH RESEND] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Thu, 14 Feb 2008 15:13:17 -0700
Message-ID: <20080214221317.GP3029@webber.adilger.int>
References: <1203006909.8970.20.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44575 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbYBNWN2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2008 17:13:28 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1EMDQUS002262
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 14:13:26 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JW900A011MLP600@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 14 Feb 2008 14:13:26 -0800 (PST)
In-reply-to: <1203006909.8970.20.camel@ext1.frec.bull.fr>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 14, 2008  17:35 +0100, Valerie Clement wrote:
> From: Valerie Clement <valerie.clement@bull.net>
> 
> With the flex_bg feature enabled, a large file creation oopses the
> kernel.
> The BUG_ON is:
> 	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
> 
> As the allocation of the bitmaps and the inode table can be done
> outside the block group with flex_bg, this allows to allocate up to
> EXT4_BLOCKS_PER_GROUP blocks in a group.
> Depending on the group size and the block size, extents might be 
> larger than BLOCKS_PER_GROUP(); use EXT_INIT_MAX_LEN instead of 
> BLOCKS_PER_GROUP().

In fact, my earlier review of this patch was incorrect, and Aneesh pointed
out the correct answer.  The ext4_mb_mark_free_simple() function is only
called from ext4_mb_generate_buddy() to generate the buddy bitmap from the
on-disk block bitmap, and in that case the @len parameter should always
be <= EXT4_BLOCKS_PER_GROUP().  I think the original patch was correct.

Sorry about the confusion.  I thought at first glance this was for
freeing the blocks from releasing an extent, but that is incorrect.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
