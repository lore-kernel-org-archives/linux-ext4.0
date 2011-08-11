From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Question about BIGALLOC
Date: Wed, 10 Aug 2011 22:59:44 -0400
Message-ID: <20110811025944.GE3625@thunk.org>
References: <CAFZ0FUUH85yWoVZ3XpMMYjhiaDrV9QQRSrLsAomXhH8uG_duBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42188 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab1HKC7q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 22:59:46 -0400
Content-Disposition: inline
In-Reply-To: <CAFZ0FUUH85yWoVZ3XpMMYjhiaDrV9QQRSrLsAomXhH8uG_duBg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 05, 2011 at 03:59:01PM +0800, Robin Dong wrote:
> Hi, Ted
> 
> I am doing some test of BIGALLOC using "next" branch of e2fsprogs and
> kernel (3.0) with 23 bigalloc-patches.
> 
> Everything seems to work, but I have a question:
> the "ee_len" of "struct ext4_extent" is used to indicate block numbers
> not cluster,
> an ext4_extent in 4K-block-size filesystem can only hold 128MB space at most
> even with BIGALLOC feature enabled, so we don't have any benefit from
> this for a file with large number of blocks.
> 
> Is this the design behavior or you will change it in the next version?

It's not something I can change, because the VM subsystem
fundamentally assumes that file system block size is less than or
equal to the page size.  If I changed the granularity in the extent
length, then in the case of a sparse file, blocks would have to be
allocated and zero'ed in units of a cluster.  The VM doesn't support
this well.

For example, suppose you fallocate a file to be 1 megabyte.  That
means that you have a 1mb extent which is marked as uninitialized.
Now suppose you mmap() this file, and then you write a single byte at
offset 20480.  This dirties a single 4k page, and when we write out
that page, we end up converting the 1mb extent uninitialized extent
into 3 extents: a 20k uninitalized extent, a 4k initialized extent,
and a 1000k uninitalized extent.  Now suppose this was done on a
bigalloc file system with a 64k cluster size.  If ee_len was
denominated in 64k cluster chunks, we couldn't express the concept of
a 20k or 4k extent.

This is the same reason why we can't support a 64k file system block
size.  If the user dirties a single 4k block in an otherwise sparse
file, the VM would have to instantiate the other 56k pages and zero
them (atomically!) --- and the VM doesn't know how to do this.

     		       	       	  	  - Ted
