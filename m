From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 14:09:46 -0600
Message-ID: <20090424200946.GT3209@webber.adilger.int>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de>
 <49F0642A.4000704@redhat.com>
 <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de>
 <20090423204059.GM2723@mit.edu>
 <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de>
 <20090424032028.GB7949@mit.edu> <20090424070943.GR3209@webber.adilger.int>
 <20090424115816.GC7949@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Christian Kujau <lists@nerdbynature.de>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:48494 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbZDXUKE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Apr 2009 16:10:04 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3OK9w4N018453
	for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2009 13:09:58 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIM00600FUPO600@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 24 Apr 2009 13:09:58 -0700 (PDT)
In-reply-to: <20090424115816.GC7949@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 24, 2009  07:58 -0400, Theodore Ts'o wrote:
> It didn't; what had happened was that a garbage block had got written
> into the inode table.  This caused the kernel to complain about
> eh_magic being wrong in the inode table.  E2fsck 1.41.3 fixed those
> problems, but it ignored i_file_acl_high because the 64 bit feature
> flag was not set.  The kernel always pays attention to
> i_file_acl_high, regardless of whether the 64-bit feature flag is set
> or not.  Hence, the kernel was complaining and refused to touch those
> inodes.   
> 
> In any case, with e2fsck 1.41.5, I added code to fix i_file_acl_high
> getting set, and I was then able to mount the raw e2image file and not
> have any problems accessing the files in question, so I'm pretty sure
> that was the problem.

This sounds like another case for the "inode badness" patch that we've
developed, as it allows e2fsck to detect that the inode is just full of
garbage and clear the whole thing, instead of fixing it piecemeal and
leaving the sanitized garbage behind.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

