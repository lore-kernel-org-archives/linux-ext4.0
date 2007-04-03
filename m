From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC][take 2] e2fsprogs: Add ext4migrate
Date: Tue,  3 Apr 2007 15:37:23 +0530
Message-ID: <11755948452525-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:50196 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966157AbXDCKH7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Apr 2007 06:07:59 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l33A9oCJ5230838
	for <linux-ext4@vger.kernel.org>; Tue, 3 Apr 2007 20:09:51 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l33AB6UP155252
	for <linux-ext4@vger.kernel.org>; Tue, 3 Apr 2007 20:11:14 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l33A7XBm025902
	for <linux-ext4@vger.kernel.org>; Tue, 3 Apr 2007 20:07:33 +1000
Received: from localhost.localdomain (K50wks273925wss.in.ibm.com [9.124.35.87])
	by d23av04.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l33A7SSK025812
	for <linux-ext4@vger.kernel.org>; Tue, 3 Apr 2007 20:07:29 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is work in progress


Changes from from my previous patches are as follows:


a) support for files with holes
b) use the block iterator present in libext2fs
c) don't mark  the indirect blocks as unused early. If we mark the
   the blocks unused, they can be resued for extent index. If we later
   fail to migrate, the indirect blocks content would be overwritten.

The below patches add ext4migrate utility that helps in migrating
a ext3 block mapped inode to ext4 extent mapped inode. I have split
the patches into two. The purpose of splitting the patches into two
is to make the review easeir. The contents of [PATCH 1/2] is derived out of kernel source.

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
fail at any intermediate stage, we exit without touching the disk.

The inode update is done as below
a) Walk the extent index blocks and write them to the disk. If failed exit
b) Write the inode. if failed exit.
c) Write the updated block bitmap. if failed exit ( This could be a problem because
   we have already updated the inode i_block filed to point to new blocks.). But such
   inconsistancy between inode i_block and block bitmap can be fixed by fsck IIUC.


With the above understanding i am not having a backup temporary inode during migration,
because even if we fail during migration we can recover the file contents.

The patch applies on top of e2fsprogs found at

http://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/e2fsprogs-1.39-tyt1/e2fsprogs-1.39-tyt1.tar.bz2

-aneesh
