From: Andreas Dilger <adilger@clusterfs.com>
Subject: ext4-delalloc-extents-48bit.patch
Date: Fri, 8 Jun 2007 16:47:26 -0600
Message-ID: <20070608224726.GA32480@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:48603 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbXFHWr3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jun 2007 18:47:29 -0400
Received: from localhost.adilger.int (S0106000bdb95b39c.cg.shawcable.net [70.72.213.136])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.clusterfs.com (Postfix) with ESMTP id A23C37BA3B1
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2007 16:47:28 -0600 (MDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I just noticed while looking through ext4-delalloc-extents-48bit.patch in
git that it is doing all of the bit shifting explicitly, instead of using
the ext_pblock() and ext_store_pblock() helpers...

It also appears that some of the extent code is using "ee_len" directly
instead of the ext4_get_actual_len() helper to mask off the unwritten
extent flag (e.g. delalloc_extents*.patch).  I wonder if we should change
the ee_len type so that it isn't easy to access it directly (e.g. put it
inside a named union) so this mistake is visible more easily in the future.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
