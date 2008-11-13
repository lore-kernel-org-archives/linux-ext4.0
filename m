From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 11/17] Fix overflow in calculation of total file	system
 blocks
Date: Thu, 13 Nov 2008 13:04:02 -0700
Message-ID: <20081113200402.GW16005@webber.adilger.int>
References: <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
 <1226461390-5502-12-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42014 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYKMUEQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 15:04:16 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mADK4GiP017312
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2008 12:04:16 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAA00601E9Q7800@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 13 Nov 2008 12:04:16 -0800 (PST)
In-reply-to: <1226461390-5502-12-git-send-email-vaurora@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
> Blocks per group and group desc count are both 32-bit; multiplied they
> produce a 32-bit quantity which overflowed.
> 
> @@ -92,8 +92,8 @@ errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
> -	real_end = (EXT2_BLOCKS_PER_GROUP(fs->super)
> -		    * fs->group_desc_count)-1 + start;
> +	real_end = ((__u64) EXT2_BLOCKS_PER_GROUP(fs->super)
> +		    * (__u64) fs->group_desc_count)-1 + start;

Casting the first value to __u64 should be enough.

This should really be part of patch 05/17 because that is where "real_end"
is turned into a 64-bit value.

There is a similar fix missing from ext2fs_allocate_inode_bitmap() (even
though there isn't any support for 64-bit inode numbers as yet.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

