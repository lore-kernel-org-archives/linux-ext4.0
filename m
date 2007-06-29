From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC] BIG_BG vs extended META_BG in ext4
Date: Fri, 29 Jun 2007 17:09:58 -0500
Message-ID: <20070629170958.13b7700c@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54938 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbXF2WLH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jun 2007 18:11:07 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5TMB6x9018936
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jun 2007 18:11:06 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5TMB64T263498
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jun 2007 18:11:06 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5TMB6lU024347
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jun 2007 18:11:06 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l5TMB5bV024339
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jun 2007 18:11:05 -0400
Received: from gara (sig-9-65-2-100.mts.ibm.com [9.65.2.100])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l5TMB5UV032484
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jun 2007 17:11:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi folks,

I've been looking at getting around some of the limitations imposed by
the block groups and was wondering what are peoples thoughts about
implementing this using either bigger block groups or storing the
bitmaps and inode tables outside of the block groups.  

I think the BIG_BG feature is better suited to the design philosophy of
ext2/3.  Since all the important meta-data is easily accessible thanks
to the static filesystem  layout, I would expect for easier fsck
recovery.  This should also provide with some performance improvements
for both extents (allowing each extent to be larger than 128M) as well
as fsck since bitmaps would be place closer together.

An extended version of metadata block group could provide better
performance improvements during fsck time since we could pack all of
the filesystem bitmaps together.  Having the inode tables separated
from the block groups could mean that we could implement dynamic inodes
in the future as well.  This feature seems like it would be more
invasive for e2fspros at first glance (at least for fsck).  Also, with
no metadata in the block groups, there is essentially no need to have a
concept of block groups anymore which would mean that this is a
completely different filesystem layout compared to ext2/3.

Since I have not much experience with ext4 development, I was wondering
if anybody had any opinion as to which of these two methods would
better serve the need of the intended users and see which one would be
worth to prototype first.

Comments?


-JRS
