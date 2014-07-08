From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: first write to large ext3 filesystem takes 96 seconds
Date: Mon, 7 Jul 2014 20:16:55 -0400
Message-ID: <20140708001655.GI8254@thunk.org>
References: <20140707211349.GA12478@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50015 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbaGHAQ5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2014 20:16:57 -0400
Content-Disposition: inline
In-Reply-To: <20140707211349.GA12478@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 07, 2014 at 05:13:49PM -0400, Benjamin LaHaise wrote:s
> Hi folks,
> 
> I've just ran into a bug with the ext4 codebase in 3.4.91 that doesn't seem 
> to exist in ext3, and was wondering if anyone has encountered this before.  
> I have a 7.4TB ext3 filesystem that has been filled with 1.8TB of data.  
> When this filesystem is freshly mounted, the first write to the filesystem 
> takes a whopping 96 seconds to complete, during which time the system is 
> reading about 1000 blocks per second.  Subsequent writes are much quicker.  
> The problem seems to be that ext4 is loading all of the bitmaps on the 
> filesystem before the first write proceeds.  The backtrace looks roughly as 
> follows:

So the issue is that ext3 will just allocate the first free block it
can find, even if it is a single free block in block group #1001,
followed by a single free block in block group #2002.  Ext4 tries a
harder to find contiguous blocks.

If you are using an ext3 file system format, the block allocation
bitmaps are scattered across the entire file system, so we end up
doing a lot random 4k seeks.

We can try to be a bit smarter about how we try to search the file
system for free blocks.

Out of curiosity, can you send me a copy of the contents of:

/proc/fs/ext4/dm-XX/mb_groups

Thanks!!

					- Ted
