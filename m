From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] return status from chattr
Date: Mon, 22 Oct 2007 01:27:47 -0400
Message-ID: <20071022052747.GA29220@thunk.org>
References: <46F2B47A.1070902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44323 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXJVF15 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2007 01:27:57 -0400
Content-Disposition: inline
In-Reply-To: <46F2B47A.1070902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 20, 2007 at 12:57:14PM -0500, Eric Sandeen wrote:
> I changed this a bit so that if it's explicitly listed on the
> commandline, the link itself gets chattr'd.  I'm not quite sure 
> what is intended here; that the links are not *followed* or
> that they are not chattr'd?  Seems a little odd to me.

Both; you can't chattr a symlink.  You can try, but in fact what
happens is that you end up chattr'ing the destination of the link,
which is probably not what you want.

> I tried to follow the way other recursive commands work, for example
> chmod -R, and carry on in the face of any errors.  If any error
> was encountered, exit with an error.  If no errors, exit 0.

Yep, that makes sense.

> Also, if both flags and -v (version) are specified, and the flag 
> set encounters an error, the version set is not attempted.  Is this 
> ok or should both commands be tried?

I think an atomic failure makes the most amount of sense.

> Finally, I'm curious, the utility ignores anything that's not a link,
> regular file, or dir, but the kernel code doesn't have these checks.
> Should it?

For better or for worse, the ext2/3/4 flags are set via an ioctl.
This means it doesn't work for anything other than a regular file or a
directory.  For a symlink, it will fail, or follow the symlink.
There's a bug in libe2p which I'll fix which causes it to not return
EOPNOTSUPP for symlinks because it's using stat() when it should use
lstat().

So we should be ignoring symbolic links, as well, since we can't
change them.

						- Ted
