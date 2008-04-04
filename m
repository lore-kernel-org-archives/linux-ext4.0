From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH][e2fsprogs] New bitmap and inode table allocation for
 FLEX_BG
Date: Fri, 4 Apr 2008 00:37:57 -0500
Message-ID: <20080404003757.0894cce1@gara.konoha.net>
References: <20080401031311.10442.12267.stgit@gara.konoha.net>
	<20080403131240.GA13486@mit.edu>
	<20080403092858.5e3a7bb2@gara.konoha.net>
	<20080404032443.GA362@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42440 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbYDDFiL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Apr 2008 01:38:11 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m345c95E023350
	for <linux-ext4@vger.kernel.org>; Fri, 4 Apr 2008 01:38:09 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m345c9SZ1080424
	for <linux-ext4@vger.kernel.org>; Fri, 4 Apr 2008 01:38:09 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m345c9pB022350
	for <linux-ext4@vger.kernel.org>; Fri, 4 Apr 2008 01:38:09 -0400
In-Reply-To: <20080404032443.GA362@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 3 Apr 2008 23:24:43 -0400
Theodore Tso <tytso@MIT.EDU> wrote:

> On Thu, Apr 03, 2008 at 09:28:58AM -0500, Jose R. Santos wrote:
> > I blame Undo Manager for being so slow that cause me to skip some of
> > the testing needed to be done.  
> 
> If that means we need a patch to disable the undo manager, via a
> command-line option, feel free.  :-)

Im sufficiently annoyed that I may just do that.
 
> > I was incorrectly checking the feature
> > flag instead of checking the value of fs->super->s_log_groups_per_flex.
> 
> Actually, you should check both, and we need to make mke2fs have an
> intelligent default, which can be overridden via mke2fs.conf.

Yes it should check both(will fix).  I was expecting more people to
give flexbg a test before trying to determined an intelligent default
though.

> Also, it looks like this patch doesn't create a valid filesystem in
> combination with meta_bg:
> 
> mke2fs G 32 -O meta_bg,flex_bg,uninit_groups,^resize_inode /tmp/foo.img
> 
> Then try running "e2fsck -f /tmp/foo.img" with the patch applied.

Wow, it really breaks.  Throws e2fsck into an infinite loop.

> One obvious question is why is this patch so fragile....?  Is there
> some way we can make it more likely not to break given other changes
> to e2fsprogs in the future.

Getting the right free block count for every group descriptor seems to
be the tricky part since libe2fs make all sort of assumptions about
number of used blocks that break when meta-data is no longer on the
same block group.  Seems like I forgot a check for the adjusted flexbg
block group size in meta_bg since the first place it barfs is in group
127 which is the last group of the meta_bg with a group descriptor
block being used.  This should be easy to find and fix.

> 						- Ted

-JRS
