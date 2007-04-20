From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH] e2fsprogs: Offsets of EAs in inode need not be sorted
Date: Fri, 20 Apr 2007 18:35:41 +0530
Message-ID: <1177074341.7371.19.camel@garfield>
References: <1176984336.3812.10.camel@garfield>
	 <20070420123832.GB18529@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:59081 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992772AbXDTNEI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Apr 2007 09:04:08 -0400
In-Reply-To: <20070420123832.GB18529@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-04-20 at 08:38 -0400, Theodore Tso wrote:
> On Thu, Apr 19, 2007 at 05:35:36PM +0530, Kalpak Shah wrote:
> > Hi,
> > 
> > This patch removes a code snippet from check_ea_in_inode() in pass1
> > which checks if the EA values in the inode are sorted or not. The
> > comments in fs/ext*/xattr.c state that the EA values in the external
> > EA block are sorted but those in the inode need not be sorted. I
> > have also attached a test image which has unsorted EAs in the
> > inodes. The current e2fsck wrongly clears the EAs in the inode.
> 
> Hmm, have you been able to create test images that have unsorted EA's
> in inodes using a standard ext3 kernel implementat?  If so, then this
> is a patch which we should push to the distro's since it could cause
> data loss, and cause serious malfunctions, especially for people who
> have SELinux enabled and are using large inodes for the EA-in-inode
> feature....

Hi,

I saw this problem when I was running a script which created a random
number of EAs for a file of random sizes. If you mount the image I have
given, all the EAs are displayed and they can be used/modified/deleted
without any problems so its not a bug in ext3 code.

Thanks,
Kalpak.

> 
> 						- Ted
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
