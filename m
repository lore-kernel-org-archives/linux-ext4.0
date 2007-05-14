From: Andreas Dilger <adilger@clusterfs.com>
Subject: [RFC] extent whiteouts
Date: Mon, 14 May 2007 17:08:08 -0600
Message-ID: <20070514230808.GA5581@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:57548 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbXENXIJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2007 19:08:09 -0400
Received: from localhost.adilger.int (S0106000bdb95b39c.cg.shawcable.net [70.72.213.136])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.clusterfs.com (Postfix) with ESMTP id 82E4E4E456C
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 17:08:09 -0600 (MDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For snapshot filesystems and in some cases where it is expected to do tree
rebalancing it would be desirable to allow a "whiteout" for an extent.  That
means the extent would be present in the tree, and would explicitly list
the data blocks as a "hole" (i.e. ee_start == 0).  This is useful because
it avoids the need to search all of the "backing" inodes to see if there is
allocated data, and it also handles the case where the new file is truncated
and extended (leaving a hole) but there is still data in the backing file.

Since block == 0 is not a valid data for ext3 it should never happen,
and if it ever did happen it would be better to return all zeros (and
not allow writing to the extent) instead of overwriting the superblock).

This would need some special casing in the extent code, but it probably
would not be much different than what is currently the case for preallocated
extents, and it would be a good time to add this in along with the
preallocated extents.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
