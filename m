From: Andreas Dilger <adilger@clusterfs.com>
Subject: seekwatcher IO visualization
Date: Thu, 9 Aug 2007 14:53:55 -0600
Message-ID: <20070809205355.GB6689@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:51454 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbXHIUxx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Aug 2007 16:53:53 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I saw on #linuxfs today some graphs and movies by Chris Mason showing
the poor IO locality for ext3 compared to btrfs and XFS.  It would be
interesting to run this with ext4+mballoc+delalloc, and a separate
one with the FLEXBG feature enabled to see how that improves the
seeking/locality.

http://oss.oracle.com/~mason/seekwatcher/

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
