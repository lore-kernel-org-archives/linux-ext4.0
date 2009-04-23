From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Thu, 23 Apr 2009 14:51:24 -0600
Message-ID: <20090423205124.GP3209@webber.adilger.int>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de>
 <49F0642A.4000704@redhat.com>
 <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63252 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZDWUvu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Apr 2009 16:51:50 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3NKpg6Z002824
	for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2009 13:51:42 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIK00L00MTL4K00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 23 Apr 2009 13:51:42 -0700 (PDT)
In-reply-to: <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 23, 2009  12:04 -0700, Christian Kujau wrote:
> On Thu, 23 Apr 2009, Eric Sandeen wrote:
> > I'd have expected fsck to find that, I think.  I'd first suggest using
> > 1.41.4 or 1.41.5 (probably released very soon) and see if that catches
> > it (I don't remember offhand if there is a relevant change since 1.41.3
> > but the check should be easy...)

There is a function ext2fs_extent_header_verify() that should be
catching the reported corruption.  The extents regression tests
that we have for e2fsck are detecting things like bad headers
in the tests that we have.

Using "debugfs" with "imap" to find and dump the inode blocks for
the corrupted inodes would be a good start for tracking this down.
If you have the space, saving an "e2image" of the filesystem should
also be done for future debugging.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

