From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH][e2fsprogs] Move ext2fs_struct_generic_bitmap back into ext2fs.h
Date: Sun, 12 Aug 2007 12:57:15 -0400
Message-ID: <1186937841369-git-send-email-tytso@mit.edu>
References: <20070809214254.GB5438@thunk.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: jrs@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46657 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbXHLQ6g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2007 12:58:36 -0400
In-Reply-To: <20070809214254.GB5438@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>It turns out the need for this was only in the very first ports of
>Linux to the Powerpc, and there haven't been kernels that would mount
>big-endian superblocks since, oh, 1998 or so (in the 2.0 days).
>
>So probably the better fix is one where we don't allow big-endian
>filesystems any more.  On all modern systems, we use little-endian
>encoding of the superblock, and the bitmaps don't need byte-swapping.

Here's the set of patches to remove the support for the powerpc
big-endian filesystem variant.

						- Ted
