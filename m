From: Andreas Dilger <adilger@sun.com>
Subject: Re: Call traces on console from a test machine
Date: Fri, 14 Nov 2008 03:36:02 -0700
Message-ID: <20081114103602.GU16005@webber.adilger.int>
References: <491CC6E3.7070808@hq.newdream.net>
 <491CDF90.8070802@hq.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Kelly Kane <kelly@hq.newdream.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36366 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYKNKgF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 05:36:05 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAEAa4qT011082
	for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2008 02:36:04 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAB00H01K1FFK00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 14 Nov 2008 02:36:04 -0800 (PST)
In-reply-to: <491CDF90.8070802@hq.newdream.net>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 13, 2008  18:16 -0800, Kelly Kane wrote:
> In the mean time, fsck.ext4 is not liking our filesystem.
>
> Group descriptor 353 checksum is invalid.  Fix? yes
> Pass 2: CheckingEntry 'spice-and-wolf-si-tendra-segunda-temporada' in
>
 
> /liamsito1234/cibercomics.com/wp-content/cache/supercache/www.cibercomics.com/2008/10/05 
> (2152305) references inode
>                2901322 in group 354 where _INODE_UNINIT is set.
> Entry 'spice-and-wolf-si-tendra-segunda-temporada' in
>
 
> /liamsito1234/cibercomics.com/wp-content/cache/supercache/www.cibercomics.com/2008/10/05 
> (2152305) has
>                deleted/unused inode 2901322.  Clear? yes
> /dev/sdb1: e2fsck canceled.
> e2fsck: aborted
>
> Same block group each run through, different inode.
>
> I ran e2image and produced the following file:
>
> http://ext4dev.dreamhosters.com/watanabe-home-2008-11-13-1712.e2image.bz2
>
> Unfortunately I cannot mount the filesystem right now due to:
>
> EXT4-fs: ext4_check_descriptors: Checksum for group 353 failed  
> (23397!=52411)
> EXT4-fs: group descriptors corrupted!
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or other error       In some cases useful info  
> is found in syslog - try
>        dmesg | tail  or so
>
> Is there any hope for recovery of any of this data?

You can run "tune2fs -O ^uninit_bg /dev/XXX" to disable the group
descriptor checksums (and, unfortunately, the fast fsck benefits),
but at least it will allow you to mount the filesystem.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

