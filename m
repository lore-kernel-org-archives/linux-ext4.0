From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc/e4defrag.c: use posix_fallocate64() if
 fallocate64() is unavailable
Date: Thu, 31 Jul 2014 19:22:53 -0400
Message-ID: <20140731232253.GF1566@thunk.org>
References: <1406830068-6485-1-git-send-email-basile@opensource.dyc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Anthony G. Basile" <blueness@gentoo.org>
To: basile@opensource.dyc.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39388 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaGaXW6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2014 19:22:58 -0400
Content-Disposition: inline
In-Reply-To: <1406830068-6485-1-git-send-email-basile@opensource.dyc.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2014 at 02:07:48PM -0400, basile@opensource.dyc.edu wrote:
> From: "Anthony G. Basile" <blueness@gentoo.org>
> 
> Commit 58229aaf removed the broken fallback syscall for fallocate64() on systems
> where the latter is unavailable.  However, it did not provide a substitute,
> so the build fails on uClibc which does not have fallocate64(), but does have
> posix_fallocate64().  Since fallocate64() is called with mode=0, we can make use
> of posix_fallocate64() on such systems.

The posix_fallocate[64]() is not the same as fallocate[64]().  Some
libc's will implement posix_fallocate() by brute force writing zeros
to the file.  Some will try calling the fallocate(2) system call if it
is present, and then fall back to the brute force write.  With
fallocate(2), if the file system returns ENOTSUPP, userspace gets told
about it.

So one question is how has uClibc actually implemented with
posix_fallocate[64]()?  Does it implement fallocate()?  I'd be happier
falling back to fallocate() and simply failing to support files which
are larger than the maximum size supported by off_t.

Yet another possibility is simply changing the Makefile to simply skip
building e4defrag if the C library doesn't support the fallocate
system call.

						- Ted
