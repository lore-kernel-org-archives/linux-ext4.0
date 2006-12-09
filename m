From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Fri, 8 Dec 2006 20:44:57 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612061828130.18122@compserv1>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1>
 <20061204235042.GS33919298@melbourne.sgi.com> <Pine.GSO.4.53.0612051049200.27677@compserv1>
 <20061206091100.GA33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.cs.sunysb.edu ([130.245.1.15]:44012 "EHLO
	sbcs.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947723AbWLIBpD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Dec 2006 20:45:03 -0500
To: David Chinner <dgc@sgi.com>
In-Reply-To: <20061206091100.GA33919298@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> They are defined but unused in 2.6.19, right? I can't see anywhere
> in the 2.6.19 ext2/3/4/reiser trees that actually those flags,
> including setting and retrieving them from disk. JFS i can see
> sets, clears and retreives them, but not the fielsystems you
> mention. Though I might just be blind..... ;)

Well, at least Ext2/3/4 and JFS do store these attributes and retrieve
them from the disk.  However, not a single one of these file systems
supports the related functionality (secure deletion or a trash-bin).
Clearly, this is confusing for the users.

> If all we need to add to XFS is support for those flags, then XFS
> support would be trivial to add.
>
> Oh, damn. I take that back. We're almost out of flag space in the on
> disk inode - these two flags would use the last 2 flag bits so this
> may require an on disk inode format change in XFS. This will be
> a little more complex than I first thought, but not impossible
> as we already support two on-disk inode format versions.

If you do not see any obvious use for these two bits in the near future
and ready to sacrifice them (or at least one of them) for secure deletion
and trash-bin attributes we would be more than happy to add the actual
functionality to XFS as well.

> I'd certainly like to see new functionality like this added at the
> VFS rather than in any particular filesystem. Don't know about
> anyone else, though....
>
> > I guess, the right thing to do would be to move the common trash-bin
> > (tb.c and tb.h) code into the /fs and /include/linux directories.
>
> And call them trashbin.[ch] ;)

In fact, we have already done this :-)

> > Also, VFS would require just a couple of trivial changes to support
> > something like '-o trashbin' mount-time option for all file systems.
> > In addition, individual file systems may support per-file attributes for
> > this (e.g., ext2/3/4).
>
> Sounds like a good idea to me.

Thank you!  So we will submit the corresponding patches soon.  We will
start from the trashbin.c and patches for the individual file systems.  A
little later we will submit a VFS patch to add support for the
'-o trashbin' mount option.

Nikolai Joukov
----------------------------------
Filesystems and Storage Laboratory
Stony Brook University
