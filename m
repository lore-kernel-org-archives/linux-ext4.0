From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Should we enabling mballoc by default ?
Date: Wed, 9 Jan 2008 23:39:06 +0530
Message-ID: <20080109180906.GB8259@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@mit.edu>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:43165 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbYAISJi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 13:09:38 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m09I9LBM024511
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 05:09:21 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m09I9aYa418042
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 05:09:36 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m09I9KuQ011733
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 05:09:20 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

mballoc currently causes fragmentation of small size files. The
behaviour can be observed by running parallel dd on ext4 file system. A
sample test case can be found here.

http://www.radian.org/~kvaneesh/ext4/mballoc-frag/fragmentation-analysis

This is because for small size request/file mballoc uses group prealloc
space. That means if you have singe cpu and multiple threads doing
parallel io to the file the block request are served from the same
prealloc space. This results in the fragmentation observed above. (Group
prealloc space is per cpu )

This problem should go away with delayed allocation because the write
out happens with multiple blocks and mballoc places then close together
even though they get served by the same group prealloc space.
Considering that we don't have delalloc yet, i guess we should push
mballoc to 2.6.25 with default disabled and O_DIRECT type workloads can
enabled then via mount option.


-aneesh
