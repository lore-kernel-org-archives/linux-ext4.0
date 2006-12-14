From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [patch 2/3] change attribute for ext4: ext4 specific code
Date: Thu, 14 Dec 2006 15:57:10 -0700
Message-ID: <20061214225710.GM5937@schatzie.adilger.int>
References: <456DD75A.2010700@bull.net> <20061206214934.GA4551@schatzie.adilger.int> <45803906.5070307@bull.net> <20061214160307.GE9079@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cordenner jean noel <jean-noel.cordenner@bull.net>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:36168 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbWLNW5O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Dec 2006 17:57:14 -0500
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061214160307.GE9079@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Dec 14, 2006  11:03 -0500, Theodore Tso wrote:
> There was discussion on yesterday's call about whether or not 32-bit
> was enough for NFSv4, or whether it also requried 64-bits of change
> notification in the RFC's.  So one of the questions is whether this is
> something that would justify requiring 64-bits --- and if so, maybe we
> need to require that big inodes be used and store the entire 64-bit
> value beyond 128 bytes.  This would mean that NFSv4 cache management
> couldn't be fully implemented without big inodes, or we'd have to make
> do by using the inode ctime as a partial substitute.

Per Trond and Bruce Field's reply to my email it seems that NFSv4 only
needs the version to compare for inequality.  If the change numbers are
sequential for a given inode it can OPTIONALLY extract additional
information about the server (i.e. it still has an up-to-date cache
because it was the only one that did an update on a given file).

So, I think for basic NFSv4 setups that 2^32 is sufficient (per Bull's
original patch) but 2^64 is desirable to avoid collisions and allow the
"sequential updates" logic to work properly for long-lived files.

So, I think a 32-bit field in the small inode, and an additional 32-bit
field in the large inode would be perfect.  It allows this functionality
to work with existing ext3 filesystems, if not quite optimally.

In addition, for Lustre, could we get a 64-bit field in the superblock
which contains the fs-wide version number.

I'm proposing that, per the original Bull patch, l_i_reserved1 be changed
to be i_version for linux, and we add i_version_hi after cr_time_extra in
the large inode.  The disk i_version would be stored in the vfs_inode
i_version (which is already used for this same purpose).  It would be good
for NFSv4 if the i_version field could be expanded to 64 bits to avoid
the need for it to have fs-specific operations, but failing that we can
put the high word into ext4_inode_info and NFS can access it via
export_operations I think.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
