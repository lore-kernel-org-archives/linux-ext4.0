From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] fix blkid check
Date: Mon, 07 Jul 2008 23:37:34 -0600
Message-ID: <20080708053733.GC6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41375 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYGHFhl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2008 01:37:41 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m685bdU6005837
	for <linux-ext4@vger.kernel.org>; Mon, 7 Jul 2008 22:37:40 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K3O00E01AA9CK00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 07 Jul 2008 22:37:39 -0700 (PDT)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The blkid/tests contains new tests for swap, but the type-1 swapfile
test depends on mkswap supporting the "-U" option to specify the UUID.
This is not available even on relatively recent versions of mkswap
(2.13.1 16-Jan-2008) so the test needs to be changed to handle this.
If the "-U" option is not supported, don't verify the UUID in the blkid
output during testing.

Signed-off-by: Andreas Dilger <adilger@sun.com>

=========================================================================

diff --git a/lib/blkid/test_probe.in b/lib/blkid/test_probe.in
index 4ef62a2..6263bcd 100644
--- a/lib/blkid/test_probe.in
+++ b/lib/blkid/test_probe.in
@@ -13,31 +13,45 @@ mkdir -p tests/tmp
 for i in $TESTS
 do
 	printf "%s: " $i
-	if test ! -f $SRCDIR/tests/$i.img.bz2 -a \
-		! -f $SRCDIR/tests/$i.results ; 
+	RESULTS=$SRCDIR/tests/$i.results
+	IMAGE_BZ2=$SRCDIR/tests/$i.img.bz2
+	IMAGE=tests/tmp/$i.img.$$
+	if test ! -f $IMAGE_BZ2 -a ! -f $RESULTS ; 
 	then
 		echo "non-existent"
 		continue
 	fi
-	bunzip2 < $SRCDIR/tests/$i.img.bz2 > tests/tmp/test.img.$$
 	if [ "$i" = "swap0" ]; then
 		# swap is native-endian, so regenerate before testing
-		dd if=/dev/zero of=tests/tmp/test.img.$$ bs=16k count=64
-		mkswap -v0 tests/tmp/test.img.$$ > /dev/null
+		dd if=/dev/zero of=$IMAGE bs=16k count=64 2> /dev/null
+		mkswap -v0 $IMAGE > /dev/null
 	elif [ "$i" = "swap1" ]; then
 		# swap is native-endian, so regenerate before testing
-		dd if=/dev/zero of=tests/tmp/test.img.$$ bs=16k count=64
-		mkswap -v1 -L SWAP-TEST -U 8ff8e77f-8553-485e-8656-58be67a81666 tests/tmp/test.img.$$ >/dev/null
+		dd if=/dev/zero of=$IMAGE bs=16k count=64 2> /dev/null
+		# check if mkswap supports the "-U" option
+		if mkswap -h 2>&1 | grep -q -- '-U'; then
+			UUID="-U 8ff8e77f-8553-485e-8656-58be67a81666"
+		else
+			RMUUID="| grep -v UUID"
+			RES_TMP=$SRCDIR/tests/tmp/$i.results
+			grep -v UUID $RESULTS > $RES_TMP
+			RESULTS=$RES_TMP
+			
+		fi
+		mkswap -v1 -L SWAP-TEST $UUID $IMAGE >/dev/null
+	else
+		bunzip2 < $IMAGE_BZ2 > $IMAGE
 	fi
-	./tst_probe tests/tmp/test.img.$$ > tests/$i.out
-	/bin/rm -f tests/tmp/test.img.$$ tests/$i.ok tests/$i.failed
-	cmp -s tests/$i.out $SRCDIR/tests/$i.results
+	eval ./tst_probe $IMAGE $RMUUID > tests/$i.out
+	/bin/rm -f $IMAGE tests/$i.ok tests/$i.failed
+	cmp -s tests/$i.out $RESULTS
+	unset RMUUID
 	if [ $? = 0 ];  then
 		echo ok
 		touch tests/$i.ok
 	else	
 		echo failed
-		diff -c tests/$i.out $SRCDIR/tests/$i.results > tests/$i.failed
+		diff -c tests/$i.out $RESULTS > tests/$i.failed
 	fi
 done
 
Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

