From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] Large EAs
Date: Thu, 27 Nov 2008 02:27:50 -0700
Message-ID: <20081127092750.GB3186@webber.adilger.int>
References: <1226954173.3972.70.camel@localhost>
 <20081126044138.GD1410@mit.edu>
 <460220570811252200t5d9e4aaax95f73843b8f3e482@mail.gmail.com>
 <20081126065439.GA27490@mit.edu> <20081126214929.GZ3186@webber.adilger.int>
 <20081127003555.GD14101@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Kalpak Shah <kalpak.shah@gmail.com>,
	Kalpak Shah <Kalpak.Shah@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43627 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYK0J1y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Nov 2008 04:27:54 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAR9RrJC005358
	for <linux-ext4@vger.kernel.org>; Thu, 27 Nov 2008 01:27:53 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAZ00B01JHN4300@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 27 Nov 2008 01:27:53 -0800 (PST)
In-reply-to: <20081127003555.GD14101@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 26, 2008  19:35 -0500, Theodore Ts'o wrote:
> I guess I didn't make myself clear.  I was *not* suggesting that we
> share EA's in one inode, or in one extent tree.  Instead, what I
> suggested was that instead of having a pointer to an inode, if the
> value of the EA is less than half the blocksize, it is stored in the
> EA block.  If it is between 50% and 100% of the blocksize, instead of
> pointing at inode, we point to a block.  If it is greater than a
> blocksize, we point at a block containing an EA tree.  (Which means
> for a large EA the average space overhead is 6k --- 4k for the extent
> block, plus 2k for the fragmentation cost).
> 
> So this scheme very much uses separate EA's, and does not pack all of
> the EA's into a single tree.  It is deliberately kept simple precisely
> because like you I don't think it's worth it to optimize EA's.  On the
> other hand, running out of inodes is a big problem, and dynamic inodes
> is far more complicated an issue, especially if we don't have 64-bit
> inode support in the kernel and in userspace, and we need to worry
> about locality issues and how dynamic inodes work with online
> resizing. 
> 
> The tradeoff is that my scheme doesn't burn an inode for each large
> EA, but for EA's greater than a blocksize, we chew an extra block's
> worth of overhead.  Personally, I think it's a worthwhile tradeoff ---

The other issue is that if we are pointing to a direct extent tree
instead of a relative block in the inode then all of the normal IO
functions are not usable (ext3_getblk(), etc), and they would have
to be re-implemented.

It might be possible to fake out the extent handling functions and do
this by iterating over the blocks directly by virtue of passing in the
parent inode, but it seems prone to breakage.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

