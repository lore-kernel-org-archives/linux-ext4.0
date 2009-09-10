From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH] Make non-journal fsync work properly.
Date: Thu, 10 Sep 2009 08:33:06 -0700
Message-ID: <1252596786.2130.6.camel@bobble.smo.corp.google.com>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
	 <20090910065747.GC8690@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:8310 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbZIJPdM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 11:33:12 -0400
In-Reply-To: <20090910065747.GC8690@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-09-10 at 12:27 +0530, Aneesh Kumar K.V wrote:
> On Fri, Sep 04, 2009 at 07:55:00PM -0700, Frank Mayhar wrote:
> > Teach ext4_write_inode() and ext4_do_update_inode() about non-journal
> > mode:  If we're not using a journal, ext4_write_inode() now calls
> > ext4_do_update_inode() (after getting the iloc via ext4_get_inode_loc())
> > with a new "do_sync" parameter.  If that parameter is nonzero
> > ext4_do_update_inode() calls sync_dirty_buffer() instead of
> > ext4_handle_dirty_metadata().
> > 
> > This problem was found in power-fail testing, checking the amount of
> > loss of files and blocks after a power failure when using fsync() and
> > when not using fsync().  It turned out that using fsync() was actually
> > worse than not doing so, possibly because it increased the likelihood
> > that the inodes would remain unflushed and would therefore be lost at
> > the power failure.
> > 
> 
> I think this is related to the other thread discussing the extent leak
> with non journal mode. I don't find ext4 without journal adding meta
> data blocks to the inode's address space mapping private_list. That 
> would mean sync_mapping_buffers -> fsync_buffers_list won't sync 
> the related metadata blocks.Tell me what i am missing 

I've been following the other thread as well.  I think I'm beginning to
get a handle on just how the buffer_heads and ext4 inodes work but I
still have some learning to do.  That having been said, however, it's
clear that this change does make things work much, much better, as seen
by the improvement in our power-fail tests.  One way or another, the
inodes are getting flushed.  After reading the other thread, I'm
beginning to suspect that it's more as a side effect of the current
tangle rather than because of it.  I'll have to look further to
understand just why it's working, though.

In any event, I think this change does the right thing or is at least a
step in the right direction.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

