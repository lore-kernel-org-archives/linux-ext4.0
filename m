From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Consolidated file encryption interface/semantics?
Date: Tue, 12 Jan 2016 00:30:49 -0500
Message-ID: <20160112053049.GA4466@thunk.org>
References: <56943319.9080802@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41356 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbcALFaz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2016 00:30:55 -0500
Content-Disposition: inline
In-Reply-To: <56943319.9080802@nod.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 11, 2016 at 11:56:25PM +0100, Richard Weinberger wrote:
> 
> So, the data structures are identical and AFAIK also the supported cipher modes are.
> But as both use their own ioctls having a single tool to control file encryption
> can be error prone in future.
> Interestingly the current ioctls for ext4 and f2fs resolve to the same integers,
> is this on purpose? :)

As far as tools to control file encryption, there is the beginnings of
such a tool in the e2fsprogs directory, called e4crypt[1], which I've
been using to do some of my testing.  There is also a dummy encryption
key mount option for stress testing using xfstests.

[1] http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/tree/misc/e4crypt.c

There is also code in the Android Open Source Project which uses these
ioctls although the way the user key management is handled is a bit
different.  (In particular, they don't use the per-file system salt,
but instead use a different mechanism to derive the key from stored
secret information --- which could potentially use ARM Trustzone for
those devices that have it --- and the user's pin / password.)

Since the primary / initial user for this code has been in the Android
Userspace, the e4crypt tool hasn't gotten as much attention as I would
like.  One of the thigns on my "to-implement" list is storing the
per-file system password salts which it knows about in a dot file so
that if you are using multiple USB thumb drives, when you enter the
password once, the password can be transformed into different keys for
the different USB thumb drives, even if some of them aren't currently
available to the system because they currently aren't plugged in and
available to the system.

> Another thing are semantics, ext4 implemented a policy which controls
> under which conditions encrypted files are allowed to be unlinked, moved, etc...
> f2fs adopted these from ext4. But can't we do that in VFS or at least
> agree one a policy and document it? :-)

It's been on my todo list to uplift the common code into a VFS
library, and so it wasn't my intent to make it be someone else's
problems.  I just haven't had time to get to that point yet, and I
also wanted to make sure we had adequate implementation and practice
experience before we uplifted the code, since it was faster to make
changes when all of the code is in a single layer.  Hopefully I will
have time to start work on this in the next month or two.

The final thing I'll note is that for *most* use cases, it makes for
more sense to do encryption at the block layer.  It's only if you need
per-user, or per-work profile keying, then maybe it makes sense to
have file system level encryption.  So you might want to consider
whether for your intended use case, whether or not it makes sense for
UBIFS to have encryption, or whether you would be better off doing it
below the file system, at the block or MTD layer.

Cheers,

					- Ted

P.S.  Also on the todo list is to update the following document from
"as designed" to "as built".  In particular there were some
late-breaking changes in how file naem and symlink encryption were
handled that didn't get reflected in the design doc:

https://docs.google.com/document/d/1ft26lUQyuSpiu6VleP70_npaWdRfXFoNnB8JYnykNTg/edit#

