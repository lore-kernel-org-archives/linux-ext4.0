From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: Inode flags diet
Date: Tue, 29 Nov 2016 11:25:07 -0500
Message-ID: <20161129162507.tp4zwqpqetmt7yxp@thunk.org>
References: <1475751874-32114-1-git-send-email-jack@suse.cz>
 <1475751874-32114-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56664 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbcK2QZK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Nov 2016 11:25:10 -0500
Content-Disposition: inline
In-Reply-To: <1475751874-32114-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 06, 2016 at 01:04:34PM +0200, Jan Kara wrote:
> Remove 6 inode flags that were apparently never used and only take up
> space in inode flags field which is already full.
> 
> There are also other inode flags of doubtful use (not used by current
> Linux kernel - IMAGIC, NOTAIL, EA_INODE) but let's leave them there for
> now since I'm not quite sure about their status.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

The secure delete flag was honored by ext2, although not by ext3 or ext4

As for the rest --- you've picked up on my secret plan --- which was
to keep them around to make sure people didn't try to allocate any
flags without thinking *really* hard about it.  :-)

      	      	       		     	   	- Ted
