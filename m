From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Thu, 18 Jul 2013 22:59:34 -0400
Message-ID: <20130719025934.GE17938@thunk.org>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <51E8356C.9030603@redhat.com>
 <20130718185310.GA17548@thunk.org>
 <51E88ECD.3040806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39126 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759578Ab3GSC7j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jul 2013 22:59:39 -0400
Content-Disposition: inline
In-Reply-To: <51E88ECD.3040806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 18, 2013 at 07:56:45PM -0500, Eric Sandeen wrote:
> > The problem is we don't know that we're doing AIO until we see the
> > first io_submit(2) call.  With this patch series, we'll pull the
> > contents of the entire leaf tree block into extent cache, but if the
> > extent tree is larger than that, if we read in the entire extent tree
> > on the first AIO request, then that first request will delayed even
> > more, and it's not clear that's a good thing.
> 
> Is blocking on a pre-AIO ioctl better than blocking on the
> first AIO?

The precache ioctl is something which the application is expecting to
block.  The question is, if we have a heavily fragmented extent tree,
is it better for the first AIO to block long enough to read in one
metadata block --- and then never block again, or to have that first
AIO request take a long, LONG time?  Especially if the application
isn't expecting it?

Also there are use cases for the precache ioctl even if you are not
using AIO.  If you've taken care to make sure the file is as
contiguous as possible, having the extents be cached will save a lot
of memory compared to if the buffer heads are always entering the
buffer cache.  So reading in all of the metadata can be a good thing
to do, especially if you can do this *before* you declare that the
server is healthy and is ready to start receiving traffic.

This becomes especially critical if the server is running in a very
tight memory container, because you are trying to pack as many jobs
(or VM's, if that's the way you roll) as possible on a physical
server.

Cheers,

						- Ted


