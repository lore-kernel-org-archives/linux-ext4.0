From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: remove fragment support (V3)
Date: Sat, 11 Aug 2007 23:31:29 -0400
Message-ID: <20070812033129.GB21719@thunk.org>
References: <46BC9CC3.9090005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
To: Coly Li <coyli@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57346 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758709AbXHLDcI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Aug 2007 23:32:08 -0400
Content-Disposition: inline
In-Reply-To: <46BC9CC3.9090005@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 11, 2007 at 01:13:39AM +0800, Coly Li wrote:
> -----BEGIN PGP SIGNED MESSAGE-----

If you're going to use PGP signatures, please use the MIME-PGP that
doesn't cause annoying quoting to take place, i.e.:

> - -   switch (os) {
> - -       case EXT2_OS_HURD:
> - -           frag = inode->osd2.hurd2.h_i_frag;

Also, please take a look at my recent patch series to remove support
for PPC big-endian byte-swapped filesystems.  Separate patches which
makes it obvious what is being removed and makes it easy to review are
much appreciated.

In addition, for now, I'd like to keep the code which checks the
remaining fragment fields in the inode and superblock since they act
as a safety check to make sure the filesystem is sane and we don't
have garbage there.  The checksum fields will obviate this need, but
keeping the checks there for ext2/ext3 filesystems seem like a good
idea.

Dropping the union is probably fine, since at this point it looks
pretty clear that both the Hurd and Masix is dead.  But let's do the
cleanups a little at a time, and I'd probably start with just removing
the cruft from the mke2fs options and man pages.

Regards,

    	       	   	  	      - Ted
