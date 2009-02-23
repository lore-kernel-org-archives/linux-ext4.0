From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -v2]ext4: add the spec for ext4 subdirectory limit(was:
	Problems with the max value for create directory)
Date: Sun, 22 Feb 2009 22:25:40 -0500
Message-ID: <20090223032540.GB19739@mit.edu>
References: <499B9CD3.8060608@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37052 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbZBWDZq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Feb 2009 22:25:46 -0500
Content-Disposition: inline
In-Reply-To: <499B9CD3.8060608@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I really don't think this tweak to Documentation/filesystems/ext4.txt
is necessary, but if we going to do this, I want to tighten up the
explanation.

						- Ted

ext4: Add fine print for the 32000 subdirectory limit

Some poeple are reading the ext4 feature list too literally and create
dubious test cases involving very long filenames and 1k blocksize and
then complain when they run into an htree-imposed limit.  So add fine
print to the "fix 32000 subdirectory limit" ext4 feature.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index cec829b..5c484ae 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -85,7 +85,7 @@ Note: More extensive information for getting started with ext4 can be
 * extent format more robust in face of on-disk corruption due to magics,
 * internal redundancy in tree
 * improved file allocation (multi-block alloc)
-* fix 32000 subdirectory limit
+* lift 32000 subdirectory limit imposed by i_links_count[1]
 * nsec timestamps for mtime, atime, ctime, create time
 * inode version field on disk (NFSv4, Lustre)
 * reduced e2fsck time via uninit_bg feature
@@ -100,6 +100,9 @@ Note: More extensive information for getting started with ext4 can be
 * efficent new ordered mode in JBD2 and ext4(avoid using buffer head to force
   the ordering)
 
+[1] Filesystems with a block size of 1k may see a limit imposed by the
+directory hash tree having a maximum depth of two.
+
 2.2 Candidate features for future inclusion
 
 * Online defrag (patches available but not well tested)
