From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH 7/9]ext4: Add the EXT4_IOC_FIEMAP_INO ioctl
Date: Sun, 26 Oct 2008 02:40:48 -0600
Message-ID: <20081026084048.GF3184@webber.adilger.int>
References: <49019EF6.4000706@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Mingming Cao <cmm@us.ibm.com>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35566 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYJZIlD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Oct 2008 04:41:03 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m9Q8f1Fv029898
	for <linux-ext4@vger.kernel.org>; Sun, 26 Oct 2008 01:41:01 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K9C00L0180F6F00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 26 Oct 2008 01:41:00 -0700 (PDT)
In-reply-to: <49019EF6.4000706@rs.jp.nec.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 24, 2008  19:09 +0900, Akira Fujita wrote:
> The EXT4_IOC_FIEMAP_INO is used to get extents information of
> inode which set to ioctl.
> The defragger uses this ioctl to check the fragment condition
> and to get extents information in the specified block group.

Instead of having a separate IOC number for each such ioctl, instead
we implemented EXT4_IOC_WRAPPER, which is an root-specific ioctl that
passes in an inode number and a second IOC number so that arbitrary file
ioctls can be run on any inode by root.

This was mentioned last time these patches were posted, but there was
no reply from you.  Christoph suggested a more generic VFS open-by-inum,
which isn't impossible to do but would cause a lot of controversy I
think, while the EXT4_IOC_WRAPPER is at least contained within ext4,
but is more generically useful than EXT4_IOC_FIEMAP_INO.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

