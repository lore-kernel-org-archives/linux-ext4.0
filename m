From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][e2fsprogs] Move ext2fs_struct_generic_bitmap back into ext2fs.h
Date: Thu, 9 Aug 2007 17:42:54 -0400
Message-ID: <20070809214254.GB5438@thunk.org>
References: <20070807211639.22127.99361.stgit@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44755 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760306AbXHJNaH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Aug 2007 09:30:07 -0400
Content-Disposition: inline
In-Reply-To: <20070807211639.22127.99361.stgit@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 07, 2007 at 04:16:39PM -0500, Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Move ext2fs_struct_generic_bitmap back into ext2fs.h
> 
> In Commit: f1f115a78f5ea599fc5f8815a741d43fedd5840d
> 
> The ext2fs_struct_generic_bitmap structure is remove from ext2fs.h and
> put into gen_bitmap.c.  This breaks big endian compiles since swapfs.c
> uses this structure as well if EXT2_BIG_ENDIAN_BITMAPS is defined.

Actually, it's rw_bitmaps.c, and I don't want to do this because this
is part of the cleanups where I am trying to localize code that knows
about the in-memory encoding of bitmaps.

It turns out the need for this was only in the very first ports of
Linux to the Powerpc, and there haven't been kernels that would mount
big-endian superblocks since, oh, 1998 or so (in the 2.0 days).

So probably the better fix is one where we don't allow big-endian
filesystems any more.  On all modern systems, we use little-endian
encoding of the superblock, and the bitmaps don't need byte-swapping.

							- Ted
