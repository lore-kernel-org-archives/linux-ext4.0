From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix oops when online resizing a filesystem with
	flex_bg
Date: Mon, 26 Jan 2009 19:22:48 -0500
Message-ID: <20090127002248.GA11843@mit.edu>
References: <1232743309-3929-1-git-send-email-cascardo@holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33933 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZA0CG6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jan 2009 21:06:58 -0500
Content-Disposition: inline
In-Reply-To: <1232743309-3929-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm going to include this patch as well, but with a slightly different
changelog description, since I think making sure the group descriptor
is initialized addresses the root cause of the problem.  This still
saves a small amount of code space, so it's still a good patch, but it
shouldn't be strictly speaking necessary.

							- Ted

commit 030d677ef688dea36245bdeaab74826aece02ee8
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jan 26 19:20:18 2009 -0500

    ext4: remove call to ext4_group_desc() in ext4_group_used_meta_blocks()
    
    The static function ext4_group_used_meta_blocks() only has one caller,
    who already has access to the block group's group descriptor.  So it's
    better to have ext4_init_block_bitmap() pass the group descriptor to
    ext4_group_used_meta_blocks(), so it doesn't need to call
    ext4_group_desc().  Previously this function did not check if
    ext4_group_desc() returned NULL due to an error, potentially causing a
    kernel OOPS report.  This avoids the issue entirely.
    
    Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
