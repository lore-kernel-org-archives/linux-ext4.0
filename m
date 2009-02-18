From: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Subject: [PATCH -v2]ext4: add the spec for ext4 subdirectory limit(was: Problems
 with the max value for create directory)
Date: Wed, 18 Feb 2009 13:29:55 +0800
Message-ID: <499B9CD3.8060608@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@MIT.EDU>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61928 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZBRF2I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 00:28:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When using hash index, too many long-subdirectory-names and 1024 blocksize, the
subdirectory limit may be less than 32000.

The problem is that indexed diretories have a limit that only allows the trees
to be two levels deep. The fanout is normally big enough that this is effectively
not a problem, but if you use too many long-names, and a 1024 blocksize, you will
run into htree limit much more quickly.

The users may be puzzled when they can't create more than 32000 subdirecties with
using hash index, too many long-names and 1024 blocksize. It should be remind of
in the ext4 document.

Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
---
 Documentation/filesystems/ext4.txt |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index cec829b..0e1ec9c 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -85,7 +85,7 @@ Note: More extensive information for getting started with ext4 can be
 * extent format more robust in face of on-disk corruption due to magics,
 * internal redundancy in tree
 * improved file allocation (multi-block alloc)
-* fix 32000 subdirectory limit
+* fix 32000 subdirectory limit (*1)
 * nsec timestamps for mtime, atime, ctime, create time
 * inode version field on disk (NFSv4, Lustre)
 * reduced e2fsck time via uninit_bg feature
@@ -100,6 +100,12 @@ Note: More extensive information for getting started with ext4 can be
 * efficent new ordered mode in JBD2 and ext4(avoid using buffer head to force
   the ordering)
 
+(*1) Note
+Basically, the limit depends on blocksize and length of subdirectory names in
+the directory. If blocksize is too small (like 1024) and you use too many
+long-names, you may reach a smaller limit. When dir index is off, the limit is
+65000.
+
 2.2 Candidate features for future inclusion
 
 * Online defrag (patches available but not well tested)



