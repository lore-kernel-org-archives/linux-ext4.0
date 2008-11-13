From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 09/17] Add progress bar for allocating block tables	-
 takes forever on large
Date: Thu, 13 Nov 2008 12:54:50 -0700
Message-ID: <20081113195450.GU16005@webber.adilger.int>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41445 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbYKMTy6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 14:54:58 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mADJsv4U016064
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2008 11:54:57 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAA00601E9Q7800@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 13 Nov 2008 11:54:57 -0800 (PST)
In-reply-to: <1226461390-5502-10-git-send-email-vaurora@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
> +static errcode_t ext2fs_allocate_tables_with_progress(ext2_filsys fs)
> +{
> +	for (i = 0; i < fs->group_desc_count; i++) {
> +		progress_update(&progress, i);
> +		retval = ext2fs_allocate_group_table(fs, i, (ext2fs_block_bitmap64) fs->block_map);
> +		if (retval)
> +			return retval;
> +	}

Does it make sense to only update the progress periodically instead of for
every group?  Since this is a memory operation, I suspect the console
output slows it down noticably, and would spew a ton of garbage into
console logs and such.  Something like:

	for (i = 0; i < fs->group_desc_count; i++) {
		if (i & 256 == 255)
			progress_update(&progress, i);
		retval = ext2fs_allocate_group_table(fs, i, (ext2fs_block_bitmap64) fs->block_map);
		if (retval)
			return retval;
	}
	progress_close(&progress);


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

