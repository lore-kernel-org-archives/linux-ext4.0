From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Ext4 Documentation updates.
Date: Thu, 3 Jul 2008 21:19:37 -0400
Message-ID: <20080704011937.GK30506@mit.edu>
References: <20080702172200.14990.37737.stgit@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43642 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753223AbYGDBTq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2008 21:19:46 -0400
Content-Disposition: inline
In-Reply-To: <20080702172200.14990.37737.stgit@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 02, 2008 at 12:22:00PM -0500, Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Ext4 Documentation updates.
> 
> Some of the information in Documentation/filesystems/ext4.txt is out
> of date and in need of an update.
> 
> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>

Here are some changes I have added to further update/correct/clarify
the ext4.txt file:

					- Ted

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 4424266..574c96a 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -13,40 +13,45 @@ Mailing list: linux-ext4@vger.kernel.org
 1. Quick usage instructions:
 ===========================
 
-  - Grab updated e2fsprogs from
+  - Compile and install the latest version of e2fsprogs (at least
+    1.41-WIP-0617) from:
+
     ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/
 
     or grab the latest git repository from:
+
     git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
 
-  - Create a new filesystem and set the "test_fs" extended option:
+  - Create a new filesystem using the ext4dev filesystem type:
 
-    	# mke2fs -j -E test_fs /dev/hda1
+    	# mke2fs -t ext4dev /dev/hda1
 
-    Or set the test_fs flag on an existing ext3 filesystem:
+    Or configure an existing ext3 filesystem to support extents and set
+    the test_fs flag to indicate that it's ok for an in-development
+    filesystem to touch this filesystem:
 
-        # debugfs -w /dev/sda5
-	debugfs 1.41-WIP (17-Jun-2008)
-	debugfs:  set_super_value s_flags 4
-	debugfs:  quit
+	# tune2fs -O extents -E test_fs /dev/hda1
 
-  - Mounting:
+    If the filesystem was created with 128 byte inodes, it can be
+    converted to use 256 byte for greater efficiency via:
 
-	# mount /dev/hda1 /wherever -t ext4dev
+        # tune2fs -I 256 /dev/hda1
 
-  - To disable extents:
+    (Note: we currently do not have tools to convert an ext4dev
+    filesystem back to ext3; so please do not do try this on production
+    filesystems.)
 
-	# mount /dev/hda1 /wherever -t ext4dev -o noextents
+  - Mounting:
 
-  - The filesystem is compatible with the ext3 driver until you add a file
-    which has extents (ie: `mount -o extents', then create a file).
+	# mount -t ext4dev /dev/hda1 /wherever
 
   - When comparing performance with other filesystems, remember that
-    ext3/4 by default offers higher data integrity guarantees than most.  So
-    when comparing with a metadata-only journalling filesystem, use `mount -o
-    data=writeback'.  And you might as well use `mount -o nobh' too along
-    with it.  Making the journal larger than the mke2fs default often helps
-    performance with metadata-intensive workloads.
+    ext3/4 by default offers higher data integrity guarantees than most.
+    So when comparing with a metadata-only journalling filesystem, such
+    as ext3, use `mount -o data=writeback'.  And you might as well use
+    `mount -o nobh' too along with it.  Making the journal larger than
+    the mke2fs default often helps performance with metadata-intensive
+    workloads.
 
 2. Features
 ===========
@@ -67,17 +72,13 @@ Mailing list: linux-ext4@vger.kernel.org
 * ability to pack bitmaps and inode tables into larger virtual groups via the
   flex_bg feature
 * large file support
-
-2.2 Previously available, soon to be enabled by default by "mkefs.ext4":
