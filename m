From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V3 1/3] tune2fs: Make e2fsprogs handle ENOSPC better
	with inode resize
Date: Thu, 6 Aug 2009 11:48:58 +0530
Message-ID: <20090806061858.GA3344@skywalker>
References: <1249539151-3191-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48406 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZHFGTP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 02:19:15 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp06.au.ibm.com (8.14.3/8.13.1) with ESMTP id n766J84G004926
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 16:19:08 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n766JDVB454716
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 16:19:13 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n766JCTU000615
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 16:19:13 +1000
Content-Disposition: inline
In-Reply-To: <1249539151-3191-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I tested this series with the following usecase:

  a) using mkfs create a badblock map and see if the inode resize fail if
     it find a mapping blocks as bad block.
  b) On resizing inode if we find the mapping block having block bitmap
    or inode bitmap we make sure we find a block in the same group. Used
    debugfs set_bg to force a block bitmap after inode table.
  c) If not we fail the inode resize
  d) If we don't have enough space left we fail inode resize.


-aneesh
