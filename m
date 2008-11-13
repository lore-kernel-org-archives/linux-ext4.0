From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 10/17] signed int -> blk64_t to fix bugs at 2^31 -	2^32
 blocks
Date: Thu, 13 Nov 2008 12:57:42 -0700
Message-ID: <20081113195742.GV16005@webber.adilger.int>
References: <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:47541 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbYKMT5q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 14:57:46 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mADJvjfk002382
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2008 11:57:45 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAA00601E9Q7800@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 13 Nov 2008 11:57:45 -0800 (PST)
In-reply-to: <1226461390-5502-11-git-send-email-vaurora@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
> diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
> index 7235f7d..71ad445 100644
> --- a/lib/ext2fs/alloc_tables.c
> +++ b/lib/ext2fs/alloc_tables.c
> @@ -147,7 +147,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
> -		int prev_block = 0;
> +		blk64_t prev_block = 0;

> @@ -178,7 +178,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
>  	if (flexbg_size) {
> -		int prev_block = 0;
> +		blk64_t prev_block = 0;

These appear to be defects in the base code and should be landed ASAP
(as int -> blk_t) independently of this patch series.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

