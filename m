From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Wed, 04 Aug 2010 16:44:10 +0200
Message-ID: <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com>
Cc: viro@zeniv.linux.org.uk, miklos@szeredi.hu, jblunck@suse.de,
	hch@infradead.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, vaurora@redhat.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1276627208-17242-15-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Tue, 15 Jun 2010 11:39:44 -0700)
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 15 Jun 2010, Valerie Aurora wrote:
> Add support for fallthru directory entries to ext2.

If a previously used ext2 filesystem with is mounted again then
fallthroughs don't appear to work as expected.  Stat returns ENOENT
for these entries.

Can't see anything obviously wrong with the code.

> 
> XXX What to do for d_ino for fallthrus?  If we return the inode from
> the the underlying file system, it comes from a different inode
> "namespace" and that will produce spurious matches.  This argues for
> implementation of fallthrus as symlinks because they have to allocate
> an inode (and inode number) anyway, and we can later reuse it if we
> copy the file up.

That's an idea, but I guess it won't make everyone happy since it
wastes both disk space and memory.

One of the key differentiators for union mounts concept was that it
doesn't duplicate inodes and dentries from the layers.  With the
directory copyup on lookup that's already partially lost, but that can
be justified by the fact that non-directories usually far outnumber
directories.

Another idea is to use an internal inode and make all fallthroughs be
hard links to that.

I think the same would work for whiteouts as well.  I don't like the
fact that whiteouts are invisible even when not mounted as part of a
union.

Miklos
