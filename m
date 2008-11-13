From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 15/17] Convert to inode/block/bitmap/table
	loc()/loc_set() functions
Date: Thu, 13 Nov 2008 13:26:42 -0700
Message-ID: <20081113202642.GZ16005@webber.adilger.int>
References: <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
 <1226461390-5502-12-git-send-email-vaurora@redhat.com>
 <1226461390-5502-13-git-send-email-vaurora@redhat.com>
 <1226461390-5502-14-git-send-email-vaurora@redhat.com>
 <1226461390-5502-15-git-send-email-vaurora@redhat.com>
 <1226461390-5502-16-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:49073 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYKMU05 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 15:26:57 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mADKQuJH006064
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2008 12:26:56 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAA00A01G5E0H00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 13 Nov 2008 12:26:56 -0800 (PST)
In-reply-to: <1226461390-5502-16-git-send-email-vaurora@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
> -		if (block == fs->group_desc[i].bg_block_bitmap) {
> +		if (block == ext2fs_block_bitmap_loc(fs, i)) {

Similarly, renaming bg_block_bitmap to bg_block_bitmap_lo (et. al.)
would catch tools that are broken on 64-bit filesystems.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

