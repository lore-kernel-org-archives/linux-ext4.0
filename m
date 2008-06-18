From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] blkid: fix swap tests (again)
Date: Wed, 18 Jun 2008 14:58:55 -0500
Message-ID: <485968FF.3020905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYFRT66 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jun 2008 15:58:58 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m5IJwvhE031260
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 15:58:57 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5IJwv6h032648
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 15:58:57 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5IJwtCO029418
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 15:58:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some architectures (ppc ...) need a bigger swapfile than is shipped,
in the test image so the current re-make of swap was failing.

We could either ship a bigger image or just dd a bigger file...

There is one more minor problem with the tests; older mkswap does not
support the -U uuid specification.  I'm not sure offhand what to do
about that problem, or if it really needs fixing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: devel/e2fsprogs-1.41-WIP/lib/blkid/test_probe.in
===================================================================
--- e2fsprogs-1.41-WIP.orig/lib/blkid/test_probe.in	2008-06-16 12:08:45.000000000 -0500
+++ e2fsprogs-1.41-WIP/lib/blkid/test_probe.in	2008-06-16 14:56:33.437233901 -0500
@@ -20,10 +20,13 @@ do
 		continue
 	fi
 	bunzip2 < $SRCDIR/tests/$i.img.bz2 > tests/tmp/test.img.$$
-	# swap is native-endian, so regenerate before testing
 	if [ "$i" = "swap0" ]; then
+		# swap is native-endian, so regenerate before testing
+		dd if=/dev/zero of=tests/tmp/test.img.$$ bs=16k count=64
 		mkswap -v0 tests/tmp/test.img.$$ > /dev/null
 	elif [ "$i" = "swap1" ]; then
+		# swap is native-endian, so regenerate before testing
+		dd if=/dev/zero of=tests/tmp/test.img.$$ bs=16k count=64
 		mkswap -v1 -L SWAP-TEST -U 8ff8e77f-8553-485e-8656-58be67a81666 tests/tmp/test.img.$$ >/dev/null
 	fi
 	./tst_probe tests/tmp/test.img.$$ > tests/$i.out

