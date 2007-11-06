From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] allow tune2fs to set/clear resize_inode
Date: Tue, 6 Nov 2007 13:51:51 -0500
Message-ID: <20071106185151.GA12857@thunk.org>
References: <472F80F5.3030608@redhat.com> <20071106011255.GB3900@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58754 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbXKFTV7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2007 14:21:59 -0500
Content-Disposition: inline
In-Reply-To: <20071106011255.GB3900@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 06, 2007 at 09:12:55AM +0800, Andreas Dilger wrote:
> I don't know that it is so easy to enable RESIZE_INODE on an existing
> filesystem as just setting the feature flag and running e2fsck?  The
> reserved group descriptor blocks will potentially conflict with the
> bitmaps and inode tables.

Yes, it isn't so easy, and yup, it will potentially conflict with the
bitmap and inode tables --- and this is something which e2fsck does
*not* handle well.  

> What is needed is an ext2prepare-like step that involves resize2fs code
> to move the file/dir blocks and then the move inode table, as if the
> filesystem were going to be resized to the new maximum resize limit,
> and then create the resize inode but do not actually add new blocks/groups
> at the end of the filesystem.

Yeah, the plan was to eventually add ext2prepare-like code into
tune2fs, using the undo I/O manager for safety.  But that's been
relatively low priority.

BTW, I've gotten ~2 bug reports from Debian users claiming that
ext2prepare had trashed their filesystem.  I don't have any clean
evidence about whether it was a userspace error or some kind of bug in
ext2prepare, possibly conflicting with some new ext3 feature that
we've since added that ext2prepare doesn't properly account for
(extended attributes, maybe?).  

I have not had time to look into it, but thought has crossed my mind
that a quick hack would be to splice the undo manager into
ext2prepare, have it run e2fsck, and if it fails, do a rollback,
create an e2image file, and then instruct the user to send in a bug
report.  :-)

							- Ted
