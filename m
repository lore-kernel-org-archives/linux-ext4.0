From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Tue, 17 Aug 2010 18:27:32 -0400
Message-ID: <20100817222731.GI5556@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com> <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu> <20100804230421.GC29353@shell> <E1OgyOZ-000321-Fp@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0HQW1x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Aug 2010 18:27:53 -0400
Content-Disposition: inline
In-Reply-To: <E1OgyOZ-000321-Fp@pomaz-ex.szeredi.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 05, 2010 at 01:13:55PM +0200, Miklos Szeredi wrote:
> On Wed, 4 Aug 2010, Valerie Aurora wrote:
> > > Another idea is to use an internal inode and make all fallthroughs be
> > > hard links to that.
> > > 
> > > I think the same would work for whiteouts as well.  I don't like the
> > > fact that whiteouts are invisible even when not mounted as part of a
> > > union.
> > 
> > I don't know if this helps, but I just wrote support for removing ext2
> > whiteouts and fallthrus using tune2fs and e2fsck.  I think this does
> > what people want from a "visible" whiteout feature without adding more
> > complexity to the VFS.  It also takes away all consideration of race
> > conditions and dentry conversion that happens with online removal of
> > whiteouts and fallthrus.
> > 
> > What are your thoughts on what a visible whiteout/fallthru would look
> > like?
> 
> Best would be if it didn't need any modification to filesystems.  All
> this having to upgrade util-linux, e2fsprogs, having incompatible
> filesystem features is a pain for users (just been through that).
> 
> What we already have in most filesystems:
> 
>  - extended attributes, e.g. use the system.union.* namespace and
>    denote whiteouts and falltroughs with such an attribute

Jan Kara helped convince me this might be better than fs-specific
fallthrus and whiteouts.  See my email on get_unlinked_inode().

>  - hard links to make sure a separate inode is not necessary for each
>    whiteout/fallthrough entry

The problem with hard links is that you run into hard link limits.  I
don't think we can do hard links for whiteouts and fallthrus.  Each
whiteout or fallthru will cost an inode if we implement them as
extended attributes.  This cost has to be balanced against the cost of
implementing them as dentries, which is mainly code complexity in
individual file systems.

>  - some way for the user to easily identify such files when not
>    mounted as part of a union e.g. make it a symlink pointing to
>    "(deleted)" or whatever

Perhaps we can simply not interpret the whiteout/fallthru extended
attributes when the file system is not unioned and let userland
operate on them via getxattr()/setxattr().

> Later the extended attributes can also be used for other things like
> e.g. chmod()/chown() only copying up metadata, not data, and
> indicating that data is still found on the lower layers.

It would certainly be more extensible than in-dentry flags.

-VAL
