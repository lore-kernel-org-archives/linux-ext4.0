From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, E2FSPROGS] On-disk format for inode extra size control inode size
Date: Wed, 18 Oct 2006 18:16:18 -0400
Message-ID: <20061018221618.GA12378@thunk.org>
References: <E1Ga4rR-000534-CE@candygram.thunk.org> <20061018193437.GG3509@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50137 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1423071AbWJRWQX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 18:16:23 -0400
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20061018193437.GG3509@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 18, 2006 at 01:34:38PM -0600, Andreas Dilger wrote:
> There was some discussion about moving the i_ctime_extra field into the
> small inode, for use as a version field by NFSV4.  The proposed field was
> l_i_reserved2 in the original Bull patch.

The potential problem with this is what if program makes a huge number
of changes to inodes, such that we end up having to bump the ctime
field into the future?

But I have another question --- why does this the change attribute
counter have to be a persistent value that takes up space in the inode
at all?  This is strictly a NFSv4 only hack, and NFSv4 simply requires
a 64-bit increasing counter when any inode attributes have changed, so
it can determine whether client-side caches are refreshed.

So let the high 32-bits of the attribute value be the time in seconds
that the system was booted (or the filesystem was mounted; I don't
care), and let the low 32-bit values be a value which is stored in the
in-core inode which is set to a global counter value which is
incremented whenever inode is changed.  If the in-core inode gets
dropped and then later reloaded, it will get a newer global counter
value, which may forced some clients to reload their cache when they
may not have needed to --- and the same would happen if the server
gets rebooted, since the high 32-bits would get bumped to the new
mount time.

But that's not a big deal, since it's only there to make client-side
caching side more efficient.  In these cases the clients may need to
refresh their inode cache from the server, but is that really going to
be such a bad thing?  

						- Ted
