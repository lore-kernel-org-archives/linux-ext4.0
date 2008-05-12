From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC PATCH 8/9][e2fsprogs] Add 64-bit closefs interface.
Date: Mon, 12 May 2008 12:24:43 -0500
Message-ID: <20080512122443.7ef72b19@gara>
References: <20080509163928.15484.22146.stgit@gara>
	<20080509164018.15484.53983.stgit@gara>
	<20080512150550.GF7029@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38635 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbYELRXs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 13:23:48 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4CHNlbA019690
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 13:23:48 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4CHNjls124194
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 13:23:45 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4CHNjWC022709
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 13:23:45 -0400
In-Reply-To: <20080512150550.GF7029@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 12 May 2008 11:05:50 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Fri, May 09, 2008 at 11:40:19AM -0500, Jose R. Santos wrote:
> > From: Jose R. Santos <jrs@us.ibm.com>
> > 
> > Add 64-bit closefs interface.
> > 
> > Add new ext2fs_super_and_bgd_loc2() that returns blk64_t pointers.
> > The function now returns the number of blocks used by super block and
> > group descriptors since with flex_bg, it can no longer be assumed that
> > bitmaps and inode tables still resided within the block group.
> 
> This change makes me nervous, because (a) I need to assure myself that
> ext2fs_super_and_bgd_loc() is going to always do the right thing, and
> (b) the changes to the callers of ext2fs_super_and_bgd_loc2() aren't
> also described.

I thought that we concluded that ext2fs_super_and_bgd_loc() would not
do the right thing which is the reason that ext2fs_super_and_bgd_loc2()
returns just the number of groups used by super block and group
descriptors.  Right now, ext2fs_super_and_bgd_loc() works the same as
it has before, and the new ext2fs_super_and_bgd_loc2() would do the
right thing here by not assuming inode tables and bitmaps are located
in the block group.

> So this requires more thought.  One change I would make is to return
> the number of blocks via a pointer rather than through a straight
> return value.  And also, if I recall correctly, nothing is actually
> using the ret_meta_bg pointer, so we might be able to drop that in the
> _2 version. of the interface.

I will make these two changes.

> We should probably include in this patch series the callers of
> ext2fs_super_and_bgd_loc() and assure ourselves that the new interface
> actually works correctly and is clean for the users before we finalize
> the interface change.

Fair enough.  I'll add a patch for this.
 
> 						- Ted


-JRS
