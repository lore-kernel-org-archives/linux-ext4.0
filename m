From: Ted Ts'o <tytso@mit.edu>
Subject: Re: fsck performance.
Date: Sun, 20 Feb 2011 14:34:06 -0500
Message-ID: <20110220193406.GC3017@thunk.org>
References: <20110220090656.GA11402@bitwizard.nl>
 <20110220170931.GB3017@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54744 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab1BTTeN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 14:34:13 -0500
Content-Disposition: inline
In-Reply-To: <20110220170931.GB3017@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 20, 2011 at 12:09:31PM -0500, Ted Ts'o wrote:
> 
> Ah, you're using tdb.  Tdb can be really slow.  It's been on my todo
> list to replace tdb with something else, but I haven't gotten around
> to it.

Hmm... after taking a quick look at the TDB sources, why don't you try
this.  In lib/ext2fs/icount.c and e2fsck/dirinfo.c, try replacing the
flag TDB_CLEAR_IF_FIRST with TDB_NOLOCK | TDB_NOSYNC.  i.e., try
replacing:

	icount->tdb = tdb_open(fn, 0, TDB_CLEAR_IF_FIRST,
			       O_RDWR | O_CREAT | O_TRUNC, 0600);

with:

	icount->tdb = tdb_open(fn, 0, TDB_NOLOCK | TDB_NOSYNC,
			       O_RDWR | O_CREAT | O_TRUNC, 0600);


Could you let me know what this does to the performance of e2fsck with
scratch files enabled?

Oh, and BTW, it would be useful if you tried configuring
tests/test_config so that it sets E2FSCK_CONFIG with a test
e2fsck.conf that enables the scratch files somewhere in tmp, and then
run the regression test suite with these changes.

If they work, and it solves the performance problem, let me know and
send me patches.  If we can figure out some way of improving the
performance without needing to replace tdb, that would be great...

     		       	   	 	   - Ted
