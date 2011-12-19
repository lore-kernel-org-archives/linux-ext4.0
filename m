From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 07/10] libext2fs: use the rbtree bitmap by default when
 initializing a file system
Date: Mon, 19 Dec 2011 15:17:08 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1112191516400.30656@dhcp-27-109.brq.redhat.com>
References: <1324190558-7436-1-git-send-email-tytso@mit.edu> <1324190558-7436-8-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1112191424580.30656@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab1LSORN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 09:17:13 -0500
In-Reply-To: <alpine.LFD.2.00.1112191424580.30656@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 19 Dec 2011, Lukas Czerner wrote:

> On Sun, 18 Dec 2011, Theodore Ts'o wrote:
> 
> > This change causes the max resident memory of mke2fs, as reported by
> > /usr/bin/time, to drop from 9296k to 5328k when formatting a 25
> > gig volume.
> 
> Just for the record, creating bigger file system will show much bigger
> difference. For example when creating 100T file system with the old
> bitarray backend it will consume 14GB of memory, but with the new rbtree
> backend it will only consume 220 MB (reported by /usr/bin/time).
> 
> Actually the real allocated memory according to valgrind is 54MB for
> rbtree and 3.74GB for bitmap backend. I assume that /usr/bin/time shows
> amount of dirtied memory pages ??
> 
> A while ago I have done some testing on older version of e2fsprogs with
> rbtree patches. The numbers might differ now, but the overall difference
> between rbtree and bitmaps should be roughly the same. Here are some
> graphs:
> 
> http://people.redhat.com/lczerner/e2fsprogs_memory/graphs.pdf

Also the testing has been done on e2fsck, rather than mke2fs.

> 
> Thanks!
> -Lukas
> 
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  lib/ext2fs/initialize.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> > index b050a0a..a63ea18 100644
> > --- a/lib/ext2fs/initialize.c
> > +++ b/lib/ext2fs/initialize.c
> > @@ -112,6 +112,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
> >  	fs->magic = EXT2_ET_MAGIC_EXT2FS_FILSYS;
> >  	fs->flags = flags | EXT2_FLAG_RW;
> >  	fs->umask = 022;
> > +	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
> >  #ifdef WORDS_BIGENDIAN
> >  	fs->flags |= EXT2_FLAG_SWAP_BYTES;
> >  #endif
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
