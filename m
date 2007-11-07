From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] allow tune2fs to set/clear resize_inode
Date: Wed, 7 Nov 2007 13:30:48 -0700
Message-ID: <20071107203048.GF3966@webber.adilger.int>
References: <472F80F5.3030608@redhat.com> <20071106011255.GB3900@webber.adilger.int> <20071106185151.GA12857@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:57518 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089AbXKGUav (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Nov 2007 15:30:51 -0500
Content-Disposition: inline
In-Reply-To: <20071106185151.GA12857@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 06, 2007  13:51 -0500, Theodore Tso wrote:
> On Tue, Nov 06, 2007 at 09:12:55AM +0800, Andreas Dilger wrote:
> > What is needed is an ext2prepare-like step that involves resize2fs code
> > to move the file/dir blocks and then the move inode table, as if the
> > filesystem were going to be resized to the new maximum resize limit,
> > and then create the resize inode but do not actually add new blocks/groups
> > at the end of the filesystem.
> 
> Yeah, the plan was to eventually add ext2prepare-like code into
> tune2fs, using the undo I/O manager for safety.  But that's been
> relatively low priority.
> 
> BTW, I've gotten ~2 bug reports from Debian users claiming that
> ext2prepare had trashed their filesystem.  I don't have any clean
> evidence about whether it was a userspace error or some kind of bug in
> ext2prepare, possibly conflicting with some new ext3 feature that
> we've since added that ext2prepare doesn't properly account for
> (extended attributes, maybe?).  
> 
> I have not had time to look into it, but thought has crossed my mind
> that a quick hack would be to splice the undo manager into
> ext2prepare, have it run e2fsck, and if it fails, do a rollback,
> create an e2image file, and then instruct the user to send in a bug
> report.  :-)

I don't think it would be very easy to splice undo manager into ext2prepare.
I'd rather see time spent to make resize2fs handle the prepare functionality
and then ext2resize can be entirely obsoleted.

Aneesh, adding undo manager to resize2fs would be an excellent use of that
library, and going from resize2fs to "resize2fs --prepare-only" (or whatever)
would be trivial I think.  Is that something you'd be interested to work on?

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
