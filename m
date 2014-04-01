From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fsck.ext4: Memory Allocation Failed
Date: Mon, 31 Mar 2014 22:22:31 -0400
Message-ID: <20140401022231.GC4911@thunk.org>
References: <CAKZK7uwTp2cMoWLiWZSa5UfZ2dCxRaB7KLZ0PtVVSqimp=tLJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Justin Brown <justin.brown@fandingo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48063 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaDACWe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2014 22:22:34 -0400
Content-Disposition: inline
In-Reply-To: <CAKZK7uwTp2cMoWLiWZSa5UfZ2dCxRaB7KLZ0PtVVSqimp=tLJA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 31, 2014 at 03:49:29PM -0500, Justin Brown wrote:
> Pass 1: Checking inodes, blocks, and sizes
> Inode 14109880 has illegal block(s).  Clear? yes
> 
> Illegal block #0 (3925875673) in inode 14109880.  CLEARED.
> Illegal block #2 (85326080) in inode 14109880.  CLEARED.
> Illegal block #3 (2516589529) in inode 14109880.  CLEARED.
> Illegal block #5 (3641317099) in inode 14109880.  CLEARED.
> Illegal block #6 (394723355) in inode 14109880.  CLEARED.
> Illegal block #7 (2986344453) in inode 14109880.  CLEARED.
> Illegal block #8 (3640903191) in inode 14109880.  CLEARED.
> Illegal block #9 (463536155) in inode 14109880.  CLEARED.
> Illegal block #11 (1275199487) in inode 14109880.  CLEARED.
> Illegal double indirect block (2181366192) in inode 14109880.  CLEARED.
> Illegal block #563086348 (4294967295) in inode 14109880.  CLEARED.
> Error storing directory block information (inode=14109880, block=0,
> num=471166008): Memory allocation failed

Sorry, this is a bug in e2fsck; we should handle this kind of
corrupted inode better.

The quick workaround is this:

debugfs -w -R "clri <14109880>" /dev/vg/root 

This will zap the contents of the offending inode, since it's been
overwritten with garbage; unfortunately, it was garbage which was
causing e2fsck to try to allocate too much memory, and then fail.

	       	      	 	      - Ted
