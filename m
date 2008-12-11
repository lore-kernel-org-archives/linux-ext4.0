From: Andreas Dilger <adilger@sun.com>
Subject: Re: Getting direct support for fallocate(2) into glibc
Date: Thu, 11 Dec 2008 12:00:34 -0700
Message-ID: <20081211190034.GA3178@webber.adilger.int>
References: <E1L9wQt-0003dz-DE@closure.thunk.org> <493EA3AB.2080308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62349 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbYLKTB0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Dec 2008 14:01:26 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mBBJ1HxW004908
	for <linux-ext4@vger.kernel.org>; Thu, 11 Dec 2008 11:01:17 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KBQ00K017FBCN00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 11 Dec 2008 11:01:17 -0800 (PST)
In-reply-to: <493EA3AB.2080308@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 09, 2008  10:58 -0600, Eric Sandeen wrote:
> sorry for the xfs, but > xfs_bmap is still so handy for this...
> 
> # xfs_bmap -vv testfile
> testfile:
>  EXT: FILE-OFFSET   BLOCK-RANGE        AG AG-OFFSET          TOTAL FLAGS
>    0: [0..31]:      34984576..34984607  2 (1256112..1256143)    32 10000
>  FLAG Values:
>     010000 Unwritten preallocated extent

Is the FIEMAP filefrag patch not in e2fsprogs yet?  It should provide
equivalent output.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

