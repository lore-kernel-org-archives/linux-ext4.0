From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fuzz testing an ext4fs file system under a 32 bit Linux user
 mode linux guest let task jbd2/ubda hang
Date: Sun, 3 Aug 2014 14:42:10 -0400
Message-ID: <20140803184210.GV24826@thunk.org>
References: <53DE3E92.3060304@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	UML devel <user-mode-linux-devel@lists.sourceforge.net>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42408 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaHCSxK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Aug 2014 14:53:10 -0400
Content-Disposition: inline
In-Reply-To: <53DE3E92.3060304@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 03, 2014 at 03:52:18PM +0200, Toralf F=F6rster wrote:
> Hello,
>=20
> fuzzying a 32 bit stable Gentoo x86 linux with trinity (and without e=
xcluding the munmap syscall but it might be independed from this) gives=
 within a 32 bit user mode linux guest :

The problem with these sorts of trinity bug reports is that we have no
idea which syscall or set of syscalls might have corrupted kernel
state to the point where the kernel started malfunctioning.

Sometimes, a trinity induced bug is obvious, when it causes a system
call to immediately access an illegal memory location.  But if it
causes some more subtle corruption, possibly in a completely unrelated
subsystem, figuring out what actually happened can be close to
impossible.

So there's not much I can do with this sort of bug report.  If you can
easily repeat it, and you can dump out the system call stream, we
might be able to make a smaller reproduction case, at which point
trying to debug this sort of failure would be tractable.

Cheers,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
