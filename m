From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Build using CFLAGS passed in at configure
Date: Mon,  1 Aug 2011 17:58:24 -0400
Message-ID: <1312235904-21187-1-git-send-email-tytso@mit.edu>
References: <20110730165517.GA13918@infradead.org>
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: hch@infradead.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59006 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1HAV62 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 17:58:28 -0400
In-Reply-To: <20110730165517.GA13918@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In order to build xfsprogs in a hermetic build, we need be able to
pass in -I and -L flags to the compiler and linker, respectively.
This needs to be used by the configure script, but we also need to
make sure these flags are used by the Makefiles as well.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 include/builddefs.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index 4c8ec64..81ebfcd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -25,6 +25,7 @@ OPTIMIZER = @opt_build@
 MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
+CFLAGS = @CFLAGS@
 
 LIBRT = @librt@
 LIBUUID = @libuuid@
-- 
1.7.4.1.22.gec8e1.dirty

