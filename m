From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Large buffer cache in EXT4
Date: Sun, 17 Feb 2013 23:35:17 -0500
Message-ID: <20130218043517.GB10361@thunk.org>
References: <CAEUQcegw=gq9ndo=Zd4xC2gJDZrRzNpS2hAZW9x5Lh=KL_YDHQ@mail.gmail.com>
 <201302171125.40116.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Subranshu Patel <spatel.ml@gmail.com>, linux-ext4@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48702 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756775Ab3BREfX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Feb 2013 23:35:23 -0500
Content-Disposition: inline
In-Reply-To: <201302171125.40116.Martin@lichtvoll.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 17, 2013 at 11:25:39AM +0100, Martin Steigerwald wrote:
>=20
> What I never really understand was what is the clear distinction betw=
een=20
> dirty pages and disk block buffers. Why isn=B4t anything that is abou=
t to be=20
> written to disk in one cache?

The buffer cache is indexed by physical block number, and each buffer
in the buffer cache is the size of the block size used for I/O to the
device.

The page cache is indexed by <inode, page frame number>, and each page
is the size of a VM page (i.e.4k for x86 systems, 16k for Power
systems, etc.)

Certain file systems, including ext3, ext4, and ocfs2, use the jbd or
jbd2 layer to handle their physical block journalling, and this layer
fundamentally uses the buffer cache, since it is concerned with
controlling when specific file system blocks are allowed to ben
written back to the hard drive.

Other file systems may not support file system blocks smaller than 4k.
This may make it easier for them to use the page cache for their
metadata blocks, although I don't know what happens if you try to
mount a btrfs file system formatted with 4k blocks on an architecture
such as Power which has 16k pages.  I don't know if it will work, or
blow up in a spectacular display of sparks.  :-)

In practice, it really doesn't matter.  The actual data storage for
the buffer cache (i.e., where the b_data field points to in the struct
buffer_head) is actually in the page cache, so from a space
perspective it doesn't really matter.  File systems like ext3 and ext4
which use the buffer cache for metadata blocks need to be careful than
when a directory (which is metadata) is deleted, that the blocks in
the buffer cache are zapped so that if the space on disk is reused for
data file (which is cached in the page cache), that the stale entries
in the buffer cache aren't at risk of being written back to the disk.
But that's just a tiny a implementation detail....

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
