From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] sanity check inode size vs inode ratio
Date: Thu, 24 May 2007 03:38:31 -0600
Message-ID: <20070524093831.GI5181@schatzie.adilger.int>
References: <20070514230311.GA5568@schatzie.adilger.int> <20070522194504.GB4668@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:47124 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbXEXJid (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 May 2007 05:38:33 -0400
Content-Disposition: inline
In-Reply-To: <20070522194504.GB4668@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 22, 2007  15:45 -0400, Theodore Tso wrote:
> On Mon, May 14, 2007 at 05:03:11PM -0600, Andreas Dilger wrote:
> > A quick patch to sanity check the inode ratio vs the inode size.  In some
> > cases Lustre users have tried specifying an inode size of 4096 bytes, while
> > keeping an inode ratio of one inode per 4096 bytes, causing mke2fs to spin
> > forever trying to allocate the inode tables.  I'm sure more people will do
> > this now that large inodes are available in ext4 and documented in e2fsprogs.
> 
> I can't replicate this.  I'm guessing you are doing this with the
> clusterfs codebase that has the extent patches?  Mke2fs shouldn't be
> spinning if it can't allocate the inode tables.  Instead it should
> print the error message:

Hmm, I suppose it might be due to running this on a 2TB filesystem that is
trying to allocate a huge number of inodes.  It could also have been with
an older version of mke2fs - it was a customer that reported the problem.

I just happened to be poking in that bit of code recently and thought I'd
add the sanity check.  I don't think it relates to CFS patches, since we
don't change mke2fs at all for the extent code.

We can let it drop for now, until I have a reproducer.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
