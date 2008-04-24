From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] fiemap support for ext3
Date: Wed, 23 Apr 2008 20:58:03 -0600
Message-ID: <20080424025803.GM3095@webber.adilger.int>
References: <20080423193914.GA25173@unused.rdu.redhat.com>
 <20080423232725.GK3095@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36496 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbYDXC6H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 22:58:07 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3O2w5Ub011263
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 19:58:05 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZT007016WSWC00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 23 Apr 2008 19:58:05 -0700 (PDT)
In-reply-to: <20080423232725.GK3095@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 23, 2008  15:39 -0400, Josef Bacik wrote:
> Here is my reworked fiemap patch for ext3.  The generic fiemap handler
> takes the get_block_t from the filesystem and does the fiemap that way,
> so then adding ext2 support should be a snap, as well as any other fs
> that wants to use this.

Ah, one other point is that this should also be used by ext4 to map inodes
that are not in extents format, replacing the -EOPNOTSUPP return in that
case.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

