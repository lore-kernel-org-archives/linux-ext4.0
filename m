From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] e2fsprogs: New bitmap and inode table allocation for
 FLEX_BG
Date: Mon, 11 Feb 2008 09:05:44 -0600
Message-ID: <20080211090544.22c749ac@gara>
References: <20080207110905.7886d170@gara>
	<20080208051116.GB3120@webber.adilger.int>
	<20080208113740.11760ee2@gara>
	<20080211043351.GD26205@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53721 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbYBKPFu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2008 10:05:50 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1BF5ksm006354
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 10:05:46 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1BF5khm211090
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 10:05:46 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1BF5kWo009676
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 10:05:46 -0500
In-Reply-To: <20080211043351.GD26205@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 10 Feb 2008 23:33:51 -0500
Theodore Tso <tytso@MIT.EDU> wrote:

> On Fri, Feb 08, 2008 at 11:37:40AM -0600, Jose R. Santos wrote:
> > > >  #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
> > > >  #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
> > > > +#define EXT2_BG_FLEX_METADATA	0x0004 /* FLEX_BG block group contains meta-data */
> > > 
> > > Hrm, I thought I had reserved that value in the uninit_groups patch?
> > > +#define EXT3_BG_INODE_ZEROED   0x0004  /* On-disk itable initialized to zero */
> > 
> > I may have been, I just based the patch on the next branch as Ted had
> > ask for new e2fsprog patches.  The uninit group patch was not part of
> > the next branch when I pulled.
> 
> Yes, but whenever you start reserving code points that impact the
> on-disk format, you need to be careful and coordinate.  Exactly is the
> purpose of this flag, and why is it here?

Will fix.

> And I don't see any patch in the kernel patch queue that uses this
> flag.  Is this intended for internal use inside e2fsprogs?  If so,
> this might not be the best place for it.....
> 
>      	       	      	   	     - Ted

Currently, this is only used in e2fsprogs to determine which groups to
avoid when setting the EXT2_BG_BLOCK_UNINIT.  It will be use on
ext4_init_block_bitmap() to return the right number of free block when
a block group does not have any meta-data in it.  Eventually, it would
be nice to accurately and efficiently calculate the number of meta data
block used for a flexbg and be able to have these block groups
uninitialized as well.  This flag will be use to determine which groups
need to have their meta data block usage calculated.

-JRS
