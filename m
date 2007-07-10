From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Initial results of FLEX_BG feature.
Date: Tue, 10 Jul 2007 11:23:07 -0500
Message-ID: <20070710112307.34c2ba5c@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46716 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761147AbXGJQ1X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 12:27:23 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AGRMag023060
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 12:27:22 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AGRMHf510932
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 12:27:22 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AGRM8v024960
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 12:27:22 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l6AGRMVU024953
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 12:27:22 -0400
Received: from rx8 (rx8.austin.ibm.com [9.41.41.30])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l6AGRLtq030814
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 11:27:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi folks,

I've started playing with the FLEX_BG feature (for now packing of
block group metadata closer together) and started doing some
preliminary benchmarking to see if the feature is worth pursuing.
I chose an FFSB profile that does single threaded small creates and
writes and then does an fsync.  This is something I ran for a customer
a while ago in which ext3 performed poorly.

Here are some of the results (in transactions/sec@%CPU util) on a single
143GB@10K rpm disk.

ext4				1680.54@2.9%
ext4(flex_bg)			2105.56@3.7% 20% improvement
ext4(data=writeback)		1374.50@2.0% <- hum...
ext4(flex_bg data=writeback)	2323.12@3.7% 28% over best ext4
ext3				1025.84@1.7%
ext3(data=writeback)		1136.85@1.7%
ext2				1152.59@0.9%
xfs				1968.84@1.9%
jfs				1424.05@1.2%

The results are from packing the metadata of 64 block groups closer
together at fsck time.  Still need to clean up the e2fsprog patches,
but I hope to submit them to the list later this week for others to
try.  It seems like fsck doesn't quite like the new location of the
metadata and I'm not sure how big of an effort it will be to fix it.  I
mentioned this since one of the assumptions of implementing FLEX_BG was
the reduce time in fsck and it could be a while before I'm able to test
this.

-JRS
