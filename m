From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH, E2FSPROGS] On-disk format for inode extra size control inode size
Date: Wed, 18 Oct 2006 16:59:34 -0600
Message-ID: <20061018225934.GL3509@schatzie.adilger.int>
References: <E1Ga4rR-000534-CE@candygram.thunk.org> <20061018193437.GG3509@schatzie.adilger.int> <20061018221618.GA12378@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:8644 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1423140AbWJRW7j
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 18:59:39 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061018221618.GA12378@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 18, 2006  18:16 -0400, Theodore Tso wrote:
> On Wed, Oct 18, 2006 at 01:34:38PM -0600, Andreas Dilger wrote:
> > There was some discussion about moving the i_ctime_extra field into the
> > small inode, for use as a version field by NFSV4.  The proposed field was
> > l_i_reserved2 in the original Bull patch.
> 
> The potential problem with this is what if program makes a huge number
> of changes to inodes, such that we end up having to bump the ctime
> field into the future?

Well, if you are changing the inode billions of times/second for any
extended amount of time, then yes that might be possible.  Normally
setting it to the current ctime and incrementing the nsec timestamp
on the rare cases two threads are updating it at once is sufficient.
Note that in this version is only critical to compare for a single
inode, and not filesystem-wide.

> But I have another question --- why does this the change attribute
> counter have to be a persistent value that takes up space in the inode
> at all?  This is strictly a NFSv4 only hack, and NFSv4 simply requires
> a 64-bit increasing counter when any inode attributes have changed, so
> it can determine whether client-side caches are refreshed.

Well, Lustre has a need for this also, in order to know if a particular
modification to an inode has been done or not.  Using the nsec ctime is
a way of saving space in the inode, while at the same time allowing two
operations to be ordered relative to each other.  This needs to be
persistent across a server reboot for both NFSv4 and Lustre.

Since i_ctime_extra needs to be stored on disk anyways, I don't see why
there would be an objection to having it serve a dual purpose.  For
Lustre we don't actually care whether it is in the core inode, since we
always format filesystems with large inodes anyways, but in consideration
of NFSv4 exporting existing ext3 filesystems I suggested i_ctime_extra go
into the core inode.

> So let the high 32-bits of the attribute value be the time in seconds
> that the system was booted (or the filesystem was mounted; I don't
> care), and let the low 32-bit values be a value which is stored in the
> in-core inode which is set to a global counter value which is
> incremented whenever inode is changed.  If the in-core inode gets
> dropped and then later reloaded, it will get a newer global counter
> value, which may forced some clients to reload their cache when they
> may not have needed to --- and the same would happen if the server
> gets rebooted, since the high 32-bits would get bumped to the new
> mount time.

This would work, I suppose.  It doesn't allow this value to be exported
to userspace without additional API changes as the i_ctime_extra one can.
The initial Bull patch consumed an extra field in struct stat, stat64,
struct inode, and struct iattr in order to allow userspace access also.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
