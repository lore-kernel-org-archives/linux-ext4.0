From: Theodore Tso <tytso@mit.edu>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Wed, 13 Aug 2008 18:01:00 -0400
Message-ID: <20080813220100.GE6142@mit.edu>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de> <200808132255.10194.mail@eworm.de> <20080813210408.GC6142@mit.edu> <200808132307.07437.mail@eworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Hesse <mail@eworm.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47325 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752105AbYHMWBD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 18:01:03 -0400
Content-Disposition: inline
In-Reply-To: <200808132307.07437.mail@eworm.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 11:07:06PM +0200, Christian Hesse wrote:
> 
> Please look at the bottom of my last two mails... That was with your patch 
> applied.

Sorry, I missed it.  The new BUG seems to be a bug in the delayed
allocation code, specifically here, in fs/ext4/inode.c:ext4_da_release_space():

	   /* figure out how many metablocks to release */
	   BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
	   mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;

I've quickly looked at the code, and how i_reserved_meta_blocks gets
updated, and nothing *obviously* wrong is jumping out at me.  Anyone
else have time to investigate this a bit more deeply?

     	       	  	      	     	 - Ted

