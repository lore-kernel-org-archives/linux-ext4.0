From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 9/9] libext2fs: sort keys for xattr blocks
Date: Sat, 5 Mar 2016 22:55:14 -0500
Message-ID: <20160306035514.GH10297@thunk.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
 <20160213223824.25381.8002.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>,
	Richard Purdie <richard.purdie@linuxfoundation.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36798 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbcCFDzU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Mar 2016 22:55:20 -0500
Content-Disposition: inline
In-Reply-To: <20160213223824.25381.8002.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 13, 2016 at 02:38:24PM -0800, Darrick J. Wong wrote:
> Richard Purdie reports that libext2fs doesn't sort attribute keys in
> the xattr block correctly, causing the kernel to return -ENODATA when
> querying attributes that should be there.  Therefore, sort attributes
> so that whatever ends up in the xattr block is sorted according to
> what the kernel expects.
> 
> Cc: Darren Hart <dvhart@linux.intel.com>
> Reported-by: Richard Purdie <richard.purdie@linuxfoundation.org>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, with one minor change.  You should never use something like
/tmp/b in a test script becuase it's possible that /tmp/b might
already exist, and might be not even owned by the user.  (In my case
/tmp/b was a root owned file that was sufficiently big that it it
caused ea_set command to fail with a "out of space" error.)

If /tmp/b was writable by the user and was something previous, then
the developer might get after the test script executes "rm -rf /tmp/b".

						- Ted

diff --git a/tests/d_xattr_sorting/script b/tests/d_xattr_sorting/script
index 30c189a..30187f1 100644
--- a/tests/d_xattr_sorting/script
+++ b/tests/d_xattr_sorting/script
@@ -17,16 +17,18 @@ $MKE2FS -Fq $TMPFILE 512 > /dev/null 2>&1
 status=$?
 echo Exit status is $status >> $OUT
 
-perl -e 'print "x" x 256;' > /tmp/b
+B=$(mktemp ${TMPDIR:-/tmp}/b.XXXXXX)
+
+perl -e 'print "x" x 256;' > $B
 
 echo "ea_set / security.SMEG64 -f /tmp/b" > $OUT.new
-$DEBUGFS -w -R "ea_set / security.SMEG64 -f /tmp/b" $TMPFILE >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_set / security.SMEG64 -f $B" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_set / security.imb -f /tmp/b" > $OUT.new
-$DEBUGFS -w -R "ea_set / security.imb -f /tmp/b" $TMPFILE >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_set / security.imb -f $B" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
@@ -37,7 +39,8 @@ status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
-rm -rf /tmp/b
+rm -f $B
+unset B
 
 echo "ea_list /" > $OUT.new
 $DEBUGFS -w -R "ea_list /" $TMPFILE >> $OUT.new 2>&1
