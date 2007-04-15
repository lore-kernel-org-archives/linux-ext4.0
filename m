From: Andreas Dilger <adilger@clusterfs.com>
Subject: Missing JBD2_FEATURE_INCOMPAT_64BIT in ext4
Date: Sun, 15 Apr 2007 10:16:06 -0600
Message-ID: <20070415161606.GG5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:48714 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbXDOQQJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Apr 2007 12:16:09 -0400
Received: from localhost.adilger.int (S01060004e23cfc51.cg.shawcable.net [68.147.252.160])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.clusterfs.com (Postfix) with ESMTP id 5955E4E457D
	for <linux-ext4@vger.kernel.org>; Sun, 15 Apr 2007 10:16:08 -0600 (MDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Just a quick note before I forget.  I thought there was a call in ext4
to set JBD2_FEATURE_INCOMPAT_64BIT at mount time if the filesystem has
more than 2^32 blocks?  I don't see that anywhere in the 2.6.20 ext4.
Is that in the upstream git repo?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
