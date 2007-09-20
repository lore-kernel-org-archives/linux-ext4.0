From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] - ignore bind mounts in fsck
Date: Thu, 20 Sep 2007 15:08:01 -0400
Message-ID: <20070920190801.GI30221@thunk.org>
References: <46F1847E.6080400@redhat.com> <20070919204249.GH25497@thunk.org> <46F2845C.2010000@redhat.com> <20070920144245.GD30221@thunk.org> <46F28DDA.9050203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49488 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXITTII (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 15:08:08 -0400
Content-Disposition: inline
In-Reply-To: <46F28DDA.9050203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is what I actually committed into e2fsprogs git, in the maint
branch.  Note the one-line summary at the beginning of the patch
description, and the Addresses-Red-Hat-Bugzilla line before the
Signed-off-by lines.

						- Ted

commit ed773a263829493e4e4bf612dbec2380cf09349f
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Sep 20 15:06:35 2007 -0400

    fsck: Ignore /etc/fstab entries for bind mounts
    
    If a user specifies a bind mount with a non-zero fsck pass number, for
    example:
    
    /foo    /bar    ext3    bind,defaults   1 3
    
    print a warning and ignore the fstab entry.
    
    Addresses-Red-Hat-Bugzilla: #151533
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/misc/fsck.c b/misc/fsck.c
index 1dcac25..108adf6 100644
--- a/misc/fsck.c
+++ b/misc/fsck.c
@@ -867,6 +867,16 @@ static int ignore(struct fs_info *fs)
 	if (fs->passno == 0)
 		return 1;
 
+	/*
+	 * If this is a bind mount, ignore it.
+	 */
+	if (opt_in_list("bind", fs->opts)) {
+		fprintf(stderr,
+			_("%s: skipping bad line in /etc/fstab: bind mount with nonzero fsck pass number\n"),
+			fs->mountpt);
+		return 1;
+	}
+
 	interpret_type(fs);
 
 	/*
