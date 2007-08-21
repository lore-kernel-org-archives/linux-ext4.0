From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Adding META_BG/FLEX_BG awareness to inode allocator.
Date: Tue, 21 Aug 2007 16:44:06 -0500
Message-ID: <20070821164406.2eec74db@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:52736 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbXHUVoi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Aug 2007 17:44:38 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7LLiaXK007012
	for <linux-ext4@vger.kernel.org>; Tue, 21 Aug 2007 17:44:36 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7LLiZxl218320
	for <linux-ext4@vger.kernel.org>; Tue, 21 Aug 2007 15:44:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7LLiZF4014301
	for <linux-ext4@vger.kernel.org>; Tue, 21 Aug 2007 15:44:35 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Andreas, Ted,

I've been looking at the uninitialized block group patches to see how
they overlap with the uninitialized inode tables that I was looking
into for FLEX_BG and I think I can achieve the same thing using those
patches.  One of the things I wanted to achieve with uninitialized
inode tables was to pack inode for the same META/FLEX_BG and allocate
new inode tables as we ran out a pre-initialized inodes.  This is
something that applies to FLEX_BG since the layout of the meta-data has
changed.

It seams that the only thing that would prevent the uninitialized block
group patches from doing this is ialloc.c unawareness of
META_BG/FLEX_BG.  It seems like this is a good excuse to make inode and
block allocation algorithms aware of the new meta-data layout.

I could add META_BG/FLEX_BG awareness and see how the
allocation/initialization of inode changes and also see what sort of
performance impacts we see by these changes. 

Thoughts?

-JRS
