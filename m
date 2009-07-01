From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option
	(Was:libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 17:28:44 -0400
Message-ID: <20090701212844.GC17054@mit.edu>
References: <20090628133430.GA3594@mit.edu> <605694f0db343657e47df0d3e82e0bc9@quantum.linuxfromscratch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott James Remnant <scott@ubuntu.com>,
	Karel Zak <kzak@redhat.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Matthew Burgess <matthew@linuxfromscratch.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49872 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbZGAV2s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jul 2009 17:28:48 -0400
Content-Disposition: inline
In-Reply-To: <605694f0db343657e47df0d3e82e0bc9@quantum.linuxfromscratch.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 01, 2009 at 03:04:43PM -0600, Matthew Burgess wrote:
> On Sun, 28 Jun 2009 09:34:30 -0400, Theodore Tso <tytso@mit.edu> wrote:
> 
> > I'll have a corrected patch checked into e2fsprogs.
> 
> Hi,
> 
> I get the following output when trying to compile e2fsprogs-1.41.7
> against util-linux-ng-2.16-rc1's installed versions of libuuid &
> libblkid

Thanks for pointing that out.  Apparently GNU make wasn't failing when
"-luuid" was in the dependency, which is why I didn't notice this
earlier.  I'm not sure why it complains with "-L/tools/lib", but not
with "-luuid", but whatever.  I've checked the following into the
e2fsprogs maint branch.

							- Ted

commit 4a1e15a8babb2176a427f40c92b7ac1e3bf7346d
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Jul 1 17:20:24 2009 -0400

    Fix compilation problem when building with --disable-uuid
    
    The MCONFIG.in file used $(LIBUUID) in the definition of DEPLIBBLKID,
    when it should have used $(DEPLIBUUID) instead.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/MCONFIG.in b/MCONFIG.in
index cec3631..9596e56 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -79,7 +79,7 @@ LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
 LIBINTL = @LIBINTL@
 DEPLIBSS = $(LIB)/libss@LIB_EXT@
 DEPLIBUUID = @DEPLIBUUID@
-DEPLIBBLKID = @DEPLIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
+DEPLIBBLKID = @DEPLIBBLKID@ @PRIVATE_LIBS_CMT@ $(DEPLIBUUID)
 
 STATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@ @DLOPEN_LIB@
 STATIC_LIBCOM_ERR = $(LIB)/libcom_err@STATIC_LIB_EXT@ @SEM_INIT_LIB@
