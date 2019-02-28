Return-Path: <SRS0=tfh/=RD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA5EC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Feb 2019 23:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5541218AE
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Feb 2019 23:29:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZekneLlU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731671AbfB1X3K (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Feb 2019 18:29:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbfB1X3K (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2019 18:29:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1SNT5jq190275;
        Thu, 28 Feb 2019 23:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=RVoBOL2FQUM55DpIh028OOYBhZWW0c4fsn3QY6LzUOs=;
 b=ZekneLlU6jMykKBOQTyIzBa11T29CM+gMhdla/Mt9i2gYhCPxOmUOstBOt2qiiSo9z5P
 OYQUNBT8XOcGe563+nk3OUXC/7OIuTLeMWXMVku0rlKGlAnoz8puF4/DhfaX6FeJu5Lr
 1IjrX9I+6qhSbOXMIK2I/I+D6NRvMkoDEtkRfnq3dIDi8Khi01cVtLmWlmAbqdGpy78/
 w0UdDQNWIs8jbix/A+w3Gmy8aUzd3TehXUgbYgDIK9ZN8rrt3pVo8+Mo1SkV9TfIi6d7
 AgHWsLRQwTlIpRb2/d6HJzp4asqqBwDPKzd3vbV4Mss44YidSEOGVNnYQDcmCRSMqTP7 /w== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2qtxts4860-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 23:29:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1SNT24C004393
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 23:29:03 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1SNT2bP009165;
        Thu, 28 Feb 2019 23:29:02 GMT
Received: from localhost (/10.145.178.102)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 15:29:02 -0800
Date:   Thu, 28 Feb 2019 15:29:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Whitney <enwlinux@gmail.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: sporadic shared/298 failures?
Message-ID: <20190228232901.GC6471@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9181 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902280156
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Eric,

On this morning's ext4 concall you mentioned that you saw sporadic
failures in shared/298, and I mentioned that I'd seen similar symptoms
on xfs.  I had a look at 298 and discovered that it probes the file
image for holes while the filesystem is loop-mounted!  Yikes!  I don't
remember the exact circumstances of your testing (I think you said it
was related to bigalloc?) but this reproduces on XFS with blocksize = 1k
every time.

Does the following patch fix your sporadic failures?

(This isn't the last word on this test -- both ext4 and XFS now /do/
support live queries of the freep space map, so we're probably going
to want a similar test that doesn't clunkily unmount the fs so much.)

I'll send this patch out with proper subject line and whatnot next week
after I give it more thorough testing on xfs.

--D

This test does some weird things with live filesystems -- it seems to be
validating the behavior of fstrim by comparing the filesystem's free
space map to holes in the file image that backs the filesystem.
However, this doesn't account for the fact that some filesystems
maintain in-core preallocations and/or can perturb the free space data
during unmount.  This causes sporadic test failures when the two become
out of sync.

Therefore, make sure we unmount the filesystem before we start running
tools against the filesystem image file to eliminate the possibility of
changes to the free space map.  This was found by running shared/298 on
xfs with a 1k block size.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/shared/298 |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tests/shared/298 b/tests/shared/298
index aafdc25f..5d6c6ccf 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -46,13 +46,21 @@ _cleanup()
 
 get_holes()
 {
+	# It's not a good idea to be running tools against the image file
+	# backing a live filesystem because the filesystem could be maintaining
+	# in-core state that will perturb the free space map on umount.  Stick
+	# to established convention which requires the filesystem to be
+	# unmounted while we probe the underlying file.
+	$UMOUNT_PROG $loop_mnt
 	$XFS_IO_PROG -F -c fiemap $1 | grep hole | $SED_PROG 's/.*\[\(.*\)\.\.\(.*\)\].*/\1 \2/'
+	_mount $loop_dev $loop_mnt
 }
 
 get_free_sectors()
 {
 	case $FSTYP in
 	ext4)
+	$UMOUNT_PROG $loop_mnt
 	$DUMPE2FS_PROG $img_file  2>&1 | grep " Free blocks" | cut -d ":" -f2- | \
 		tr ',' '\n' | $SED_PROG 's/^ //' | \
 		$AWK_PROG -v spb=$sectors_per_block 'BEGIN{FS="-"};
@@ -195,6 +203,16 @@ while read line; do
 		END { if(found) exit 0; else exit 1}' $merged_sectors
 	then
 		echo "Sectors $from-$to are not marked as free!"
+
+		# Dump the state to make it easier to debug this...
+		echo free_sectors >> $seqres.full
+		sort -g < $free_sectors >> $seqres.full
+		echo fiemap_ref >> $seqres.full
+		sort -g < $fiemap_ref >> $seqres.full
+		echo merged_sectors >> $seqres.full
+		sort -g < $merged_sectors >> $seqres.full
+		echo fiemap_after >> $seqres.full
+		sort -g < $fiemap_after >> $seqres.full
 		exit
 	fi
 done < $fiemap_after
