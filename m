From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: ext4 roadmap
Date: Wed, 01 Nov 2006 17:16:37 -0600
Message-ID: <1162422997.13777.35.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:17800 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750989AbWKAXQm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Nov 2006 18:16:42 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA1NGdYb008368
	for <linux-ext4@vger.kernel.org>; Wed, 1 Nov 2006 18:16:39 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA1NGdNX125450
	for <linux-ext4@vger.kernel.org>; Wed, 1 Nov 2006 18:16:39 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA1NGcr9021931
	for <linux-ext4@vger.kernel.org>; Wed, 1 Nov 2006 18:16:38 -0500
Received: from kleikamp.austin.ibm.com (kleikamp.austin.ibm.com [9.53.41.164])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kA1NGcEL021917
	for <linux-ext4@vger.kernel.org>; Wed, 1 Nov 2006 18:16:38 -0500
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It has been discussed in the conference call that we need to better
define the requirements for ext4 and set some kind of target for when
new function should be added, so we can then work on stabilizing the
code and getting it production-ready.  The list below is based on the
candidate features list in Documentation/filesystems/ext4.txt.  It is by
no means complete, as some other ideas are being floated around, and I
very well may have missed some features.

I plan to put this in a wiki, but I'm not sure what the best place is.
Neither http://fedoraproject.org/wiki/ext3-devel nor
https://mail.clusterfs.com/wikis/lustre/Ext3Development has been kept up
to date, but I'd be happy to use either.

Here's something to start with:

Multiblock Allocation
---------------------
Primary developer: Alex Tomas
Status:	Patches available
Changes on-disk format: No
Target Date: ?
e2fsprogs changes: No

Delayed Allocation
------------------
Primary developer: Alex Tomas
Status:	Patches available
Changes on-disk format: No
Target Date: ?
e2fsprogs changes: No

Break 32000 subdirectory limit
------------------------------
Primary developer: Andreas? Ted?
Status:	Patches available
Changes on-disk format: Yes
Target Date: ?
e2fsprogs changes: Needed

nsec timestamps
---------------
Primary developer: Andreas? Alex?
Status: Patches available
Change on-disk format: Yes
Target Date: ?
e2fsprogs changes: Needed

inode version on disk
---------------------
Primary developer: ?
Status: Prototype available
Change on-disk format: Yes
Target Date: ?
e2fsprogs changes: Needed

uninitialized groups
--------------------
Primary developer: ?
Status: Prototype available
Change on-disk format: Yes
Target Date: ?
e2fsprogs changes: Needed

journal checksumming
--------------------
Primary developer: Andreas?
Status: Prototype available
Change on-disk format: Yes
Target Date: ?
e2fsprogs changes: Needed

persistent preallocation
------------------------
Primary developer: Suparna?
Status: In development
Change on-disk format: Yes
Target Date: ?
e2fsprogs changes: Needed

-- 
David Kleikamp
IBM Linux Technology Center
