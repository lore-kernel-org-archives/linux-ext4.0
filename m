From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] ext4: evict inline data when writing to memory map
Date: Mon, 1 May 2017 15:10:31 -0700
Message-ID: <20170501221031.GA69912@gmail.com>
References: <20170313004708.29838-1-ebiggers3@gmail.com>
 <20170313233313.GA23580@infradead.org>
 <20170314233239.GA127087@gmail.com>
 <20170430041357.5nrbpocxzbx5tf7p@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Nick Alcock <nick.alcock@oracle.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34490 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbdEAWKe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 May 2017 18:10:34 -0400
Content-Disposition: inline
In-Reply-To: <20170430041357.5nrbpocxzbx5tf7p@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 30, 2017 at 12:13:57AM -0400, Theodore Ts'o wrote:
> On Tue, Mar 14, 2017 at 04:32:39PM -0700, Eric Biggers wrote:
> > I'm working on this, and I discovered there's still a bug.  After the data is
> > written with mwrite, if the filesystem is then mount-cycled, the contents of the
> > file are the old contents rather than the new contents.
> > 
> > I believe this is caused by a bug in ext4_convert_inline_data().  Specifically,
> > the new block containing the evicted data is journalled using a buffer_head
> > associated with the block device.  This is wrong because it can overwrite data
> > that is later written through non-journalled writeback.
> 
> I'll apply this patch for now, since it fixes a userspace-triggerable
> BUG, but you're right.  ext4_convert_inline_data() is busted; it
> should not be using data journalling, but rather it should check to
> make sure the page is already in memory (and creating it if
> necessary), and just write it out to memory.
> 
> This is a separate bug, and we should fix it, but the first patch is
> correct and should go in.
> 
> 					- Ted

Okay, thanks.  A while ago I looked into the second bug a bit, but I never got
around to a proper fix.  Just in case someone else wants to look into it sooner,
this is the xfstest I wrote which reproduces both of these bugs:

diff --git a/tests/generic/500 b/tests/generic/500
new file mode 100755
index 00000000..8326791e
--- /dev/null
+++ b/tests/generic/500
@@ -0,0 +1,82 @@
+#! /bin/bash
+# FS QA Test generic/500
+#
+# Test writing to a file using a memory map, including a tiny file whose data
+# the filesystem may store inline.  On ext4 with inline_data, this reproduces
+# the crash fixed by: "ext4: evict inline data when writing to memory map".
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Google, Inc.  All Rights Reserved.
+#
+# Author: Eric Biggers <ebiggers@google.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	rm -f $testfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_require_test
+
+testfile=$TEST_DIR/test-$seq
+
+file_sizes=(   4 4096 65999)
+mwrite_starts=(1 2048 65500)
+mwrite_sizes=( 2 32   100)
+
+for i in ${!file_sizes[@]}; do
+
+	file_size=${file_sizes[$i]}
+	echo -e "\n=== File size $file_size ==="
+
+	# create a non-sparse file containing $file_size bytes
+	rm -f $testfile
+	yes | tr -d '\n' | head -c $file_size > $testfile
+
+	# sync the file to clean its pages, then write to it with mwrite
+	$XFS_IO_PROG $testfile \
+		-c "fsync" \
+		-c "mmap -w 0 1m" \
+		-c "mwrite ${mwrite_starts[$i]} ${mwrite_sizes[$i]}"
+
+	# cycle the mount and verify the data we wrote got to disk
+	_test_cycle_mount
+	hexdump -C $testfile
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/500.out b/tests/generic/500.out
new file mode 100644
index 00000000..6e9103fc
--- /dev/null
+++ b/tests/generic/500.out
@@ -0,0 +1,24 @@
+QA output created by 500
+
+=== File size 4 ===
+00000000  79 58 58 79                                       |yXXy|
+00000004
+
+=== File size 4096 ===
+00000000  79 79 79 79 79 79 79 79  79 79 79 79 79 79 79 79  |yyyyyyyyyyyyyyyy|
+*
+00000800  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58  |XXXXXXXXXXXXXXXX|
+*
+00000820  79 79 79 79 79 79 79 79  79 79 79 79 79 79 79 79  |yyyyyyyyyyyyyyyy|
+*
+00001000
+
+=== File size 65999 ===
+00000000  79 79 79 79 79 79 79 79  79 79 79 79 79 79 79 79  |yyyyyyyyyyyyyyyy|
+*
+0000ffd0  79 79 79 79 79 79 79 79  79 79 79 79 58 58 58 58  |yyyyyyyyyyyyXXXX|
+0000ffe0  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58  |XXXXXXXXXXXXXXXX|
+*
+00010040  79 79 79 79 79 79 79 79  79 79 79 79 79 79 79 79  |yyyyyyyyyyyyyyyy|
+*
+000101cf
diff --git a/tests/generic/group b/tests/generic/group
index b3051752..1df3b409 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -431,3 +431,4 @@
 426 auto quick exportfs
 427 auto quick aio rw
 428 auto quick
+500 auto quick
-- 
2.13.0.rc0.306.g87b477812d-goog
