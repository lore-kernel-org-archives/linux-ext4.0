From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 14562] New: On umount warn in page_alloc.c:1751
	__alloc_pages_slowpath
Date: Sun, 8 Nov 2009 21:44:43 -0500
Message-ID: <20091109024443.GD7592@mit.edu>
References: <bug-14562-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48374 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbZKICoo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Nov 2009 21:44:44 -0500
Content-Disposition: inline
In-Reply-To: <bug-14562-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 08, 2009 at 10:52:59PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> Created a new ext4 fs on sda5.
> Did copy my backup (about 40Gig back) und did a umount to the fs.
> After this i got this warning:

Did you also do a mount operation shortly afterwards?  It looks like 4
seconds after the unmount completed, it was a mount operation that
caused the warning.

> [43805.914995] EXT4-fs: mballoc: 6643657 preallocated, 1203082 discarded
> [43809.377291] ------------[ cut here ]------------
> [43809.377320] WARNING: at /build/buildd/linux-2.6.31/mm/page_alloc.c:1751

The EXT4-fs: mballoc: is the last line you would normally expect to
see when unmounting the filesystem.  And the warning took place 4
seconds later, which is a eternity as far as kernel-time is
considered.

Also, look at the bottom of the call trace:

> [43809.377512] Call Trace:
> [43809.377531]  [<c014518d>] warn_slowpath_common+0x6d/0xa0
  	....
> [43809.377633]  [<c01e088f>] __kmalloc+0xdf/0x180
> [43809.377646]  [<c031974e>] match_number+0x2e/0xa0
> [43809.377657]  [<c03197ea>] match_int+0xa/0x10
> [43809.377670]  [<c0274102>] parse_options+0x152/0x810
  	....
> [43809.377760]  [<c027baa0>] ? ext4_fill_super+0x0/0x1900
> [43809.377772]  [<c01e9cde>] vfs_kern_mount+0x5e/0x120
> [43809.377784]  [<c01e9df9>] do_kern_mount+0x39/0xd0
> [43809.377797]  [<c01fee2e>] do_new_mount+0x6e/0xa0
> [43809.377808]  [<c01ff7f9>] do_mount+0x1c9/0x1e0
> [43809.377819]  [<c01ff876>] sys_mount+0x66/0xa0
  		  	       ^^^^^^^^^
> [43809.377831]  [<c010336c>] syscall_call+0x7/0xb
> [43809.377840] ---[ end trace a7919e7f17c0a727 ]---


Looks like this was some kind of "interesting" set of mount options
passed to the kernel.  Any chance you could figure out what the mount
options were to the mount operation?

					- Ted
