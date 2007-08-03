From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/4] e2fsprogs: Add undo I/O manager
Date: Fri, 3 Aug 2007 12:28:31 -0600
Message-ID: <20070803182831.GW6142@schatzie.adilger.int>
References: <11859824513552-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <f2c3823cb66c7a30436b1f2163cbe3bba791a115.1185981319.git.aneesh.kumar@linux.vnet.ibm.com> <20070801225247.GC5692@schatzie.adilger.int> <46B22340.5020709@linux.vnet.ibm.com> <20070802213728.GH6142@schatzie.adilger.int> <46B2B3E7.3030807@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40205 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbXHCS2c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 14:28:32 -0400
Content-Disposition: inline
In-Reply-To: <46B2B3E7.3030807@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 03, 2007  10:19 +0530, Aneesh Kumar K.V wrote:
> Andreas Dilger wrote:
> >I thought about this also, but in fact for most uses of the undo manager
> >we want to save the information at the start instead of the end, so it
> >is possible to undo e.g. a partial e2fsck that crashes before it finishes.
> >Only with mke2fs (and, I guess tune2fs -U) does the UUID change at the
> >end.
> 
> I am not sure whether saving the information at start is needed. I 
> understand that what we are looking for is the case when the application
> crashes without doing a io_channel_close. In that case i would say the
> user can use the --force option and replay the data from the tdb file.
> The UUID could very well be changed on the disk before the application
> crashed. So even if we save UUID at the start, there are cases where it
> won't match with the disk UUID.

While this is true, I don't think it is harmful to save the UUID at the
start.  The UUID changing is the rare case, so to make this safer saving
the UUID at the start and the end is best.

> That actually brings me to another change. I would be moving the block size
> recording changes from write_file_system_identity to a separate function 
> and will be calling it at the first write.

Definitely, yes.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
