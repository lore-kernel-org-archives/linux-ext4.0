From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: avoid overflow in pass5 check_block_end()
Date: Sun, 6 Sep 2009 13:57:18 -0400
Message-ID: <20090906175718.GM3055@mit.edu>
References: <4A9DA2DC.10001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45459 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbZIFR5T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Sep 2009 13:57:19 -0400
Content-Disposition: inline
In-Reply-To: <4A9DA2DC.10001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 01, 2009 at 05:40:28PM -0500, Eric Sandeen wrote:
> When making a filesystem as in:
> 
> mke2fs -E lazy_itable_init=1 -O uninit_bg -b 4096 bigfile 4294967298
> 
> a subsequent fsck would result in:
> 
> Pass 5: Checking group summary information
> Internal error: fudging end of bitmap (3)
> e2fsck: aborted
> 
> This is because check_block_end() was overflowing in the calculation
> for "end", and giving it a value of -1 (0xFFFF....) which eventually
> ended up tripping up a test in ext2fs_fudge_generic_bmap_end,
> 
>         if (end > bitmap->real_end)
>                 return neq;
> 
> Fix another such error in read_bitmaps() as well.
> 
> lib/ext2fs/imager.c likely has similar problems but it looks like
> it has no 64-bit treatment at all yet.

Applied to the e2fsprogs 64-bit patch queue / pu.

	       		 	      	      - Ted
