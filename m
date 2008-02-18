From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][7/28] e2fsprogs-extents.patch
Date: Mon, 18 Feb 2008 14:53:32 -0500
Message-ID: <20080218195332.GK25098@mit.edu>
References: <20080202075943.GB23836@webber.adilger.int> <20080202082559.GG31694@webber.adilger.int> <20080202082701.GH31694@webber.adilger.int> <47B9C6E5.2010304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45751 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753026AbYBRTxo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 14:53:44 -0500
Content-Disposition: inline
In-Reply-To: <47B9C6E5.2010304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2008 at 11:56:53AM -0600, Eric Sandeen wrote:
> So this trips up on things like sockets, fifos, and block & char nodes.
> 
> Also this is unhappy:
> 
> > @@ -137,7 +141,7 @@ int e2fsck_pass1_check_device_inode(ext2
> >  	 * If the index flag is set, then this is a bogus
> >  	 * device/fifo/socket
> >  	 */
> > -	if (inode->i_flags & EXT2_INDEX_FL)
> > +	if (inode->i_flags & (EXT2_INDEX_FL | EXT4_EXTENTS_FL))
> >  		return 0;
> 
> Do we really care if these have the extents flag set?  IOW should we
> make sure the kernel doesn't set the flag, or should we make e2fsck not
> care...

<Sigh>

I think we need to get kernel patches into mainline ASAP not to set
the EXTENTS_FL --- be conservative in what you send --- and at least
for now, e2fsck needs to accept (and not complain or core dump) if
EXTENTS_FL is set for files where ext2fs_inode_has_valid_blocks()
returns false --- be liberal in what you accept.  

Eventually, after the kernel patches hit mainline, we could change
e2fsck to automatically fix all of these in preen mode, just for
cleanliness sake.

						- Ted
