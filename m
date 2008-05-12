From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] - fix swap sanity tests in blkid, and blkid tests
Date: Mon, 12 May 2008 13:26:51 -0500
Message-ID: <48288BEB.6090005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbYELS1L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 14:27:11 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4CIQrQo031226
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 14:26:53 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CIQqGd017759
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 14:26:52 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CIQpqH012291
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 14:26:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Swap is actually native-endian on disk, and with the latest
swapspace sanity checks I added we need to have native swapspace
examples in the blkid tests, so re-mkswap them during testing.

One one other required change, though; mkswap requires at least
10 pages of swap, so the image needs to be increased to 10x64k
if mkswap is to succeed...

Maybe it'd be better to just dd it out on the fly?

Addresses-redhat-bugzilla: 445786

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs-1.41/lib/blkid/probe.c
===================================================================
--- e2fsprogs-1.41.orig/lib/blkid/probe.c
+++ e2fsprogs-1.41/lib/blkid/probe.c
@@ -845,8 +845,7 @@ static int probe_swap1(struct blkid_prob
 
 	/* check for wrong version or zeroed pagecount, for sanity */
 	if (!memcmp(id->bim_magic, "SWAPSPACE2", id->bim_len) &&
-			(blkid_le32(sws->sws_version) != 1 ||
-			 sws->sws_lastpage == 0))
+			(sws->sws_version != 1 || sws->sws_lastpage == 0))
 		return 1;
 
 	/* arbitrary sanity check.. is there any garbage down there? */
Index: e2fsprogs-1.41/lib/blkid/test_probe.in
===================================================================
--- e2fsprogs-1.41.orig/lib/blkid/test_probe.in
+++ e2fsprogs-1.41/lib/blkid/test_probe.in
@@ -20,6 +20,12 @@ do
 		continue
 	fi
 	bunzip2 < $SRCDIR/tests/$i.img.bz2 > tests/tmp/test.img.$$
+	# swap is native-endian, so regenerate before testing
+	if [ "$i" == "swap0" ]; then
+		mkswap -v0 tests/tmp/test.img.$$ > /dev/null
+	elif [ "$i" == "swap1" ]; then
+		mkswap -v1 -L SWAP-TEST -U 8ff8e77f-8553-485e-8656-58be67a81666 tests/tmp/test.img.$$ >/dev/null
+	fi
 	./tst_probe tests/tmp/test.img.$$ > tests/$i.out
 	/bin/rm -f tests/tmp/test.img.$$ tests/$i.ok tests/$i.failed
 	cmp -s tests/$i.out $SRCDIR/tests/$i.results

