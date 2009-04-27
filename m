From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Mon, 27 Apr 2009 11:21:14 +0200
Message-ID: <20090427092114.GA3193@nb.net.home>
References: <20090224084434.GF6020@nb.net.home> <20090324121147.GA22386@zelda.netsplit.com> <20090416102241.GA3290@nb.net.home> <1239976118.11603.109.camel@quest> <20090422133304.GP15541@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott James Remnant <scott@ubuntu.com>, linux-ext4@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60139 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbZD0JVk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2009 05:21:40 -0400
Content-Disposition: inline
In-Reply-To: <20090422133304.GP15541@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 22, 2009 at 09:33:04AM -0400, Theodore Tso wrote:
> This is the version of the the --disable-libblkid patch which I

[...]

> The changes have been pushed out to the e2fsprogs git repository if
> you want to try it out with the latest changes, which will be in the
> very-soon-to-be-released e2fsprogs 1.41.5.

 Thanks!

 I forgot that we need to freeze blkid version number in e2fsprogs to
 avoid collisions between e2fsprogs and util-linux-ng. Currently the
 blkid version number is shared with e2fsprogs version number. 

 The e2fsprogs blkid should be in maintenance mode only. All development
 should happen in util-linux-ng only. Right?

 This problem should be resolved before util-linux-ng-2.15 stable
 release (-rc2 now).

 (See the patch below -- it's example. I don't know if you want to add
  LIBBLKID_VERSION to the global version.h or something other to
  configure.in, or so...)

    Karel
 
>From 7d79dd7105c62b1b91e6e5a556b598c086aa0796 Mon Sep 17 00:00:00 2001
From: Karel Zak <kzak@redhat.com>
Date: Mon, 27 Apr 2009 10:55:43 +0200
Subject: [PATCH] blkid: freeze version number

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 lib/blkid/version.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/lib/blkid/version.c b/lib/blkid/version.c
index 7722916..0219caa 100644
--- a/lib/blkid/version.c
+++ b/lib/blkid/version.c
@@ -19,7 +19,10 @@
 #include "blkid.h"
 #include "../../version.h"
 
-static const char *lib_version = E2FSPROGS_VERSION;
+/* The blkid library in e2fsprogs is in maintenance mode. The <maj>.<min>
+ * version number should be incremented in util-linux-ng only.
+ */
+static const char *lib_version = "1.41.4";
 static const char *lib_date = E2FSPROGS_DATE;
 
 int blkid_parse_version_string(const char *ver_string)
-- 
1.6.0.6


-- 
 Karel Zak  <kzak@redhat.com>
