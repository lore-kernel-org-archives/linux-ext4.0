From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 28/31] mke2fs: Complain about creating 64bit filesystems
 without extents
Date: Fri, 11 Oct 2013 21:14:56 -0400
Message-ID: <20131012011456.GB22656@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012946.28415.19973.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45058 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab3JLBPC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Oct 2013 21:15:02 -0400
Content-Disposition: inline
In-Reply-To: <20131001012946.28415.19973.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:29:46PM -0700, Darrick J. Wong wrote:
> A 64bit filesystem without extents is not terribly useful, because the old
> block map format does not support pointing to high block numbers.  Warn the
> user who tries to create such an animal.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I moved the check to the PRS() function, which is where the rest of
the feature flag sanity checks are done.  I also removed the !quiet
check, since we aren't doing this for any of the other sanity checks.
I also shortened the error message so that it fits on an 80 column
screen.

						- Ted

commit 51a72e0161c826670e6ee66cb51c2620402098f8
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Mon Sep 30 18:29:46 2013 -0700

    mke2fs: complain about creating 64bit filesystems without extents
    
    A 64bit filesystem without extents is not terribly useful, because the
    old block map format does not support pointing to high block numbers.
    Warn the user who tries to create such an animal.
    
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 22c2815..cc06a97 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1806,6 +1806,14 @@ profile_error:
 		exit(1);
 	}
 
+	/* Check the user's mkfs options for 64bit */
+	if ((fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) &&
+	    !(fs_param.s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+		printf(_("Extents MUST be enabled for a 64-bit filesystem.  "
+			 "Pass -O extents to rectify.\n"));
+		exit(1);
+	}
+
 	/* Set first meta blockgroup via an environment variable */
 	/* (this is mostly for debugging purposes) */
 	if ((fs_param.s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
