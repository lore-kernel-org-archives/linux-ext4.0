From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Some interesting input from a flash manufacturer
Date: Fri, 02 Mar 2012 16:00:00 -0500
Message-ID: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38964 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab2CBVAK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2012 16:00:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I spent an hour talking to architecture guy from a major flash
manufacturer, who makes everything from SSD's to SD cards to eMMC
devices, and he said a few things that were interesting.

One is that he would actually be very happy if we send lots of extra
trim commands; in particular, he would actually *like* us to send trims
at unlink/commit time, *and* trims periodically via FITRIM.  The reason
for that is because that way, if the disk is busy, it would be OK if he
dropped the TRIM on the floor, knowing that he would get another bite at
the apple later on.  But, if the disk has time to process the trim, he
he would be able to use that information as quickly as possible.

One of the other things we talked about was it would be really nice if
we could send TRIM commands at journal checkpoint time, and perhaps send
checkpoints more aggressively (although the requirement to send a
SYNCHORNIZE CACHE command may make this be too expensive, unless we have
ways of reliably knowing when the disk is idle, since unlike the
enterprise server case, when ext4 is used in a mobile device, the fs
accesses patterns tend to have more gaps where this sort of maintenance
can take place).

We also talked about ways that we might right some application notes so
that handset OEM's understood how to use mke2fs parameters to optimize
their file systems for different types of flash systems, and perhaps
ways that the eMMC spec could be enhanced so that key parameters such as
erase block size, flash page size, and translation table granularity
could be passed back to the block layer, and made available to file
system and mkfs.

Anyway, going back to TRIM, I suspect that efforts to optimize out TRIM
requests may not make as much sense once we have devices with are SATA
3.1 complaint, when we will have a queuable TRIM command.  Also,
presumably SATA 3.1 compliance devices are less likely to have
disastrous firmware bugs that make TRIM such a performance dog, and in
fact they may be devices that would very much like as much TRIM
information as we are willing to send to them.

Regards,

						- Ted
