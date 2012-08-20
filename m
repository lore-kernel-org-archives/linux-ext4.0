From: Jan Kara <jack@suse.cz>
Subject: Re: Test 272 fails for ext3
Date: Mon, 20 Aug 2012 23:06:38 +0200
Message-ID: <20120820210638.GA4591@quack.suse.cz>
References: <20120816092808.GA9057@quack.suse.cz>
 <20120816093757.GA11519@quack.suse.cz>
 <20120816224858.GY2877@dastard>
 <20120820162212.GA17354@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, dmonakhov@openvz.org,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2HTVGl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Aug 2012 17:06:41 -0400
Content-Disposition: inline
In-Reply-To: <20120820162212.GA17354@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 20-08-12 18:22:12, Jan Kara wrote:
> On Fri 17-08-12 08:48:58, Dave Chinner wrote:
> > On Thu, Aug 16, 2012 at 11:37:57AM +0200, Jan Kara wrote:
> > >   Hello,
> > > 
> > >   I was looking into why test 272 from xfstests fails for ext3 and the
> > > reason is that ext3 does not support direct IO to file with enabled data
> > > journalling (open returns EINVAL because ->direct_IO callback is not
> > > specified). So I was thinking how to accomodate this fact in the test -
> > > the best I found was to just check using xfs_io whether O_DIRECT open
> > > succeeds and perform the test only in that case. Attached patch does this
> > > or do people have other ideas?
> > 
> > 
> > # ext3 doesn't support direct IO in journalling mode
> > ext3_write_opt_list="iflag=noatime conv=notrunc conv=fsync"
> > ext4_write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
> > 
> > if [ $FSTYP = "ext3" ]; then
> > 	write_opt_list="$ext3_write_opt_list"
> > else
> > 	write_opt_list="$ext4_write_opt_list"
> > fi
>   Yeah, this is probably simpler. Thanks for suggestion. BTW, ext4 also
> does not support direct IO and data journalling but it silently falls back
> to buffered IO. Anyway new patch is attached.
  Hum, after testing this I realized why I did the things the original way.
The test writes a message with title for each test so when direct IO tests
are skipped outputs don't match.

After some thought I decided to change the test to output titles only to
full output and keep compared output (almost) empty. Result is attached.

								Honza

--/04w6evG8XlLl3ft
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Make-test-272-work-for-ext3.patch"

>From 170ff81c2ba12e0c7d30d21fa9401a459638e8eb Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 16 Aug 2012 11:14:35 +0200
Subject: [PATCH v3] Make test 272 work for ext3

ext3 does not support direct IO for files with data journalling. This
confuses test 272. Make the test check whether open succeeds and perform
the writing only if it does.

Thanks for Dave Chinner for suggesting a simpler way to fix the test.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 272     |   15 +++++++++------
 272.out |   36 +-----------------------------------
 2 files changed, 10 insertions(+), 41 deletions(-)

diff --git a/272 b/272
index 26dfa3b..21559ff 100755
--- a/272
+++ b/272
@@ -32,15 +32,18 @@ tmp=/tmp/$$
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
+write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
+if [ $FSTYP = "ext3" ]; then
+	# ext3 doesn't support direct IO in journalling mode
+	write_opt_list="iflag=noatime conv=notrunc conv=fsync"
+fi
+
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
 _workout()
 {
-	echo ""
-	echo " Switch data journalling mode"
-	echo ""
-	write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
+	echo "Switch data journalling mode. Silence is golden."
 	chattr_opt_list="+j -j +jS -j"
 	idx=0
 	#
@@ -51,7 +54,7 @@ _workout()
 		do
 		    
 			echo "OP write_opt: $write_opt 4M, \
-chattr_opt: $chattr_opt"
+chattr_opt: $chattr_opt" >>$seq.full
 			dd if=/dev/zero of=$SCRATCH_MNT/file.$idx \
 				bs=1M count=4 $write_opt \
 				>> $seq.full 2>&1 || exit
@@ -69,7 +72,7 @@ chattr_opt: $chattr_opt"
 		do
 
 			echo "OP write_opt: $write_opt ENOSPC, \
-chattr_opt: $chattr_opt"
+chattr_opt: $chattr_opt" >>$seq.full
 			dd if=/dev/zero of=$SCRATCH_MNT/file.$idx \
 				bs=1M $write_opt >> $seq.full 2>&1
 			chattr $chattr_opt $SCRATCH_MNT/file.$idx \
diff --git a/272.out b/272.out
index cc687aa..a9eaf84 100644
--- a/272.out
+++ b/272.out
@@ -1,37 +1,3 @@
 QA output created by 272
-
- Switch data journalling mode
-
-OP write_opt: iflag=noatime 4M, chattr_opt: +j
-OP write_opt: iflag=noatime 4M, chattr_opt: -j
-OP write_opt: iflag=noatime 4M, chattr_opt: +jS
-OP write_opt: iflag=noatime 4M, chattr_opt: -j
-OP write_opt: conv=notrunc 4M, chattr_opt: +j
-OP write_opt: conv=notrunc 4M, chattr_opt: -j
-OP write_opt: conv=notrunc 4M, chattr_opt: +jS
-OP write_opt: conv=notrunc 4M, chattr_opt: -j
-OP write_opt: conv=fsync 4M, chattr_opt: +j
-OP write_opt: conv=fsync 4M, chattr_opt: -j
-OP write_opt: conv=fsync 4M, chattr_opt: +jS
-OP write_opt: conv=fsync 4M, chattr_opt: -j
-OP write_opt: oflag=direct 4M, chattr_opt: +j
-OP write_opt: oflag=direct 4M, chattr_opt: -j
-OP write_opt: oflag=direct 4M, chattr_opt: +jS
-OP write_opt: oflag=direct 4M, chattr_opt: -j
-OP write_opt: iflag=noatime ENOSPC, chattr_opt: +j
-OP write_opt: iflag=noatime ENOSPC, chattr_opt: -j
-OP write_opt: iflag=noatime ENOSPC, chattr_opt: +jS
-OP write_opt: iflag=noatime ENOSPC, chattr_opt: -j
-OP write_opt: conv=notrunc ENOSPC, chattr_opt: +j
-OP write_opt: conv=notrunc ENOSPC, chattr_opt: -j
-OP write_opt: conv=notrunc ENOSPC, chattr_opt: +jS
-OP write_opt: conv=notrunc ENOSPC, chattr_opt: -j
-OP write_opt: conv=fsync ENOSPC, chattr_opt: +j
-OP write_opt: conv=fsync ENOSPC, chattr_opt: -j
-OP write_opt: conv=fsync ENOSPC, chattr_opt: +jS
-OP write_opt: conv=fsync ENOSPC, chattr_opt: -j
-OP write_opt: oflag=direct ENOSPC, chattr_opt: +j
-OP write_opt: oflag=direct ENOSPC, chattr_opt: -j
-OP write_opt: oflag=direct ENOSPC, chattr_opt: +jS
-OP write_opt: oflag=direct ENOSPC, chattr_opt: -j
+Switch data journalling mode. Silence is golden.
 Check filesystem
-- 
1.7.1


--/04w6evG8XlLl3ft--
