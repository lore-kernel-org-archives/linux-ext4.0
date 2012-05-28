From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: Fix rbtree backend for extent lengths
 greater than 2^32
Date: Sun, 27 May 2012 22:14:47 -0400
Message-ID: <20120528021447.GE19152@thunk.org>
References: <4FBFE0F9.8050509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45845 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab2E1COt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 May 2012 22:14:49 -0400
Content-Disposition: inline
In-Reply-To: <4FBFE0F9.8050509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 25, 2012 at 02:43:53PM -0500, Eric Sandeen wrote:
> Well, this took way too long to find, in retrospect.
> 
> In short, for a completely full filesystem with more than 2^32
> blocks, the rbtree bitmap backend can assemble an extent of used
> blocks which is longer than 2^32.  If it does, it will overflow
> ->count, and corrupt the rbtree for the bitmaps.
> 
> Discovered by completely filling a 32T filesystem using fallocate, and
> then observing debugfs, dumpe2fs, and e2fsck all behaving badly.
> 
> (Note that filling with only 31 x 1T files did not show the problem,
> because freespace was fragmented enough that there was no sufficiently
> long range of used blocks.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
