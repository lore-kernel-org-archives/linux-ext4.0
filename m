From: Christian Fischer <Christian.Fischer@easterngraphics.com>
Subject: ext4 state user question
Date: Sat, 22 Aug 2009 19:21:15 +0200
Message-ID: <200908221921.15949.Christian.Fischer@easterngraphics.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@sandeen.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.easterngraphics.com ([62.80.28.49]:46422 "EHLO
	intranet.easterngraphics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932709AbZHVRaH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Aug 2009 13:30:07 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have not found a ext4-user list or something similar, that's why my user 
question goes to this development list.

I had a lot of file system crashes with xfs the last time, Eric knows that, if 
he remembers.

I look for an alternate file system for our new production servers, and I need 
to use 2.6.29.4 for the moment due to all systems running on xen, and as far 
as I know 2.6.29.4 xen patched ist the best solution at the moment.

I've updated all xen kernels from 2.6.18 (which is the latest official xen 
kernel) to 2.6.29.4 because xfs tried to write to the superblock to run into 
the next bug, a radix_tree problem with xfs over nfs. I've backported 2.6.30 
patches to avoid the problem, that runs at the moment.

But I don't feel like waiting for the next crash.

I was never before as unshure as now which file system is to choose, IMO I 
have the choice between zfs on solaris, xfs or ext4.
Zfs is not really ported to linux, the stable time of xfs seems gone, and ext4 
is relatively young.

What do you think, is ext4 with 2.6.29.4 ready for productive work and to 
prefer over xfs at the moment?

Best Regards
Christian
-- 
