From: Andreas Dilger <adilger@sun.com>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Tue, 10 Mar 2009 14:44:18 -0600
Message-ID: <20090310204418.GW3199@webber.adilger.int>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>
 <49B5D71D.1030802@redhat.com> <1236687347.30280.42.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63242 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZCJUok (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2009 16:44:40 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n2AKibps008638
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2009 13:44:37 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KGB00K004LPGF00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 10 Mar 2009 13:44:37 -0700 (PDT)
In-reply-to: <1236687347.30280.42.camel@kulgan.wumi.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 10, 2009  22:45 +1030, Kevin Shanahan wrote:
> hermes:~# e2fsck -pfv /dev/dm-0 
> /dev/dm-0: Inode 865 is in use, but has dtime set.  FIXED.
> /dev/dm-0: Inode 865 has a extra size (33096) which is invalid
> FIXED.
> /dev/dm-0: Inode 865 has INDEX_FL flag set but is not a directory.
> HTREE INDEX CLEARED.
> /dev/dm-0: Inode 865, i_size is 11708523728200260508, should be 0.  FIXED.
> /dev/dm-0: Inode 865, i_blocks is 3851901040, should be 0.  FIXED.

These all mean the inode is garbage.  The Lustre e2fsprogs has a patch
"e2fsprogs-badness_counter" that tracks the number of errors hit in
the inode, and clears it if it appears to be garbage (as in your case),
instead of turning a pile of manure into neatly organized fertilizer.

> Pass 2: Checking directory structure
> Inode 867 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32sv.dll) has invalid mode (0152404).
> Clear<y>? yes

This is just more indication of the inodes being corrupted.

> Pass 3: Checking directory connectivity
> Pass 3A: Optimizing directories
> Error reading block 2705859237 (Invalid argument).  Ignore error<y>? yes
> 
> Force rewrite<y>? yes
> 
> Error writing block 2705859237 (Invalid argument).  Ignore error<y>? yes

Hmm, is this read beyond EOF?  The block pointers should be fixed by this
time, so there may be a hole in e2fsck at this point.  I assume you do
not have a 10TB filesystem here.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

