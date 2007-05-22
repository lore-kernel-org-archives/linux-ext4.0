From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] sanity check inode size vs inode ratio
Date: Tue, 22 May 2007 15:45:04 -0400
Message-ID: <20070522194504.GB4668@thunk.org>
References: <20070514230311.GA5568@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49143 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757819AbXEVVRt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 May 2007 17:17:49 -0400
Content-Disposition: inline
In-Reply-To: <20070514230311.GA5568@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 14, 2007 at 05:03:11PM -0600, Andreas Dilger wrote:
> A quick patch to sanity check the inode ratio vs the inode size.  In some
> cases Lustre users have tried specifying an inode size of 4096 bytes, while
> keeping an inode ratio of one inode per 4096 bytes, causing mke2fs to spin
> forever trying to allocate the inode tables.  I'm sure more people will do
> this now that large inodes are available in ext4 and documented in e2fsprogs.

I can't replicate this.  I'm guessing you are doing this with the
clusterfs codebase that has the extent patches?  Mke2fs shouldn't be
spinning if it can't allocate the inode tables.  Instead it should
print the error message:

% ./mke2fs -F -I 4096 -i 4096 -b 4096 -j /tmp/foo.img
mke2fs 1.40-WIP (07-Apr-2007)
Warning: 4096-byte inodes not usable on older systems
/tmp/foo.img: Not enough space to build proposed filesystem while setting up superblock

I don't have an objection with a patch that prints a more explicit
patch, but even with your change, there will still be combinations
that won't trigger your patch, but if there is a bug in your applied
patch series, we should root cause the problem that is causing mke2fs
spin forever, since that will probably cause problems elsewhere:

% ./mke2fs -F -I 4096 -N 4095 -b 4096 -j /tmp/foo.img 4096
mke2fs 1.40-WIP (07-Apr-2007)
Warning: 4096-byte inodes not usable on older systems
/tmp/foo.img: Not enough space to build proposed filesystem while setting up superblock

						- Ted
