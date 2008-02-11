From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs: New bitmap and inode table allocation for
	FLEX_BG
Date: Sun, 10 Feb 2008 23:33:51 -0500
Message-ID: <20080211043351.GD26205@mit.edu>
References: <20080207110905.7886d170@gara> <20080208051116.GB3120@webber.adilger.int> <20080208113740.11760ee2@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63476 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862AbYBKEdy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2008 23:33:54 -0500
Content-Disposition: inline
In-Reply-To: <20080208113740.11760ee2@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 08, 2008 at 11:37:40AM -0600, Jose R. Santos wrote:
> > >  #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
> > >  #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
> > > +#define EXT2_BG_FLEX_METADATA	0x0004 /* FLEX_BG block group contains meta-data */
> > 
> > Hrm, I thought I had reserved that value in the uninit_groups patch?
> > +#define EXT3_BG_INODE_ZEROED   0x0004  /* On-disk itable initialized to zero */
> 
> I may have been, I just based the patch on the next branch as Ted had
> ask for new e2fsprog patches.  The uninit group patch was not part of
> the next branch when I pulled.

Yes, but whenever you start reserving code points that impact the
on-disk format, you need to be careful and coordinate.  Exactly is the
purpose of this flag, and why is it here?

And I don't see any patch in the kernel patch queue that uses this
flag.  Is this intended for internal use inside e2fsprogs?  If so,
this might not be the best place for it.....

     	       	      	   	     - Ted
