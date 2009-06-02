From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 09/24] ext4: Add fine print for the 32000 subdirectory limit
Date: Tue,  2 Jun 2009 08:09:21 -0400
Message-ID: <1243944576-20915-9-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
 <1243944576-20915-8-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59292 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbZFBMJs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:48 -0400
In-Reply-To: <1243944576-20915-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some poeple are reading the ext4 feature list too literally and create
dubious test cases involving very long filenames and 1k blocksize and
then complain when they run into an htree-imposed limit.  So add fine
print to the "fix 32000 subdirectory limit" ext4 feature.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 722bde6875bfb49a0c84e5601eb82dd7ac02d27c)
---
 Documentation/filesystems/ext4.txt |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 0d53949..befe8d4 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -73,7 +73,7 @@ Mailing list: linux-ext4@vger.kernel.org
 * extent format more robust in face of on-disk corruption due to magics,
 * internal redunancy in tree
 * improved file allocation (multi-block alloc)
-* fix 32000 subdirectory limit
+* lift 32000 subdirectory limit imposed by i_links_count[1]
 * nsec timestamps for mtime, atime, ctime, create time
 * inode version field on disk (NFSv4, Lustre)
 * reduced e2fsck time via uninit_bg feature
@@ -88,6 +88,9 @@ Mailing list: linux-ext4@vger.kernel.org
 * efficent new ordered mode in JBD2 and ext4(avoid using buffer head to force
   the ordering)
 
+[1] Filesystems with a block size of 1k may see a limit imposed by the
+directory hash tree having a maximum depth of two.
+
 2.2 Candidate features for future inclusion
 
 * Online defrag (patches available but not well tested)
-- 
1.6.3.1.1.g75fc.dirty

