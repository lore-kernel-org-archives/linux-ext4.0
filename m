From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 14/17] super->s_*_blocks_count ->
	ext2fs_*_blocks_count()
Date: Thu, 13 Nov 2008 13:24:41 -0700
Message-ID: <20081113202441.GY16005@webber.adilger.int>
References: <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
 <1226461390-5502-12-git-send-email-vaurora@redhat.com>
 <1226461390-5502-13-git-send-email-vaurora@redhat.com>
 <1226461390-5502-14-git-send-email-vaurora@redhat.com>
 <1226461390-5502-15-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:43217 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYKMUYn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 15:24:43 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mADKOhaf020179
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2008 12:24:43 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAA00901FMZO300@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 13 Nov 2008 12:24:43 -0800 (PST)
In-reply-to: <1226461390-5502-15-git-send-email-vaurora@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
> -	count = fs->super->s_blocks_count;
> +	count = ext2fs_blocks_count(fs->super);

Along with changes like this (and the similar ACL fix) I'd prefer that we
rename the old superblock field to be "s_block_count_lo" and put a comment
there referencing the accessor functions so that compilation will fail
and it is clear what needs to be fixed.

As you can see from this patch, even though ext2fs_blocks_count() predates
the 64-bit patches, it isn't used very widely.  Landing other patches
to e2fsprogs may run the risk of only accessing the low 32 bits of the
size/count/acl/etc because they were developed before 64-bit support
was added.

Since it isn't yet common to be able to test > 32-bit blocks
these bugs may go unnoticed for some time.  It would be nice to be able
to test 64-bit support easily with e2fsprogs.  Maybe truncate file
to > 16TB in size (abort if underlying filesystem isn't able to do this),
use "lazy_bg" or equivalent to avoid writing many GB of data into the
sparse file, then run e2fsck on it after putting some files at the end.
This could probably be done by the "script" support in "make check".


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

