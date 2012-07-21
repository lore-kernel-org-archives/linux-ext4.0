From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How should e2fsck clear s_errno/j_errno on an ro mount?
Date: Fri, 20 Jul 2012 20:39:53 -0400
Message-ID: <20120721003953.GA9399@thunk.org>
References: <5009E62E.3020608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40217 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab2GUAkE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2012 20:40:04 -0400
Content-Disposition: inline
In-Reply-To: <5009E62E.3020608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 20, 2012 at 06:13:50PM -0500, Eric Sandeen wrote:
> I'm looking at a situation where a root filesystem encountered an error and shut down, and therefore the error was stored in the journal.
> 
> But for the root fs, it seems that nothing can clear it.
> 
> If we do e2fsck -fy on a readonly mounted filesystem, then remount,rw the error persists:
> 
> [25124.319387] EXT4-fs warning (device loop3): ext4_clear_journal_err:4281: Filesystem error recorded from previous mount: IO failure
> [25124.331140] EXT4-fs warning (device loop3): ext4_clear_journal_err:4282: Marking fs in need of filesystem check.
> 
> ad infinitum.
> 
> It may be my fever-addled brain this week but I'm having a hard time following how this error is supposed to get set & cleared, especially if e2fsck has modified it while mounted ro.
> 
> As soon as I mount rw again, load_superblock() sees the journal superblock has an error set, and copies it back into the journal->j_errno.
> 
> After Ted's "e2fsck: correctly propagate error from journal to superblock" in e2fsprogs, at least an unmounted fs gets cleaned up, but I'm not sure what to do to fix this when it's mounted.  

The problem you describe should have been fixed by commit 6d75685e:
e2fsck: handle an already recovered journal with a non-zero s_error
field, which is in e2fsprogs 1.42.4.

					- Ted
