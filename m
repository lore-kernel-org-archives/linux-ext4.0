From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Journal under-reservation bug on first >2G file
Date: Wed, 1 Oct 2014 18:43:25 -0400
Message-ID: <20141001224325.GE2903@thunk.org>
References: <542B1C38.9010409@redhat.com>
 <542B1EFC.4050500@redhat.com>
 <C355A8E9-1799-43AB-9F57-4EFE1BBE3767@dilger.ca>
 <20141001115320.GA2903@thunk.org>
 <542C1314.3030603@redhat.com>
 <20141001195954.GD2903@thunk.org>
 <542C65FD.5040405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59798 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaJAWna (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 18:43:30 -0400
Content-Disposition: inline
In-Reply-To: <542C65FD.5040405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 01, 2014 at 03:37:17PM -0500, Eric Sandeen wrote:
> 
> Ok.  I guess this is only an issue for ext4 - well, at least this specific
> issue.  Delalloc makes it much different than ext2 & ext3, which reserve quite a
> lot more.  Whether there's a corner case over there which breaks, I dunno...
> 
> So it seems like the simplest test is simply: Are we RW mounted with delalloc?
> And if so, update the feature.  Seems simpler than mucking with "which features
> are unique to ext4"

I'd do "are we RW mounted with the extents feature".  That way we
don't need to worry about someone accidentally mounting a partition
meant for Hurd using ext4, which would imply delalloc, and then
causing Hurd to no longer be able to deal with the file system.  That
*shouldn't* happen, but if someone accidentally mounts the file system
with -t ext4, but it seems safer to gate it on the existence of the
extents feature.

						- Ted
