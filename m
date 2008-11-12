From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: 64-bit dblists
Date: Wed, 12 Nov 2008 11:48:36 -0500
Message-ID: <20081112164836.GF29956@shell>
References: <20081027205910.GD20992@shell> <20081103030936.GB29102@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYKLQsj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Nov 2008 11:48:39 -0500
Content-Disposition: inline
In-Reply-To: <20081103030936.GB29102@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 02, 2008 at 10:09:36PM -0500, Theodore Tso wrote:
> On Mon, Oct 27, 2008 at 04:59:10PM -0400, Valerie Aurora Henson wrote:
> > Hi all,
> > 
> > In my continuing quest to finish the 64-bit conversion of e2fsprogs, I
> > ran into this structure exported in ext2fs.h:
> > 
> > struct ext2_db_entry {
> >         ext2_ino_t      ino;
> >         blk_t   blk;
> >         int     blockcnt;
> > };
> > 
> > The "blk_t" is the problem here - we need a blk64_t.  A pointer to
> > this structure is passed to the user-provided directory block iterator
> > in ext2fs_dblist_iterate().
> > 
> > Assuming the goal is to preserve the ext2fs_dblist ABI, I can see two
> > ways of doing this:
> > 
> > 1. Define ext2_db_entry2, ext2_dblist2, and ext2fs_dblist_*2() and do
> > the usual translation/conversion function business.
> 
> The dblist.c and dblist_dir.c functions are so small that it's
> probably not worth it to do translaction/conversation functions; it's
> basically just a linked list convenience function implementation.
> 
> My suggestion is to just create a dblist2.c and dblist_dir2.c, and
> just make a 64-bit version of the directory block list abstraction.
> My guess that size of the conversaion functions would be bigger than a
> new 64-bit version of the abstraction.  (The object size of dblist.o
> and dblist_dir.o combined is only about 1.5k)

Thanks!  This is what I'm doing currently.

-VAL
