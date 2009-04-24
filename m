From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 16:59:27 -0400
Message-ID: <20090424205927.GA13608@mit.edu>
References: <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de> <20090424032028.GB7949@mit.edu> <alpine.DEB.2.01.0904240153310.6162@bogon.housecafe.de> <alpine.DEB.2.01.0904240235020.6162@bogon.housecafe.de> <20090424120004.GD7949@mit.edu> <49F1B24B.7080308@redhat.com> <alpine.DEB.2.01.0904241318460.6162@bogon.housecafe.de> <49F22244.5040407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42774 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbZDXU7c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 16:59:32 -0400
Content-Disposition: inline
In-Reply-To: <49F22244.5040407@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 24, 2009 at 03:34:12PM -0500, Eric Sandeen wrote:
> So these are funny inodes:
> 
> # file mnt/lost+found/*
> mnt/lost+found/#12042: setuid setgid character special
> mnt/lost+found/#12207: setgid socket
> mnt/lost+found/#12249: setgid socket
> 
> by virtue of the corruption.
.
> so we shouldn't be checking the extent header, I think.
> 
>         if (ei->i_flags & EXT4_EXTENTS_FL) {
>                 /* Validate extent which is part of inode */
>                 ret = ext4_ext_check_inode(inode);
>         } else if ...
> 
> Or maybe fsck should be clearing the extents flag on inodes like this?
> 

Good catch!  Yeah, probably both.  The kernel should only validating
the extent header if the file is regular file, a directory, or a symlink.

And e2fsck should be clearing the extents flag on inodes like this.

I'll create the patch....

							- Ted
