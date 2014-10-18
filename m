From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/34] debugfs: add LIBINTL to debugfs link command
Date: Sat, 18 Oct 2014 12:10:14 -0400
Message-ID: <20141018161014.GA30124@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221152.13646.7986.stgit@birch.djwong.org>
 <20140919044601.GI26995@thunk.org>
 <20141017210737.GA13081@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59255 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaJSLdl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Oct 2014 07:33:41 -0400
Content-Disposition: inline
In-Reply-To: <20141017210737.GA13081@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 17, 2014 at 02:07:37PM -0700, Darrick J. Wong wrote:
> 
> True, but since debugfs pulls in plausible.o which uses _(), it still needs
> this patch to build on OSX 10.9.5.

Good point.  I'l fix it this way.  (Basically, it's really pointless
to link debugfs with LIBINTL since debugfs doesn't have any I18N
support, and I'd prefer to limit unnecessary bloat.)

	     	 	   	 	     - Ted

commit 831aa869e8b1b287ca921e7ae181a4cdca839099
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Oct 18 09:13:09 2014 -0400

    debugfs: fix build on systems that don't have gettext built-in
    
    Debugfs (unlike all of the other programs in e2fsprogs) is not set up
    to use translated strings.  So when building misc/plausible.c for
    debugfs, we need to disable NLS.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/misc/nls-enable.h b/misc/nls-enable.h
index a91dcc1..2f62c01 100644
--- a/misc/nls-enable.h
+++ b/misc/nls-enable.h
@@ -1,4 +1,4 @@
-#ifdef ENABLE_NLS
+#if defined(ENABLE_NLS) && !defined(DEBUGFS)
 #include <libintl.h>
 #include <locale.h>
 #define _(a) (gettext (a))
