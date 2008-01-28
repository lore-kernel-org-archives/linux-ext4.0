From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs: pu branch
Date: Mon, 28 Jan 2008 09:38:42 -0500
Message-ID: <20080128143842.GA9881@mit.edu>
References: <1201278779.23187.7.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58308 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753763AbYA1Oiv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2008 09:38:51 -0500
Content-Disposition: inline
In-Reply-To: <1201278779.23187.7.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2008 at 05:32:59PM +0100, Valerie Clement wrote:
> Hi Ted,
> 
> Here are the problems I found when testing e2fsprogs built in the "pu"
> branch. I've checked that they haven't been fixed in the latest version.
> (git describe => v1.40.3-98-gb6fea68)
> 
> 1- "Corrupt extent header" report from e2fsck
>   =======================================================
> 
> Steps to reproduce it:
> Copy a regular file on the ext4 filesystem and make a symbolic links to it:
> # ln -s foo lnk
> Unmount fs.
> 
> # e2fsck -f /dev/sdc0
> e2fsck 1.40.3 (05-Dec-2007)
> Pass 1: Checking inodes, blocks, and sizes
> Error while reading over extent tree in inode 49105: Corrupt extent header
> Clear inode<y>

This is a kernel-level bug, actually.  The symlink is a "fast symlink"
where the target of the symlink is in inode itself.  The kernel level
code should *not* be setting the EXTENTS_FL flag.  Still, we'll have
to put in some code to work around it for people with current kernel
levels.

> 2- "EXT2 directory corrupted" report from debugfs
>   ===================================i===========
> When trying to debug the previous problem using debugfs: 
> 
> debugfs:  ncheck 49105
> ncheck: EXT2 directory corrupted while calling ext2_dir_iterate
> ncheck: EXT2 directory corrupted while calling ext2_dir_iterate
> ncheck: EXT2 directory corrupted while calling ext2_dir_iterate

Not all parts of the ext2 library have been fixed to understand
extents (in particular, ext2_dir_iterate).  On the todo list...

> 3- Strange "FILE SYSTEM WAS MODIFIED" report from e2fsck.
>   =======================================================
> 
> The test just creates an empty file so it is surprising that e2fsck modifies
> the filesystem. 
> I found the reason of this modification when reading the git logs, e2fsck
> backups the primary superblock to the backups when the feature sets are 
> different (EXT3_FEATURE_INCOMPAT_EXTENTS in that case).
> 
> It's not really a problem, it's just confusing. To see with other users,
> perhaps.

Yeah, we should add a explanatory message for that case.  Thanks for
pointing that out.

					- Ted
