From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] jbd2: If a journal checksum error is detected,
	propagate the error to ext4
Date: Wed, 04 Jun 2008 21:17:12 -0600
Message-ID: <20080605031712.GK2961@webber.adilger.int>
References: <20080604234057.GA9641@mit.edu>
 <1212623794-10183-1-git-send-email-tytso@mit.edu>
 <1212623794-10183-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Girish.Shilamkar@sun.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:46625 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYFEDRP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 23:17:15 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m553HEdI010532
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 20:17:14 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1Y00C01ZPRWI00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 04 Jun 2008 20:17:14 -0700 (PDT)
In-reply-to: <1212623794-10183-2-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 04, 2008  19:56 -0400, Theodore Ts'o wrote:
> If a journal checksum error is detected, the ext4 filesystem will call
> ext4_error(), and the mount will either continue, become a read-only
> mount, or cause a kernel panic based on the superblock flags
> indicating the user's preference of what to do in case of filesystem
> corruption being detected.
> 
> XXX should we simply fail the mount instead in the panic case?

It does seem that if someone has a bad ext4 root filesystem it would be
easy to get an unusable system.  That is why there are no "ext3_error"
or "ext4_error" calls anywhere in ext[34]_fill_super().  They are all
instead "printk(KERN_ERR ...)" and the mount fails.

> diff --git a/scripts/package/Makefile b/scripts/package/Makefile
> index 5e32607..f758b75 100644
> --- a/scripts/package/Makefile
> +++ b/scripts/package/Makefile

Not sure what the rest of this patch is...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

