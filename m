From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Sun, 6 Sep 2009 12:30:40 -0400
Message-ID: <20090906163040.GJ3055@mit.edu>
References: <4A9D9574.3010606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59742 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbZIFQak (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Sep 2009 12:30:40 -0400
Content-Disposition: inline
In-Reply-To: <4A9D9574.3010606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 01, 2009 at 04:43:16PM -0500, Eric Sandeen wrote:
> ext2fs_open2() was only looking at s_blocks_count, and
> when it wrapped to a low number, it was failing the test of:
> 
>   fs->super->s_first_data_block >= fs->super->s_blocks_count
> 
> which made the superblock look corrupt.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Added to the e2fsprogs 64-bit patch set / pu branch.

      	     	       	      	    	- Ted
