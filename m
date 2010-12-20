From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/15] mke2fs: simplify inode table block counting
Date: Mon, 20 Dec 2010 10:44:58 -0500
Message-ID: <20101220154458.GJ23626@thunk.org>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
 <1291020917-8671-4-git-send-email-namhyung@gmail.com>
 <alpine.LFD.2.00.1011301250470.3004@dhcp-lab-213.englab.brq.redhat.com>
 <1291204145.1684.10.camel@leonhard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33462 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab0LTPpC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Dec 2010 10:45:02 -0500
Content-Disposition: inline
In-Reply-To: <1291204145.1684.10.camel@leonhard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 01, 2010 at 08:49:05PM +0900, Namhyung Kim wrote:
> 
> We have ext2fs_div[64]_ceil() for that. So I can use it like
> 
> ipb = fs->blocksize / EXT2_INODE_SIZE(fs->super);
> num = ext2_fs_div_ceil(fs->super->s_inodes_per_group -
> 			ext2fs_bg_itable_unused(fs, i), ipb);
> 
> or
> 
> num = ext2_fs_div_ceil((fs->super->s_inodes_per_group -
> 			ext2fs_bg_itable_unused(fs, i)) *
> 		       EXT2_INODE_SIZE(fs->super),
> 		       EXT2_BLOCK_SIZE(fs->super));
> 
> Either is fine to me. Ted, what's your preference?

I've checked in the second since it's closer to the original code.

     	     	    	   	      - Ted
