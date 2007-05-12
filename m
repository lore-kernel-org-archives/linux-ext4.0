From: Andreas Dilger <adilger@clusterfs.com>
Subject: [RFC] store RAID stride in superblock
Date: Fri, 11 May 2007 19:02:48 -0700
Message-ID: <20070512020248.GQ6375@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:34357 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbXELCCu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 May 2007 22:02:50 -0400
Received: from localhost.adilger.int (unknown [64.166.152.82])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.clusterfs.com (Postfix) with ESMTP id D54AD7BA307
	for <linux-ext4@vger.kernel.org>; Fri, 11 May 2007 20:02:49 -0600 (MDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It is possible to specify the RAID stride to mke2fs allow it to optimize
the layout of the bitmaps.  With the new mballoc it is also possible to
tell it via a mount option to do large allocations aligned on the RAID
stride (by default it aligns on 1MB boundaries from the start of the LUN).

What would be rather convenient is to store the RAID stride value in the
superblock.  That would spare a lot of hassle on the part of the admin
to tune the filesystem optimally for the underlying storage.  There is
also a library used in the XFS tools that knows how to probe various
kinds of block devices (e.g. MD RAID, LVM/DM, etc) to get their storage
layout that would avoid the need for the user to specify anything.

Any thoughts on this?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
