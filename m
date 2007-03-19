From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC] e2fsprogs: Add ext4migrate
Date: Mon, 19 Mar 2007 15:05:37 +0530
Message-ID: <11742969394136-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:63811 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbXCSJfp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2007 05:35:45 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l2JLartX8401036
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 20:36:53 -0100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2J9dD3x174810
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 20:39:13 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2J9ZgwD030506
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 20:35:42 +1100
Received: from localhost.localdomain ([9.124.98.92])
	by d23av03.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l2J9Zege030429
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 20:35:41 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is work in progress

The below patches add ext4migrate utility that helps in migrating
a ext3 block mapped inode to ext4 extent mapped inode. I have split
the patches into two. They don't build individually. The purpose of
splitting the patches into two is to make the review easeir. The
contents of [PATCH 2/2] is derived out of kernel source.

ext4migrate command takes the below syntax
ext4migrate [--display | --migrate ] <image_name> <filename>

The --display option helps in displaying the block map details for an ext3 inode
and extent map details for an ext4 inode. The --migrate option convert a block mapped
ext3 inode to extent mapped ext4 inode.

This needs to be run on an unmounted file system (offline migration).

The extent insert code is derived out of the latest ext4 kernel source. I have tried
to keep the code as close as possible to the kernel sources. This makes sure that any
fixes for the tree building code in kernel should be easily applied to ext4migrate.
The ext3_ext naming convention instead of ext4_ext found in kernel is to
make  sure we are in sync with rest of e2fsprogs source.

The inode modification is done only at the last stage. This is to make sure that if we
fail at any intermediate stage, we exit without touching the disk. Another option I am thinking
is to copy the old mapping to a temporary inode. This makes sure that if by any chance the migration
fails partially writing to the disk one can retrieve the file using temporary inode.

The other alternative i am working on right now is to look at the online defragmentation
and see if that can be adapted to achieve online migration.

The patch applies on top of e2fsprogs found at

http://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/e2fsprogs-1.39-tyt1/e2fsprogs-1.39-tyt1.tar.bz2
