From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH RESEND] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Thu, 14 Feb 2008 15:33:39 -0800
Message-ID: <1203032019.3637.51.camel@localhost.localdomain>
References: <1203006909.8970.20.camel@ext1.frec.bull.fr>
	 <20080214221317.GP3029@webber.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52349 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759155AbYBNXdv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2008 18:33:51 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1ENXfmt029187
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 18:33:41 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1ENXfAJ149536
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 18:33:41 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1ENXega031178
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 18:33:41 -0500
In-Reply-To: <20080214221317.GP3029@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-02-14 at 15:13 -0700, Andreas Dilger wrote:
> On Feb 14, 2008  17:35 +0100, Valerie Clement wrote:
> > From: Valerie Clement <valerie.clement@bull.net>
> > 
> > With the flex_bg feature enabled, a large file creation oopses the
> > kernel.
> > The BUG_ON is:
> > 	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
> > 
> > As the allocation of the bitmaps and the inode table can be done
> > outside the block group with flex_bg, this allows to allocate up to
> > EXT4_BLOCKS_PER_GROUP blocks in a group.
> > Depending on the group size and the block size, extents might be 
> > larger than BLOCKS_PER_GROUP(); use EXT_INIT_MAX_LEN instead of 
> > BLOCKS_PER_GROUP().
> 
> In fact, my earlier review of this patch was incorrect, and Aneesh pointed
> out the correct answer.  The ext4_mb_mark_free_simple() function is only
> called from ext4_mb_generate_buddy() to generate the buddy bitmap from the
> on-disk block bitmap, and in that case the @len parameter should always
> be <= EXT4_BLOCKS_PER_GROUP().  I think the original patch was correct.
> 
> Sorry about the confusion.  I thought at first glance this was for
> freeing the blocks from releasing an extent, but that is incorrect.
> 
Ok, I added the revised first patch
http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=ext4_fix_BUGON_at_mballoc.patch;h=c2d11bd2ec46c8103d4fad7c62cd792b7daec202;hb=067598f1a058a05342afee9720a0538b871c61f4

Mingming
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
