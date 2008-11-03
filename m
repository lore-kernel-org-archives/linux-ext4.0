From: Theodore Tso <tytso@mit.edu>
Subject: Re: 64-bit dblists
Date: Sun, 2 Nov 2008 22:09:36 -0500
Message-ID: <20081103030936.GB29102@mit.edu>
References: <20081027205910.GD20992@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52778 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754240AbYKCDJj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 22:09:39 -0500
Content-Disposition: inline
In-Reply-To: <20081027205910.GD20992@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 27, 2008 at 04:59:10PM -0400, Valerie Aurora Henson wrote:
> Hi all,
> 
> In my continuing quest to finish the 64-bit conversion of e2fsprogs, I
> ran into this structure exported in ext2fs.h:
> 
> struct ext2_db_entry {
>         ext2_ino_t      ino;
>         blk_t   blk;
>         int     blockcnt;
> };
> 
> The "blk_t" is the problem here - we need a blk64_t.  A pointer to
> this structure is passed to the user-provided directory block iterator
> in ext2fs_dblist_iterate().
> 
> Assuming the goal is to preserve the ext2fs_dblist ABI, I can see two
> ways of doing this:
> 
> 1. Define ext2_db_entry2, ext2_dblist2, and ext2fs_dblist_*2() and do
> the usual translation/conversion function business.

The dblist.c and dblist_dir.c functions are so small that it's
probably not worth it to do translaction/conversation functions; it's
basically just a linked list convenience function implementation.

My suggestion is to just create a dblist2.c and dblist_dir2.c, and
just make a 64-bit version of the directory block list abstraction.
My guess that size of the conversaion functions would be bigger than a
new 64-bit version of the abstraction.  (The object size of dblist.o
and dblist_dir.o combined is only about 1.5k)

    		 	     	  	- Ted
