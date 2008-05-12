From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC PATCH 4/9][e2fsprogs] Add 64-bit alloc_stats interface.
Date: Mon, 12 May 2008 12:25:36 -0500
Message-ID: <20080512122536.3625c5a0@gara>
References: <20080509163928.15484.22146.stgit@gara>
	<20080509163952.15484.56168.stgit@gara>
	<20080512144353.GC7029@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54969 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbYELRYj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 13:24:39 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4CHOcdn018624
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 13:24:38 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4CHOboj144144
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 13:24:38 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4CHOb2e026307
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 13:24:37 -0400
In-Reply-To: <20080512144353.GC7029@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 12 May 2008 10:43:53 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Fri, May 09, 2008 at 11:39:52AM -0500, Jose R. Santos wrote:
> > +	/*FIXME: Not blk64_t clean */
> 
> Suggestion, please use "FIXME-64" instead of fixme so it's easier to
> clean this up later.

Will do.
 
> >  	int	group = ext2fs_group_of_blk(fs, blk);

Ops...  I missed this one.

> Might as well fix this in the initial patch series, earlier --- and
> let's *not* make it be an inline function.  Yeah, we call
> ext2fs_group_of_blk and ext2fs_group_of_ino a fair amount, but #1, on
> 32-bit machines, the 64 bit arithmemtic makes the function bigger, and
> #2, modern CPU's have greatly reduced the cost of procedure
> activations.

Will fix it in the series.

> 						- Ted

-JRS
