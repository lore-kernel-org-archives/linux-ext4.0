From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [RFC PATCH 11/17] Fix overflow in calculation of total file	system blocks
Date: Thu, 13 Nov 2008 21:34:43 -0500
Message-ID: <20081114023443.GB20637@shell>
References: <1226461390-5502-4-git-send-email-vaurora@redhat.com> <1226461390-5502-5-git-send-email-vaurora@redhat.com> <1226461390-5502-6-git-send-email-vaurora@redhat.com> <1226461390-5502-7-git-send-email-vaurora@redhat.com> <1226461390-5502-8-git-send-email-vaurora@redhat.com> <1226461390-5502-9-git-send-email-vaurora@redhat.com> <1226461390-5502-10-git-send-email-vaurora@redhat.com> <1226461390-5502-11-git-send-email-vaurora@redhat.com> <1226461390-5502-12-git-send-email-vaurora@redhat.com> <20081113200402.GW16005@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbYKNCeo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2008 21:34:44 -0500
Content-Disposition: inline
In-Reply-To: <20081113200402.GW16005@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 01:04:02PM -0700, Andreas Dilger wrote:
> On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
> > Blocks per group and group desc count are both 32-bit; multiplied they
> > produce a 32-bit quantity which overflowed.
> > 
> > @@ -92,8 +92,8 @@ errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
> > -	real_end = (EXT2_BLOCKS_PER_GROUP(fs->super)
> > -		    * fs->group_desc_count)-1 + start;
> > +	real_end = ((__u64) EXT2_BLOCKS_PER_GROUP(fs->super)
> > +		    * (__u64) fs->group_desc_count)-1 + start;
> 
> Casting the first value to __u64 should be enough.

My approach with this kind of thing is to not make the reader try to
remember the exact type conversion rules, but I'll take it out if it's
just too much.

> This should really be part of patch 05/17 because that is where "real_end"
> is turned into a 64-bit value.

Okay, I'll fold it back.

-VAL
