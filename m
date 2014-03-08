From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: chattr: operation not supported ( on symlinks )
Date: Sat, 8 Mar 2014 10:29:57 -0500
Message-ID: <20140308152957.GA11633@thunk.org>
References: <531A2918.9020108@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38755 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbaCHPaA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Mar 2014 10:30:00 -0500
Content-Disposition: inline
In-Reply-To: <531A2918.9020108@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2014 at 03:16:24PM -0500, Phillip Susi wrote:
> It seems that symlinks return -ENOTSUP for lsattr, causing chattr -R
> to spew errors.  Why don't symlinks support attributes, and if not,
> shouldn't chattr know this and suppress operating on symlinks instead
> of spewing errors?

The VFS layer doesn't pass ioctl's down to the file system layer for
symlinks.  Thinking about this, arguably the right answer is to allow
chattr to function on symlinks, since it cloud be useful to make
symlinks immutable.

						- Ted
