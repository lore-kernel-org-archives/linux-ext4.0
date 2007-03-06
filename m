From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: e2fsck and human intervention
Date: Tue, 6 Mar 2007 10:40:24 +0800
Message-ID: <20070306024024.GZ6662@schatzie.adilger.int>
References: <1173112017.6300.14.camel@systems03.mmm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daniel Drake <ddrake@brontes3d.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:57308 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865AbXCFCk3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2007 21:40:29 -0500
Content-Disposition: inline
In-Reply-To: <1173112017.6300.14.camel@systems03.mmm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 05, 2007  11:26 -0500, Daniel Drake wrote:
> This usually happens during e2fsck's regular "check every X mounts"
> thing, as opposed to immediately after booting up after power loss, so
> to begin with it's not immediately obvious why there is a problem.

That's because the post-boot e2fsck will only check the superblock and
replay the journal.  It won't do a full check of the filesystem unless
the kernel detected some corruption and marked an error in the superblock.

That is the primary reason why the "check after N mounts/months" code
is in e2fsck, even though it annoys some people.

> It's of course understandable and inevitable that power loss will
> occasionally cause some file loss or corruption, and that's fine.

As Ted said, if e2fsck detects anything wrong then this IS corruption
of some kind.  It might indicate that your disks are writing with
cache enabled and losing some writes that had been reported to the
kernel as committed to disk.

> Are there any better approaches than something like the following?
> 
> 1. Run "e2fsck -p /"
> 
> 2. If bit 3 is set in exit code (i.e. preen functionality detected
> unexpected inconsistency) then run "e2fsck -y /"

This is no better than just running "e2fsck -y" in the first place,
just twice as slow.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
