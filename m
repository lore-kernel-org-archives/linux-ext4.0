From: Gary Hawco <ghawco@cox.net>
Subject: Segmentation Faults with 062508 ext4-patch-queue snapshot
Date: Wed, 25 Jun 2008 13:53:40
Message-ID: <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Mingming <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao104.cox.net ([68.230.241.42]:62091 "EHLO
	fed1rmmtao104.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYFYUxl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jun 2008 16:53:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I redid my tests on the last few ext-patch-queue snapshots.

The snapshot:
ext4-patch-queue-476b1104923c2228b48aee73070cddd5430b3b54.tar.gz from
062408 @2256hrs GMT works fine. No segfaults.

The latest snapshot:
ext4-patch-queue-b5db22ef52ed53d8e3fa978a5a29e1609c9333aa.tar.gz from 
062508 @ 0019hrs GMT causes segmentation faults whenever I do extensive
copying of small files (my Gentoo portage tree & metadata cache folders) to
another ext4dev partition set up identically and then when I make a tarball
from this copied data.

I have been able to reproduce the segfaults consistently. Both partitions
were formatted with flex_bg & meta_bg features enabled (obviously no
resize_inodes) and are set for ordered data mode.

I assume delalloc is enabled although ext4-patch-queue does not yet print
message saying so on boot like mballoc does.

Any suggestions would be most appreciated.

Thanks,
Gary



