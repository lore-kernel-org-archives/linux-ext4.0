From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/25] mke2fs: don't let resize= turn on resize_inode
 when meta_bg is set
Date: Wed, 23 Oct 2013 19:40:30 -0400
Message-ID: <20131023234030.GC31400@thunk.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018044915.7339.15471.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49876 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab3JWXkc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 19:40:32 -0400
Content-Disposition: inline
In-Reply-To: <20131018044915.7339.15471.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's a better way to fix this.  Thanks for pointing out this
problem!

					- Ted

>From cecfb4c04227dd5803c24b311d92a80e91b7b380 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 17 Oct 2013 21:49:16 -0700
Subject: [PATCH] mke2fs: don't let resize= turn on resize_inode when meta_bg
 is set

Passing the "-E resize=NNN" option to mke2fs sets the resize_inode
feature.  However, resize_inode and meta_bg are mutually exclusive;
unfortunately, we check this constraint before we parse the extended
options.  Fix this by moving this check after the calls
parse_extended_opts().

Reported-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index cc06a97..64d923a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1797,15 +1797,6 @@ profile_error:
 		fs_param.s_feature_ro_compat = 0;
  	}
 
-	if ((fs_param.s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
-	    (fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
-		fprintf(stderr, _("The resize_inode and meta_bg features "
-				  "are not compatible.\n"
-				  "They can not be both enabled "
-				  "simultaneously.\n"));
-		exit(1);
-	}
