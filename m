From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] Large EAs
Date: Wed, 26 Nov 2008 14:49:29 -0700
Message-ID: <20081126214929.GZ3186@webber.adilger.int>
References: <1226954173.3972.70.camel@localhost>
 <20081126044138.GD1410@mit.edu>
 <460220570811252200t5d9e4aaax95f73843b8f3e482@mail.gmail.com>
 <20081126065439.GA27490@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Kalpak Shah <kalpak.shah@gmail.com>,
	Kalpak Shah <Kalpak.Shah@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57565 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYKZVte (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 16:49:34 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAQLnXXL008103
	for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 13:49:33 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAY00001N529Q00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 26 Nov 2008 13:49:33 -0800 (PST)
In-reply-to: <20081126065439.GA27490@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 26, 2008  01:54 -0500, Theodore Ts'o wrote:
> It's already the case that if we have an orphaned EA block, we'll lose
> it.  The question is whether it's important to keep a large EA if it
> gets orphaned, especially given that there are already plenty ways
> that we can lose EA's (i.e., ftp, tar, NFSv3, etc.).  So if someone is
> going to store a multi-megabyte EA, and we lose it because the inode
> it was attached to gets destroyed, or the inode gets corrupted to the
> point where we can't find the root of the EA tree --- the question is
> --- will we care?

One benefit I think is that at least the orphaned EA inode can be
cleaned up instead of lingering in the middle of the shared EA tree.

The other issue is that I don't want to give up the e_hash field for
the EA, because that is a useful checksum of the EA contents.

Another benefit of having separate EAs is that it makes it tractable to
modify very large EAs.  Otherwise, if there are a number of large
EAs shared in a single tree they would all have to be modified in order
to store a larger value for an EA in the middle of the tree.

To be honest, I don't think that it is worth a great deal of effort to
optimize this corner case.  I would rather keep the EA structure simple,
and if running out of inodes is a problem we would be far better off to
have a much more widely useful solution like dynamic inode tables instead
of working around that limitation with complex EA code.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

