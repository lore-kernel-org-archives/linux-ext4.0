From: Eric Sandeen <sandeen@redhat.com>
Subject: More testing: 4x parallel 2G writes, sequential reads
Date: Wed, 07 Nov 2007 16:42:59 -0600
Message-ID: <47323F73.5080708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbXKGWnD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 17:43:03 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA7Mh1V0001604
	for <linux-ext4@vger.kernel.org>; Wed, 7 Nov 2007 17:43:01 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lA7Mh1Yr017595
	for <linux-ext4@vger.kernel.org>; Wed, 7 Nov 2007 17:43:01 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id lA7Mgxk2004134
	for <linux-ext4@vger.kernel.org>; Wed, 7 Nov 2007 17:43:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I tried ext4 vs. xfs doing 4 parallel 2G IO writes in 1M units to 4
different subdirectories of the root of the filesystem:

http://people.redhat.com/esandeen/seekwatcher/ext4_4_threads.png
http://people.redhat.com/esandeen/seekwatcher/xfs_4_threads.png
http://people.redhat.com/esandeen/seekwatcher/ext4_xfs_4_threads.png

and then read them back sequentially:

http://people.redhat.com/esandeen/seekwatcher/ext4_4_threads_read.png
http://people.redhat.com/esandeen/seekwatcher/xfs_4_threads_read.png
http://people.redhat.com/esandeen/seekwatcher/ext4_xfs_4_read_threads.png

At the end of the write, ext4 had on the order of 400 extents/file, xfs
had on the order of 30 extents/file.  It's clear especially from the
read graph that ext4 is interleaving the 4 files, in about 5M chunks on
average.  Throughput seems comparable between ext4 & xfs nonetheless.

Again this was on a decent HW raid so seek penalties are probably not
too bad.

-Eric
