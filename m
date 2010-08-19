From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Memory allocation failed, e2fsck: aborted
Date: Wed, 18 Aug 2010 20:54:04 -0400
Message-ID: <20100819005404.GO21182@thunk.org>
References: <20100818140422.GL27457@skl-net.de>
 <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andre Noll <maan@systemlinux.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48868 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0HSAyI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Aug 2010 20:54:08 -0400
Content-Disposition: inline
In-Reply-To: <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 18, 2010 at 02:20:13PM -0600, Andreas Dilger wrote:
> 
> Ah, that is also a major user of memory, and not necessarily one
> that optimizing the internal bitmap will help significantly.  It may
> well be that your swap cannot be used if a single allocation is in
> the same neighbourhood as the total RAM size.

Something which *might* help (but will take a long time) is to add to
your /etc/e2fsck.conf (if you have one; if not create one wiht these
contents):

[scratch_files]
    directory = /var/cache/fsck

(And then make sure /var/cache/fsck exists.)

Unfortunately, as it turns out tdb (from Samba) doesn't scale as much
as I would have liked, so it's on my todo to replace this with
something else.  The problem with that berk_db has non-standard
interfaces and varies from version to version.  So I've avoided using
it up until now.

But try it, and see if this will help....  it may still be way too
slow.

A related blog entry:

http://thunk.org/tytso/blog/2009/01/12/wanted-incremental-backup-solutions-that-use-a-database/

					- Ted

P.S.  I recently was told about a new backup system that meets the
requirements detailed in my post:

    http://sites.google.com/site/hashbackup/home/features

I haven't tried it yet, but it looks interesting.  Let me know if you
do try it and what you think of it.
