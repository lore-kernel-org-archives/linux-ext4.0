From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Thu, 05 Aug 2010 13:13:55 +0200
Message-ID: <E1OgyOZ-000321-Fp@pomaz-ex.szeredi.hu>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com> <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu> <20100804230421.GC29353@shell>
Cc: miklos@szeredi.hu, viro@zeniv.linux.org.uk, jblunck@suse.de,
	hch@infradead.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58840 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760020Ab0HELOH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 07:14:07 -0400
In-reply-to: <20100804230421.GC29353@shell> (message from Valerie Aurora on
	Wed, 4 Aug 2010 19:04:22 -0400)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 4 Aug 2010, Valerie Aurora wrote:
> > Another idea is to use an internal inode and make all fallthroughs be
> > hard links to that.
> > 
> > I think the same would work for whiteouts as well.  I don't like the
> > fact that whiteouts are invisible even when not mounted as part of a
> > union.
> 
> I don't know if this helps, but I just wrote support for removing ext2
> whiteouts and fallthrus using tune2fs and e2fsck.  I think this does
> what people want from a "visible" whiteout feature without adding more
> complexity to the VFS.  It also takes away all consideration of race
> conditions and dentry conversion that happens with online removal of
> whiteouts and fallthrus.
> 
> What are your thoughts on what a visible whiteout/fallthru would look
> like?

Best would be if it didn't need any modification to filesystems.  All
this having to upgrade util-linux, e2fsprogs, having incompatible
filesystem features is a pain for users (just been through that).

What we already have in most filesystems:

 - extended attributes, e.g. use the system.union.* namespace and
   denote whiteouts and falltroughs with such an attribute

 - hard links to make sure a separate inode is not necessary for each
   whiteout/fallthrough entry

 - some way for the user to easily identify such files when not
   mounted as part of a union e.g. make it a symlink pointing to
   "(deleted)" or whatever

Later the extended attributes can also be used for other things like
e.g. chmod()/chown() only copying up metadata, not data, and
indicating that data is still found on the lower layers.

Miklos
