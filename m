From: Andreas Dilger <adilger@sun.com>
Subject: Re: [2.6 patch] FS_MBCACHE: don't needlessly make it built-in
Date: Sun, 17 Aug 2008 12:04:31 -0700
Message-ID: <20080817190431.GG4199@webber.adilger.int>
References: <20080803184325.GC7442@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Andreas Gruenbacher <agruen@suse.de>, linux-ext4@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64396 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYHQTER (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Aug 2008 15:04:17 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7HJ4FJZ014352
	for <linux-ext4@vger.kernel.org>; Sun, 17 Aug 2008 12:04:16 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K5R00J01EB1EV00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 17 Aug 2008 12:04:15 -0700 (PDT)
In-reply-to: <20080803184325.GC7442@cs181140183.pp.htv.fi>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 03, 2008  21:43 +0300, Adrian Bunk wrote:
> Assume you have:
> - one or more of ext2/3/4 statically built into your kernel
> - none of these with extended attributes enabled and
> - want to add onother one of ext2/3/4 modular and with
>   extended attributes enabled
> 
> then you currently have to reboot to use it since this results in 
> CONFIG_FS_MBCACHE=y.
> 
> That's not a common issue, but I just ran into it and since there's no 
> reason to get a built-in mbcache in this case this patch fixes it.

To be honest, I'd like an option to disable MBCACHE entirely.  This
code is of no use if the EAs on an inode are not identical (i.e. if
anything other than ACLs are in use) and is also not useful if the
xattrs fit into the large inodes in ext4 (and ext3 if the filesystem
is formatted with this option).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

