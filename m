From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Large directories and poor order correlation
Date: Mon, 14 Mar 2011 20:14:48 -0400
Message-ID: <20110315001448.GG8120@thunk.org>
References: <4D7E7990.90209@cfl.rr.com>
 <4D7E7C7F.1040509@redhat.com>
 <4D7E8005.4030201@cfl.rr.com>
 <20110314215249.GE8120@thunk.org>
 <4D7EA83D.20400@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38187 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab1COAOz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Mar 2011 20:14:55 -0400
Content-Disposition: inline
In-Reply-To: <4D7EA83D.20400@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 14, 2011 at 07:43:57PM -0400, Phillip Susi wrote:
> > what if a process opens a directory, starts calling readdir, pauses in
> > the middle, and then holds onto it for days, weeks, or months?
> 
> The same thing that happened before htree?

No, because the readdir() semantics are exactly set up to mirror a
linear directory tree.

> > It's not hard to provide library routines that do the right thing, and
> > I have written an LD_PRELOAD which intercepts opendir() and readdir()
> > calls and does the sorting in userspace.  Perhaps the right answer is
> > getting this into libc, but I have exactly two words for you: "Uhlrich
> > Drepper".
> 
> Wouldn't it be better to just have readdir() use the main directory,
> which presumably is in a more sane ordering, instead of the htree?  That
> way you don't have to burn cpu and ram sorting on every opendir().

The htree is embedded into directory blocks (they appear to ext2 and
older kernels as deleted directory entries).  The leaf blocks are in
the "main directory" as well; there is no separate htree.

The reason why we have to traverse the directory tree in htree order
is because the POSIX requirements of how readdir() works in the face
of file deletes and creations, and what needs to happen if a leaf
block needs to be split.  Even if the readdir() started three months
ago, if in the intervening time, leaf nodes have been split, readdir()
is not allowed to return the same file twice.

> Also, I have checked some smaller directories and lsattr reports they
> are NOT using indexing, yet still display poor correlation.

Well, if the file system has been around for a long time, and there
are lots of "holes" in the inode allocation bitmap, it can happen that
even without indexing.

As another example, if you have a large maildir directory w/o
indexing, and files get removed, deleted, etc., over time the order of
the directory entries will have very little to do with the inode
number.  That's why programs like mutt sort the directory entries by
inode number.

						- Ted
