From: tytso@mit.edu
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Mon, 21 Jun 2010 13:05:56 -0400
Message-ID: <20100621170556.GB6843@thunk.org>
References: <AANLkTilD3D2QOXi1b7oXT2uFBx_vuO803HOX4JJXfWG0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Hsuan-Ting <acht93@cs.ccu.edu.tw>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57947 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978Ab0FURF7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jun 2010 13:05:59 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTilD3D2QOXi1b7oXT2uFBx_vuO803HOX4JJXfWG0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 21, 2010 at 09:44:31PM +0800, Hsuan-Ting wrote:
> Hi Ted,
> 
>    Resize seems not work when the size is bigger than 16TB (offline resize).
> 
> My test machine:
> x64 platform 2.6.32 kernel + this newest patch
> 
> 1. <16TB ext4 enlarge to >16TB (offline)
>     a. I use "8 x 2TB WD disks" and "mdadm" build linear raid
>     b. then use mkfs.ext4 to make ext4 file system
>     c. grow the linear raid to "10 X 2TB"
>     d. finally it grow to "2.X TB" smaller than before

This doesn't surprise me.  We should add some checks to simply not
allow the file system growing greater than 16TB if the 64-bit feature
is not set for now.  Making this work is going to be tricky, because
enabling the 64-bit feature doubles the size of the block group
descriptors, which means we have to make room for them.  This could
involve moving files out of the way, as well as moving the inode
table.

This means that we may want to enable the 64-bit feature flag if there
is an expectation that the filesystem might be grown to a size large
enough where this would be an issue.

> 2. >16TB offline resize, the steps is similiar as before.
>    a. I use "9 x 2TB WD disks" build linear raid
>    b. mkfs.ext4 and not mount
>    c. grow the linear raid to "10 X 2TB"
>    d. do resize
>    e. finally it grow to "2.X TB" smaller than before
> 
> I try to on "EXT4_FEATURE_INCOMPAT_64BIT" and "EXT2_FLAG_64BITS"
> when mkfs and resize.
> And modify ext2fs_div_ceil code to ext2fs_div64_ceil.
> It seems work something, the fs size isn't grow but also not deduce,
> remain the same.

I'm not sure I understand that last sentence; it's not parsing as an
understandable English sentence, sorry.  Are you saying that both
attempts to grow and shrink the filesystem is failing?  If so, how?
Are you getting an error message?  Is it appearing to succeed but the
file system size isn't changing?

Thanks for the bug report,

					- Ted
