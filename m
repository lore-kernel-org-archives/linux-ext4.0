From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Release of e2fsprogs 1.43.3
Date: Mon, 5 Sep 2016 23:43:31 -0400
Message-ID: <20160906034331.h7fdz7n3qw22vceh@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46724 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932429AbcIFDnf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Sep 2016 23:43:35 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've released e2fsprogs 1.43.3 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and
available for download at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.3

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.3.tar.gz

The release notes for 1.43.3 can be found below.

                                                  - Ted

E2fsprogs 1.43.3 (September 4, 2016)
====================================

Fix e2fsck's handling of timestamps on 32-bit systems.

E2fsck will now check, and if necessary repair the extra isize fields
in the inode and superblock.

Fix crashes on architectures such as sparc64 that are sensitive to
unaligned pointer derferences in the journal recovery code when
journal checksums are enabled.

Programming notes
-----------------

Support reproducible builds by not capturing the build directory into
the mk_cmds and compile_et scripts.

Fix debian build rules to ensure build reproducibility and to avoid
hiding the linker flags for e2fsck.static so the build hardening log
scanner can properly audit the build.

Fix compatibility with FreeBSD's pmake and teach the configure script
to force the creation of pmake-compatible Makefiles if the
FORCE_NATIVE_MAKE environment variable is set to a non-empty value.

