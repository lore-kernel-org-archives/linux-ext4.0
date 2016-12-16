From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: Creating a mailing list, git tree, and patchwork project for
 fscrypt
Date: Fri, 16 Dec 2016 14:25:09 -0800
Message-ID: <20161216222509.GD14264@gmail.com>
References: <20161216203732.g65wjf2wgc6rsijy@thunk.org>
 <20161216205330.GB14264@gmail.com>
 <20161216220419.znasf5wjkpb7qazr@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org,
        ebiggers@google.com, mhalcrow@google.com, richard@nod.at,
        linux-ext4@vger.kernel.org, linux-f2fs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34730 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758080AbcLPWZM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Dec 2016 17:25:12 -0500
Content-Disposition: inline
In-Reply-To: <20161216220419.znasf5wjkpb7qazr@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 16, 2016 at 05:04:19PM -0500, Theodore Ts'o wrote:
> On Fri, Dec 16, 2016 at 12:53:30PM -0800, Eric Biggers wrote:
> > Sounds great!
> > 
> > I guess it will be "fscrypt" and not "fscrypto"?  There has been some confusion
> > about which term to use but it seems to be settling on "fscrypt".
> 
> It was originally fscrypt, but then fscrypto crept in when we
> refactored the out to the fs/crypto directory from fs/ext4.  I was
> planning on cleaning that up before we had too many file systems users
> of fscrypt that we would need to synchronzie with, but it'll be easier
> to do this as a separate git tree.  We can either do it at the very
> beginning of the merge window (and have all of the file systems pull
> the change into fs/crypt), or I can work with Linus to do it right
> after the next next merge window closes.
> 
> My preferences would be for the former, given where we are in the
> development cycle.
> 

I'm fine with fscrypt.  With regards to the cleanup, are you referring to
renaming the header fscrypto.h to fscrypt.h?  Fortunately there aren't a lot
places that "fscrypto" actually appears in the tree --- basically just that
header, the module name, a couple log messages, and the MAINTAINERS file:

	MAINTAINERS:FS-CRYPTO: FILE SYSTEM LEVEL ENCRYPTION SUPPORT
	MAINTAINERS:F:  include/linux/fscrypto.h
	fs/crypto/Makefile:obj-$(CONFIG_FS_ENCRYPTION)  += fscrypto.o
	fs/crypto/Makefile:fscrypto-y := crypto.o fname.o policy.o keyinfo.o
	fs/crypto/Makefile:fscrypto-$(CONFIG_BLOCK) += bio.o
	fs/crypto/fscrypt_private.h:#include <linux/fscrypto.h>
	fs/crypto/keyinfo.c:            pr_warn_once("fscrypto: unsupported contents encryption mode "
	fs/crypto/keyinfo.c:            pr_warn_once("fscrypto: unsupported filenames encryption mode "
	fs/crypto/keyinfo.c:    pr_warn_once("fscrypto: unsupported file type %d for inode %lu\n",
	fs/ext4/ext4.h:#include <linux/fscrypto.h>
	fs/ext4/page-io.c:#include <linux/fscrypto.h>
	fs/f2fs/f2fs.h:#include <linux/fscrypto.h>
	fs/ubifs/ubifs.h:#include <linux/fscrypto.h>
	include/linux/fscrypto.h:#ifndef _LINUX_FSCRYPTO_H
	include/linux/fscrypto.h:#define _LINUX_FSCRYPTO_H
	include/linux/fscrypto.h:#endif /* _LINUX_FSCRYPTO_H */

Eric
