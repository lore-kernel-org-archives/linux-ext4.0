From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: blkid: [v2] remove unnecessary header and comment
Date: Fri, 4 Jul 2014 23:31:50 -0400
Message-ID: <20140705033150.GA29001@thunk.org>
References: <1402513145-33627-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46320 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbaGEDbz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jul 2014 23:31:55 -0400
Content-Disposition: inline
In-Reply-To: <1402513145-33627-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2014 at 12:59:05PM -0600, Andreas Dilger wrote:
> The LIST_HEAD macro is not directly used in getsize.c, so
> <sys/queue.h> is not needed at all, and could cause confusion at
> some later point if the Linux-style list macros are ever used.
> 
> Build was verified on MacOS which defined HAVE_SYS_DISK_H true.
> I manually inspected the sources for recent *BSD headers to check
> if this was needed there or not.  MacOS and FreeBSD <sys/disk.h>
> do not use lists at all.  NetBSD and OpenBSD <sys/disk.h> and all
> of the <sys/mount.h> headers include <sys/queue.h> internally.
> 
> I used http://fxr.watson.org/fxr/source/sys/mount.h?v={OSTYPE}
> as a reference, checking both old and new *BSD versions.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
