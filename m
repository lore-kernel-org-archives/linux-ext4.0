From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Fix EXT4_FEATURE_RO_COMPAT_HUGE_FILE check
Date: Mon, 22 Nov 2010 17:34:45 -0500
Message-ID: <20101122223445.GB2767@thunk.org>
References: <4c7325f6.02558f0a.5a24.ffffc694@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52361 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab0KWPS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 10:18:58 -0500
Content-Disposition: inline
In-Reply-To: <4c7325f6.02558f0a.5a24.ffffc694@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 24, 2010 at 01:34:16AM +0000, Justin Maggard wrote:
> Creating a 4TB file on a filesystem with the 64bit flag set results
> in e2fsck consistently complaining about i_blocks being wrong, with
> confusing messages like this:
> 
> Inode 29818882, i_blocks is 8388608816, should be 8388608816.  Fix? no
> 
> That appears to be caused by ext2fs_inode_i_blocks() checking for
> the EXT4_FEATURE_RO_COMPAT_HUGE_FILE in the wrong place.  Fix it.
> 
> Signed-off-by: Justin Maggard <jmaggard10@gmail.com>

Applied to the e2fsprogs master branch.  Sorry for the delay in
attending to this patch.  This Fall has been incredibly busy for me;
now that I have the maint branch tidied up for the 1.41.12 release,
I'm not catching up with the backlog on the master branch.

    		    	     	     	- Ted
