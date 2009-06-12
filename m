From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Fallocate and DirectIO
Date: Fri, 12 Jun 2009 18:01:12 +0530
Message-ID: <20090612123112.GB25239@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49403 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZFLMb1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jun 2009 08:31:27 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id n5CCTQiJ012758
	for <linux-ext4@vger.kernel.org>; Fri, 12 Jun 2009 22:29:26 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5CCVN4v565354
	for <linux-ext4@vger.kernel.org>; Fri, 12 Jun 2009 22:31:28 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5CCVNV8013119
	for <linux-ext4@vger.kernel.org>; Fri, 12 Jun 2009 22:31:23 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I noticed yesterday that a write to fallocate
space via directIO results in fallback to buffer_IO. ie the userspace
pages get copied to the page cache and then call a sync.

I guess this defeat the purpose of using directIO. May be we should
consider this a high priority bug.

-aneesh
