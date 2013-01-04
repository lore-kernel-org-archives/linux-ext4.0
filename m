From: Darren Hart <dvhart@infradead.org>
Subject: [PATCH 0/3 V2] ext2fsprogs: Symlink support
Date: Fri,  4 Jan 2013 12:00:57 -0800
Message-ID: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
Cc: tytso@mit.edu, adilger@dilger.ca, sgw@linux.intel.com,
	darrick.wong@oracle.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54045 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3ADUBU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 15:01:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following series adds symlink support the libext2fs and adds the command to
debugfs. Basic testing demonstrates functional duplication of a small test
directory including fastlinks and slowlinks in both the root and a single
subdirectory.

There is one FIXME/question remaining in the symlink implementation regarding
the use of ext2fs_bmap2 where I would particularly welcome some review. I found
the various block creation, allocation, and bitmap functions to be rather
difficult to grok in terms of which to use when.

Otherwise, I believe I have addressed Ted's and Darrick's comments from the
previous RFC.

Thanks,

Darren Hart
Intel Open Source Technology Center


