From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC,PATCH] 64-bit support for e2fsprogs
Date: Thu, 13 Nov 2008 15:30:57 -0500
Message-ID: <20081113203057.GD21652@mit.edu>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com> <20081112202538.GN16005@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Valerie Aurora Henson <vaurora@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38875 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbYKMUbA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 15:31:00 -0500
Content-Disposition: inline
In-Reply-To: <20081112202538.GN16005@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 12, 2008 at 01:25:38PM -0700, Andreas Dilger wrote:
> On Nov 11, 2008  19:42 -0800, Valerie Aurora Henson wrote:
> > Use the following mke2fs command to produce a file system with more
> > than 2^32 blocks:
> > 
> > $ mke2fs -t ext4 -O 64bit -b 4096 -N 200000 <device>
> 
> Ted, this actually exposes a bug in mke2fs, in that the device size to
> "type" detection code is broken.  Val was reporting that running on a
> 16TB device would pick the "floppy" type and try to use 1024-byte blocks
> and 1 inode per 1024 bytes, which would exceed the 2^32 inode limit.
> Hence the current requirement to specify a 4096-byte blocksize and a
> hard limit on the number of inodes.

16TB using a 4k block size is 2**32 blocks, so it's not surprising
it's screwing up and picking the floppy type.  I assume it's only
looking at fs_param->s_blocks_count and not fs_param->s_blocks_count_hi.

It also needs to cap the number of inodes in case of very large
filesystems to make sure we don't overflow 2**32 inodes, yes.

I'm not sure I would call this a bug in the existing mke2fs code, as
much as it is simply that the 64-bit support is not yet complete.  Or
am I missing something in what you complaining about?

						- Ted
