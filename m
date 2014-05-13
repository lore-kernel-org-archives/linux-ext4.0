From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] ext4: don't crash when validating block bitmap
Date: Tue, 13 May 2014 15:33:47 -0700
Message-ID: <20140513223347.GA17417@birch.djwong.org>
References: <20140501231720.892.58712.stgit@birch.djwong.org>
 <20140501231747.892.95073.stgit@birch.djwong.org>
 <20140512142457.GG31376@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46997 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaEMWdw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 May 2014 18:33:52 -0400
Content-Disposition: inline
In-Reply-To: <20140512142457.GG31376@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2014 at 10:24:57AM -0400, Theodore Ts'o wrote:
> On Thu, May 01, 2014 at 04:17:47PM -0700, Darrick J. Wong wrote:
> > If EXT4FS_DEBUG is defined, ext4_validate_block_bitmap is called via
> > ext4_count_free_clusters before sb->s_group_info is set up.  When this
> > happens, the kernel crashes because group info hasn't been loaded.
> > Forego marking the group corrupt for now; not setting BH_Verified
> > means we'll revisit the bitmap if something went wrong.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This shouldn't be necessary that we have this in the ext4 tree, right?

Err... right, you can drop this patch of mine.

--D

> 
> commit 007649375f6af242d5b1df2c15996949714303ba
> Author: Azat Khuzhin <a3at.mail@gmail.com>
> Date:   Mon Apr 7 10:54:20 2014 -0400
> 
>     ext4: initialize multi-block allocator before checking block descriptors
>     
>     With EXT4FS_DEBUG ext4_count_free_clusters() will call
>     ext4_read_block_bitmap() without s_group_info initialized, so we need to
>     initialize multi-block allocator before.
>     
>     ...
> 
> 						- Ted
