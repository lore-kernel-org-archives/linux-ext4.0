From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: One more corrupted fs crash in ext4_put_super
Date: Thu, 9 Oct 2014 13:49:13 -0700
Message-ID: <20141009204913.GA9620@birch.djwong.org>
References: <20141005001239.GD27150@sli.dy.fi>
 <20141007205643.GF27150@sli.dy.fi>
 <20141009201541.GG27150@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34199 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaJIUt3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2014 16:49:29 -0400
Content-Disposition: inline
In-Reply-To: <20141009201541.GG27150@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 09, 2014 at 11:15:41PM +0300, Sami Liedes wrote:
> On Tue, Oct 07, 2014 at 11:56:43PM +0300, Sami Liedes wrote:
> > Here's one more filesystem that causes a crash in ext4_put_super on
> > 3.17 both with and without the two patches from this thread applied.
> 
> Ok, I bisected a bit. FWIW.
> 
> No crash on 3.16.4 + these two patches:
> 
> 1c8944cbe1b ext4: add ext4_iget_normal() which is to be used for dir tree lookups
> b65ad45743c ext4: don't orphan or truncate the boot loader inode
> 
> Crash on 3.17 + the above two patches.
> 
> The first commit that crashes on this test with the above patches:

Yeah.  There's a directory that's linked twice (inode 195).  The subsequent FS
walk loads the inode into memory twice (== i_count > 2).  When you delete
everything on the FS, the inode gets put on the in-memory orphan list but for
whatever reason doesn't seem to get released via iput or something.  This means
it's still on the orphan list at umount time, which triggers the BUG.  Worse
yet, i_nlink is now 0...

...not clear what the appropriate course of action is here.  The FS is corrupt
and we need to scrape the mess off the machine.  I guess you could -EIO earlier
when you notice i_count > i_nlink?

--D

> 
> # first bad commit: [908790fa3b779d37365e6b28e3aa0f6e833020c3] dcache: d_splice_alias mustn't create directory aliases
> 
> commit 908790fa3b779d37365e6b28e3aa0f6e833020c3
> Author: J. Bruce Fields <bfields@redhat.com>
> Date:   Mon Feb 17 17:58:42 2014 -0500
> 
>     dcache: d_splice_alias mustn't create directory aliases
> 
>     Currently if d_splice_alias finds a directory with an alias that is not
>     IS_ROOT or not DCACHE_DISCONNECTED, it creates a duplicate directory.
> 
>     Duplicate directory dentries are unacceptable; it is better just to
>     error out.
> 
>     (In the case of a local filesystem the most likely case is filesystem
>     corruption: for example, perhaps two directories point to the same child
>     directory, and the other parent has already been found and cached.)
> 
>     Note that distributed filesystems may encounter this case in normal
>     operation if a remote host moves a directory to a location different
>     from the one we last cached in the dcache.  For that reason, such
>     filesystems should instead use d_materialise_unique, which tries to move
>     the old directory alias to the right place instead of erroring out.
> 
>     Signed-off-by: J. Bruce Fields <bfields@redhat.com>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> -- 
> 
> 	Sami


