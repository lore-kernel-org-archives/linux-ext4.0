From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] ext4: don't crash when validating block bitmap
Date: Mon, 12 May 2014 10:24:57 -0400
Message-ID: <20140512142457.GG31376@thunk.org>
References: <20140501231720.892.58712.stgit@birch.djwong.org>
 <20140501231747.892.95073.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34678 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaELOY7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 10:24:59 -0400
Content-Disposition: inline
In-Reply-To: <20140501231747.892.95073.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2014 at 04:17:47PM -0700, Darrick J. Wong wrote:
> If EXT4FS_DEBUG is defined, ext4_validate_block_bitmap is called via
> ext4_count_free_clusters before sb->s_group_info is set up.  When this
> happens, the kernel crashes because group info hasn't been loaded.
> Forego marking the group corrupt for now; not setting BH_Verified
> means we'll revisit the bitmap if something went wrong.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This shouldn't be necessary that we have this in the ext4 tree, right?

commit 007649375f6af242d5b1df2c15996949714303ba
Author: Azat Khuzhin <a3at.mail@gmail.com>
Date:   Mon Apr 7 10:54:20 2014 -0400

    ext4: initialize multi-block allocator before checking block descriptors
    
    With EXT4FS_DEBUG ext4_count_free_clusters() will call
    ext4_read_block_bitmap() without s_group_info initialized, so we need to
    initialize multi-block allocator before.
    
    ...

						- Ted
