From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid/Makefile.in: ignore rmdir non-empty dir error
Date: Sat, 3 Oct 2009 22:47:25 -0400
Message-ID: <20091004024725.GG15688@mit.edu>
References: <1254135442-28755-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41420 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236AbZJDCsD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Oct 2009 22:48:03 -0400
Content-Disposition: inline
In-Reply-To: <1254135442-28755-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 28, 2009 at 06:57:22PM +0800, Peng Tao wrote:
> Otherwise, make clean returns the following error, which is missleading.
> rmdir tests
> rmdir: failed to remove `tests': Directory not empty
> make: [clean] Error 1 (ignored)
> 
> Signed-off-by: Peng Tao <bergwolf@gmail.com>

This is what I checked in instead.

					- Ted

commit 7822f784f1edf767cc74044e02702a6d44cee267
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Oct 3 22:33:47 2009 -0400

    blkid: Avoid a potentially error message when running "make clean"
    
    This error isn't terribly important, but apparently it causes some
    users/developers distress.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index 9169226..9339718 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -181,7 +181,8 @@ clean::
 		tests/*.img results test_probe core profiled/* \
 		checker/* blkid_types.h ../libblkid.a ../libblkid_p.a \
 		$(SMANPAGES) blkid
-	-rmdir tests
+	@echo rmdir tests/tmp tests
+	@(rmdir tests/tmp tests 2> /dev/null ; exit 0)
 
 mostlyclean:: clean
 distclean:: clean


