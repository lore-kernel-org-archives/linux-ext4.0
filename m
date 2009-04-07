From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 bug and/or e2fsck hole
Date: Tue, 07 Apr 2009 16:58:35 -0700
Message-ID: <20090407235835.GI3204@webber.adilger.int>
References: <20090407204811.GA4495@kulgan>
 <20090407231324.GF3204@webber.adilger.int> <20090407233955.GA4328@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:34807 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbZDGX6r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 19:58:47 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n37NwkA5028633
	for <linux-ext4@vger.kernel.org>; Tue, 7 Apr 2009 16:58:46 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHR00J008WTC600@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 07 Apr 2009 16:58:46 -0700 (PDT)
In-reply-to: <20090407233955.GA4328@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 08, 2009  09:09 +0930, Kevin Shanahan wrote:
> hermes:~# debugfs -c -R 'imap 383' /dev/dm-0
> debugfs 1.41.3 (12-Oct-2008)
> /dev/dm-0: catastrophic mode - not reading inode or group bitmaps
> 383: File not found by ext2_lookup 
> hermes:~# debugfs -c -R 'imap <383>' /dev/dm-0
> debugfs 1.41.3 (12-Oct-2008)
> /dev/dm-0: catastrophic mode - not reading inode or group bitmaps
> Inode 383 is part of block group 0
>         located at block 312, offset 0x0e00

In the meantime you can use "debugfs -w /dev/dm-0", "clri {filename}"
to zero out the inode, "freei {filename}" to mark the inode unused,
and "rm {filename}" to remove the file from the directory.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

