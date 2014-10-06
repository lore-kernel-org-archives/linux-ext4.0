From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: add ext4_iget_normal() which is to be used for
 dir tree lookups
Date: Sun, 5 Oct 2014 23:16:04 -0400
Message-ID: <20141006031604.GB5755@thunk.org>
References: <20141005001239.GD27150@sli.dy.fi>
 <1412563682-5720-1-git-send-email-tytso@mit.edu>
 <1412563682-5720-2-git-send-email-tytso@mit.edu>
 <CCC111D5-362C-40B5-B19C-24C4E66BD963@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37631 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaJFDQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Oct 2014 23:16:08 -0400
Content-Disposition: inline
In-Reply-To: <CCC111D5-362C-40B5-B19C-24C4E66BD963@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 05, 2014 at 08:52:38PM -0600, Andreas Dilger wrote:
> On Oct 5, 2014, at 8:48 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > If there is a corrupted file system which has directory entries that
> > point at reserved, metadata inodes, prohibit them from being used by
> > treating them the same way we treat Boot Loader inodes --- that is,
> > mark them to be bad inodes.  This prohibits them from being opened,
> > deleted, or modified via chmod, chown, utimes, etc.
> > 
> > In particular, this prevents a corrupted file system which has a
> > directory entry which points at the journal inode from being deleted
> > and being released, after which point Much Hilarity Ensues.
> 
> Wouldn't it be safer to change "ext4_iget()" to have these checks, 
> and add an "ext4_iget_special()" or "ext4_iget_reserved()" for use
> in the few places that are opening reserved inodes?  That would
> probably be safer for the future.

There is actually much larger set of places where we iget reserved
inodes -- in fact, double the he number of places where we return
inodes back up to the VFS --- 3 for the latter, and 6 for the former.

As for future additions, it's much more likely that we would be adding
new code paths to read reserved inodes.  New VFS functionality tends
to go through the dcache layer, so I don't see the likelihood of
needing to add a new call to ext4_iget_normal() any time soon.

Cheers,

						- Ted
