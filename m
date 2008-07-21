From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsprogs: Fix tst_extents output on bigendian machine.
Date: Sun, 20 Jul 2008 23:07:55 -0600
Message-ID: <20080721050755.GD3370@webber.adilger.int>
References: <1216382740-24369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:40254 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbYGUFH6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 01:07:58 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6L57vhG012295
	for <linux-ext4@vger.kernel.org>; Sun, 20 Jul 2008 22:07:57 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4C00M01BJM6S00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 20 Jul 2008 22:07:57 -0700 (PDT)
In-reply-to: <1216382740-24369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 18, 2008  17:35 +0530, Aneesh Kumar wrote:
>  static void dbg_show_header(struct ext3_extent_header *eh)
>  {
>  	printf("header: magic=%x entries=%u max=%u depth=%u generation=%u\n",
> -	       eh->eh_magic, eh->eh_entries, eh->eh_max, eh->eh_depth,
> -	       eh->eh_generation);
> +			ext2fs_le16_to_cpu(eh->eh_magic),
> +			ext2fs_le16_to_cpu(eh->eh_entries),
> +			ext2fs_le16_to_cpu(eh->eh_max),
> +			ext2fs_le16_to_cpu(eh->eh_depth),
> +			ext2fs_le32_to_cpu(eh->eh_generation));

Please fix indenting to align this with the '(' on the preceeding line.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

