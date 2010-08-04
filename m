From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Wed, 4 Aug 2010 19:04:22 -0400
Message-ID: <20100804230421.GC29353@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com> <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602Ab0HDXEy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 19:04:54 -0400
Content-Disposition: inline
In-Reply-To: <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 04, 2010 at 04:44:10PM +0200, Miklos Szeredi wrote:
> On Tue, 15 Jun 2010, Valerie Aurora wrote:
> > Add support for fallthru directory entries to ext2.
> 
> If a previously used ext2 filesystem with is mounted again then
> fallthroughs don't appear to work as expected.  Stat returns ENOENT
> for these entries.
> 
> Can't see anything obviously wrong with the code.
> 
> > 
> > XXX What to do for d_ino for fallthrus?  If we return the inode from
> > the the underlying file system, it comes from a different inode
> > "namespace" and that will produce spurious matches.  This argues for
> > implementation of fallthrus as symlinks because they have to allocate
> > an inode (and inode number) anyway, and we can later reuse it if we
> > copy the file up.
> 
> That's an idea, but I guess it won't make everyone happy since it
> wastes both disk space and memory.

Hm, I should probably remove this comment - I've talked over the
symlink implementation with a few people and it seems like it
introduces more problems than it solves.

> One of the key differentiators for union mounts concept was that it
> doesn't duplicate inodes and dentries from the layers.  With the
> directory copyup on lookup that's already partially lost, but that can
> be justified by the fact that non-directories usually far outnumber
> directories.

And it solves all the readdir() problems in one go. :)

> Another idea is to use an internal inode and make all fallthroughs be
> hard links to that.
> 
> I think the same would work for whiteouts as well.  I don't like the
> fact that whiteouts are invisible even when not mounted as part of a
> union.

I don't know if this helps, but I just wrote support for removing ext2
whiteouts and fallthrus using tune2fs and e2fsck.  I think this does
what people want from a "visible" whiteout feature without adding more
complexity to the VFS.  It also takes away all consideration of race
conditions and dentry conversion that happens with online removal of
whiteouts and fallthrus.

What are your thoughts on what a visible whiteout/fallthru would look
like?

Thanks,

-VAL
