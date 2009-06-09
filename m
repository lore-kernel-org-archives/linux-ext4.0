From: Greg KH <gregkh@suse.de>
Subject: [patch 73/87] ext4: Add fine print for the 32000 subdirectory limit
Date: Tue, 09 Jun 2009 02:40:01 -0700
Message-ID: <20090609094109.510003780@blue.kroah.org>
References: <20090609093848.204935043@blue.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:55491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760839AbZFIKVm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:42 -0400
Content-Disposition: inline; filename=ext4-add-fine-print-for-the-32000-subdirectory-limit.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 722bde6875bfb49a0c84e5601eb82dd7ac02d27c)

Some poeple are reading the ext4 feature list too literally and create
dubious test cases involving very long filenames and 1k blocksize and
then complain when they run into an htree-imposed limit.  So add fine
print to the "fix 32000 subdirectory limit" ext4 feature.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/ext4.txt |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -85,7 +85,7 @@ Note: More extensive information for get
 * extent format more robust in face of on-disk corruption due to magics,
 * internal redundancy in tree
 * improved file allocation (multi-block alloc)
-* fix 32000 subdirectory limit
+* lift 32000 subdirectory limit imposed by i_links_count[1]
 * nsec timestamps for mtime, atime, ctime, create time
 * inode version field on disk (NFSv4, Lustre)
 * reduced e2fsck time via uninit_bg feature
@@ -100,6 +100,9 @@ Note: More extensive information for get
 * efficent new ordered mode in JBD2 and ext4(avoid using buffer head to force
   the ordering)
 
+[1] Filesystems with a block size of 1k may see a limit imposed by the
+directory hash tree having a maximum depth of two.
+
 2.2 Candidate features for future inclusion
 
 * Online defrag (patches available but not well tested)


