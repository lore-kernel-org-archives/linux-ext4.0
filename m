From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC/PATCH 3/3] ext4: add EXT4_IOC_GOINGDOWN ioctl
Date: Thu, 2 Feb 2017 21:22:24 -0500
Message-ID: <20170203022224.idwexzwnqmbyskbj@thunk.org>
References: <20170202225924.19301-1-tytso@mit.edu>
 <20170202225924.19301-4-tytso@mit.edu>
 <20170203000204.GK14029@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57028 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751653AbdBCCWb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 2 Feb 2017 21:22:31 -0500
Content-Disposition: inline
In-Reply-To: <20170203000204.GK14029@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 02, 2017 at 04:02:04PM -0800, Darrick J. Wong wrote:
> >  
> > +#define EXT4_IOC_GOiNGDOWN _IOR ('X', 125, __u32)
> 
> Lowercase 'i'?

Yeah, oops.  Already fixed.

> ISTR Dave asking if we could rename it IOC_SHUTDOWN way back when f2fs
> was trying to implement it.

Yeah, I decided to evade the whole discussion about which names should
land in include/uapi/fs.h.  (e.g., xxx_GOING_FLAGS_LOGFLUSH vs
xxx_GOING_FLAGS_METAFLUsh, etc.)

Once we have names that everyone is happy with, it'll be simple enough
to do the rename the identifiers.

> 
> /me wonders if mount -o errors=shutdown follows from this? :)
> 
> (Something a little less drastic than errors=panic that stops everything
> in its tracks.)

Yeah, I was thinking about that.  We have errors=readonly already,
which is actually not _that_ different from errors=shutdown.  (I
noticed for example that xfs doesn't have a shutdown check in
xfs_vm_readpage and and xfs_vm_readpages.)

One of the things we probably should do is make clear what are the
semantics with FS_IOC_SHUTDOWN.  For example, should readpages()
return an error on a shutdown file system, or not?

And as I've observed already, there are a number of tests in xfstsests
that are enabled when the fs supports shutdown that are very specific
to how delayed allocation and writes are handled.  How much this needs
to be fundamental to the shutdown API?  A lot of this depends on which
applications would actually be using shutdown, and whether they care
about what happens with a write followed by truncate followed
shutdown.

						- Ted
