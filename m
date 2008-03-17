From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, REWORKED 01/11] Add initial checksum support for the
	gdt_checksum/uninit_group feature
Date: Tue, 18 Mar 2008 01:22:54 +0800
Message-ID: <20080317172254.GF3542@webber.adilger.int>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
 <1205760527-14858-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65172 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYCQRX4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 13:23:56 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2HHNtkt003806
	for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2008 10:23:55 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXV00K01X0VY100@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 17 Mar 2008 10:23:55 -0700 (PDT)
In-reply-to: <1205760527-14858-2-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 17, 2008  09:28 -0400, Theodore Ts'o wrote:
> +STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
> +{
> +	__u16 crc = 0;
> +	struct ext2_group_desc *desc;
> +
> +	desc = &fs->group_desc[group];
> +
> +	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
> +		int offset = offsetof(struct ext2_group_desc, bg_checksum);
> +
> +#ifdef WORDS_BIGENDIAN
> +		struct ext2_group_desc swabdesc = *desc;
> +
> +		/* Have to swab back to little-endian to do the checksum */
> +		ext2fs_swap_group_desc(&swabdesc);
> +		desc = &swabdesc;
> +
> +		group = ext2fs_swab32(group);
> +#endif
> +		crc = crc16(~0, fs->super->s_uuid, sizeof(fs->super->s_uuid));
> +		crc = crc16(crc, &group, sizeof(group));
> +		crc = crc16(crc, desc, offset);
> +		offset += sizeof(desc->bg_checksum); /* skip checksum */
> +		assert(offset == sizeof(*desc));

Note that this assertion needs to be removed when the group descriptor
becomes larger, unless ext2_group_desc never changes in the future..

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

