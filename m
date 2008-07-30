From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Unable to disable barriers
Date: Wed, 30 Jul 2008 11:37:40 -0500
Message-ID: <489098D4.7080004@redhat.com>
References: <3.0.6.32.20080728114837.02425390@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYG3Qhu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jul 2008 12:37:50 -0400
In-Reply-To: <3.0.6.32.20080728114837.02425390@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Gary Hawco wrote:
> Subject pretty much says it all.
> 
> For testing purposes I tried to disable barriers in fstab (barriers=0).  On
> reboot the filesystem will not mount read/write until barriers are reenabled.

What errors do you get?

> This occurs whether I use ordered data mode or data writeback mode, in both
> Gentoo and Slackware 12.1
> 
> Is this behavior by design (that barriers can not be disabled)?
> 
> Thanks,
> Gary

Hm, it's not supposed to be :)

Perhaps you just spelled it wrong:

root@inode ~]# mount -o barriers=0 /dev/sdb2 /mnt/test
mount: wrong fs type, bad option, bad superblock on /dev/sdb2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

[root@inode ~]# mount -o barrier=0 /dev/sdb2 /mnt/test
[root@inode ~]#

-Eric
