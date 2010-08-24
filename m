From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Tue, 24 Aug 2010 13:21:09 -0400
Message-ID: <20100824172108.GA28718@shell>
References: <eVJmW-3Lf-15@gated-at.bofh.it> <eVJmW-3Lf-19@gated-at.bofh.it> <fdNs6-5F1-7@gated-at.bofh.it> <fdVfY-pv-23@gated-at.bofh.it> <fe6Ep-cD-13@gated-at.bofh.it> <fiCPo-73x-17@gated-at.bofh.it> <fiMc1-6ip-7@gated-at.bofh.it> <E1OlrzM-0001lZ-0z@be1.7eggert.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miklos Szeredi <miklos@szeredi.hu>, jack@suse.cz, agruen@suse.de,
	viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: 7eggert@gmx.de, David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0HXRVn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Aug 2010 13:21:43 -0400
Content-Disposition: inline
In-Reply-To: <E1OlrzM-0001lZ-0z@be1.7eggert.dyndns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 19, 2010 at 01:24:07AM +0200, Bodo Eggert wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Tue, 17 Aug 2010, Valerie Aurora wrote:
> 
> >> >  - hard links to make sure a separate inode is not necessary for each
> >> >    whiteout/fallthrough entry
> >> 
> >> The problem with hard links is that you run into hard link limits.  I
> >> don't think we can do hard links for whiteouts and fallthrus.  Each
> >> whiteout or fallthru will cost an inode if we implement them as
> >> extended attributes.  This cost has to be balanced against the cost of
> >> implementing them as dentries, which is mainly code complexity in
> >> individual file systems.
> 
> Not knowing the details, I'd suggest to implement a generic function to
> create an attributed inode and let the fs override it to create an
> unlinked-file-dentry instead.
> 
> Benefit: All fs supporting extended attributes will be able to support
> whiteout. If the fs has other means of supporting whiteout, they may fake
> the attribute.

Yeah, I think that's the way to go.

> Possible problems:
> - Having two ways of reporting a whiteout? Or can it be reported using a
>   (static) fake inode?

They are going to look the same at the VFS level and higher.

> - How do you un-whiteout while (not) having an overlaying fs?

The current version of whiteout support always hides DT_WHT dentries
from userspace.  Perhaps a start is to only hide DT_WHT entries when
the file system is union mounted.  Applications usually ignore all
dentries with d_ino == 0 so it might not cause problems.

Right now, you have to remove whiteouts offline using fsck.

> > get_unlinked_inode() is a great idea.  But I feel that individual
> > inodes for each fallthrough is excessive.  It'll make the first
> > readdir() really really expensive and wastes a lot of disk and memory
> > for no good reason.
> > 
> > Not sure how to fix the hard link limits problem though...
> 
> Do a hardlink if you can create a hard link, otherwise use a fresh inode
> and use that for the next hardlink(s).

Bleah!  Then you have a code path that is only tested when you hit
LINK_MAX.  Sounds like a recipe for bugs for me.

-VAL
