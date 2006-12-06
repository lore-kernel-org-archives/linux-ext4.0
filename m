From: Avantika Mathur LTC <mathur@us.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Dec. 6 2006)
Date: Wed, 06 Dec 2006 14:07:18 -0800
Message-ID: <45773F16.8020202@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:57111 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937707AbWLFWHn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Dec 2006 17:07:43 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kB6M7dt3005876
	for <linux-ext4@vger.kernel.org>; Wed, 6 Dec 2006 17:07:39 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kB6M7dMc488832
	for <linux-ext4@vger.kernel.org>; Wed, 6 Dec 2006 15:07:39 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kB6M7d89017750
	for <linux-ext4@vger.kernel.org>; Wed, 6 Dec 2006 15:07:39 -0700
Received: from [127.0.0.1] (IBM-DD6E2EC41B8.beaverton.ibm.com [9.47.16.74])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kB6M7bO0016731
	for <linux-ext4@vger.kernel.org>; Wed, 6 Dec 2006 15:07:38 -0700
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 12-6-06 Minutes

Attendees: Mingming Cao, Suparna Bhattacharya, Jean-Pierre Dion, Val=E9=
rie=20
Cl=E9ment, Shaggy, Takashi Sato, Eric Sandeen, Linda Wang

- Preallocation patches
 -- submitted by Amit Arora, implement the creation of the initialized=20
extent, using ioctl interface.
 -- The part of recognizing the initialized extent is written
 -- Still need part of writing to the preallocated extent.
 -- Amit has also written changes to e2fsprogs to recognize the=20
preallocated extent
 -- Currently will keep the ioctl interface and see of there are=20
comments on the mailing list.

- Big Block Group patches
 -- Ted and Andreas have commented on Val=E9rie's patches, they are=20
concerned about not being able to allocate a contiguous range of blocks=
=20
for the allocation bitmaps.

- Currently all block group descriptors are stored in the first block=20
group. The current 128 byte block group size limits the filesystem size=
=20
to 256 TB.
 -- The big block group patches will extend the maximum filesystem size=
=20
limit
 -- An alternative is to move the block descriptors, so the the=20
filesytem size is not limited by the size of the block group.  Metabloc=
k=20
groups may could be used in the solution

- Alex Tomas posted delayed allocation, multiple block allocation, in=20
kernel preallocation, and block reservation patches last week.

- Takashi has updated the defrag patches to support quotas and will loo=
k=20
for comments on the mailing list.

- Wiki:  the ext4 wiki is at ext4.wiki.kernel.org; we will start adding=
=20
to the wiki and keeping it up to date.

thanks
Avantika
