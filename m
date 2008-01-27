From: Theodore Tso <tytso@mit.edu>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Sun, 27 Jan 2008 00:05:43 -0500
Message-ID: <20080127050543.GC24842@mit.edu>
References: <20080124211728.GA24900@webber.adilger.int> <n7xir1iq69b.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, hvogel@suse.de,
	Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33086 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750741AbYA0FFv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jan 2008 00:05:51 -0500
Content-Disposition: inline
In-Reply-To: <n7xir1iq69b.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Wow.  You have a lot of patches in the SLES 10 e2fsprogs.  I'm not
sure why of them are there, though.  For example:

Patch0:         elf.diff

I'm not sure what this one is for.

Patch1:		e2fsprogs-1.35-libdir.diff

This one does two different things.  One is include AC_HEADER_TIME in
configure.in, and the other is to use $lib instead of "lib" when
defining root_libdir.  This seems to force root_libdir to /, which
makes no sense to me.


Patch4:         e2fsprogs-blkid.diff

This patch causes fsck to check the BLKID_FILE environment variable
and passes it to the blkid library.  But the blkid library *already*
checks the BLKID_FILE environtment variable already.  So I'm not sure
why this is necessary at all.


Patch6:         e2fsprogs-mdraid.patch

This apparently adds a new environment variable,
BLKID_SKIP_CHECK_MDRAID, which forces blkid to not detect mdraid
devices.  I'm not sure why.


Patch9:         e2fsprogs-libvolume_id-support.patch

This one is going to cause problems for ext4 support, because
libvolume_id isn't going to have the right logic for ext4.  There are
also issues with volume_id library where I haven't been happy with the
choices Kay has made in terms of correctness.


Patch10:        close.patch

I don't understand what this patch is trying to do.


Patch12:        e2fsprogs-mkinstalldirs.patch

Why?


Patch22:        e2fsprogs-1.40.4-uuidd_pid_path.patch

The problem with this patch is that /var/run is cleared via rm -rf, so
it is highly problamtic to put the scratch directory for uuidd in
/var/run.


Patch32:        libcom_err-no-e2fsck.static.patch

This patch does two completely unrelated things.  One is to disable
the libcom_err regression test suite (probably because some of the
other changes made) and the other is to disable building the
e2fsck.static file.  Why these two are bundled into a single patch I'm
not sure.


Patch34:        libcom_err-compile_et_permissions.patch

Why?

							- Ted
