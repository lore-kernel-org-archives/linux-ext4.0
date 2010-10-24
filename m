From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from
 previous mount: IO failure
Date: Sat, 23 Oct 2010 21:08:59 -0400
Message-ID: <20101024010859.GE24650@thunk.org>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm>
 <20101023222605.GC24650@thunk.org>
 <201010240156.02655.bs_lists@aakef.fastmail.fm>
 <201010240220.46113.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org,
	Bernd Schubert <bschubert@ddn.com>
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42273 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0JXBJF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 21:09:05 -0400
Content-Disposition: inline
In-Reply-To: <201010240220.46113.bs_lists@aakef.fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 24, 2010 at 02:20:45AM +0200, Bernd Schubert wrote:
> Hmm, maybe we have a mis-understanding here. If we could make e2fsck
> to *only* recovery the journal, that would be perfect. Kernel and
> e2fsck journal recovery should take approximately the same time. But
> that option does not exist yet (well, a half baken patch is on my
> disk now). If e2fsck then would detect as the kernel:
> "clear_journal_err: Filesystem error recorded from previous mount"
> and mark the filesystem with an error, that would be all we need to
> then abort the mount in the pacemaker script and allow us to run a
> real e2fsck outside of pacemaker.

What probably makes sense is to have an extended option which causes
e2fsck to just run the journal and then exit.  Part of running the
journal should be setting the EXT4_ERROR_FS bit in s_mount_state and
then clearning the journal.  That seems to be missing entirely from
e2fsck, which is a bug that we should fix regardless.

As far as detecting whether or not the file system has known errors,
you can do that by using dumpe2fs -h and grepping for "Filesystem
state".  That can have the values "clean" or "with errors".  (For ext2
file systems, or ext4 file systems without a journal, you can also
have the state "not clean" and "not clean with errors", but if you
have a journal the latter two states shouldn't ever come up.)

That way the logic that you want is something you can build into your
script, and we don't need to embed application specific logic into
e2fsprogs.  The ability to just run the journal without doing any
further checking seems like a reasonable thing to add to e2fsck ---
and by using dumpe2fs -h you'll be able to detect all possible file
system errors (not just the ones which are reported via the journal
error system).

Does that sound reasonable to you?

					- Ted

