From: Andreas Dilger <adilger@clusterfs.com>
Subject: simple block bitmap sanity checking
Date: Fri, 6 Jul 2007 12:48:56 -0600
Message-ID: <20070706184856.GA13812@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:56684 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283AbXGFStA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jul 2007 14:49:00 -0400
Received: from localhost.adilger.int (S01060004e23cfc51.ek.shawcable.net [24.66.76.119])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.clusterfs.com (Postfix) with ESMTP id BADB84E4594
	for <linux-ext4@vger.kernel.org>; Fri,  6 Jul 2007 12:48:58 -0600 (MDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

During a discussion at OLS, I came up with a very simple way of validating
the ext2/3/4 block bitmaps at read time.  Until such a time when we have
checksums for the bitmaps we can have a simple but quite robust mechanism
that is useful for ext2/3/4.

When a new block bitmap is read from disk in read_block_bitmap() there are a
few bits that should ALWAYS be set.  In particular, the blocks given by
desc->bg_block_bitmap, desc->bg_inode_bitmap, and the inode table in
[desc->bg_inode_table, +sbi->s_itb_per_group].  If those bits (shifted to be
relative to the current group, of course) are not set then the on-disk group
descriptor is corrupt, or there is some problem reading it from disk, and
this needs to generate an extN_error() call[*] to make the fs read-only.

A similar check can be done with the inode bitmap - it should have the
bits at the end of each bitmap set, for bits higher than s_inodes_per_group.

What I'm wondering is if anyone has time to implement this idea?  I'm
estimating it wouldn't be about 30 lines of simple code in total.

[*] This reminds me - we should make the default ext4 error behaviour be
    the safer "remount-ro" instead of the dangerous "continue".

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
