From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC][take 4] e2fsprogs: Add ext4migrate
Date: Fri,  4 May 2007 14:43:20 +0530
Message-ID: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:42511 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767756AbXEDJNd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 05:13:33 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l449FGeC6099000
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:15:17 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l449GxqK166082
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:17:00 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l449DRkQ008991
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:13:28 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is work in progress


Changes from from my previous patches are as follows:
a) COW unix io manager using libtdb
b) add ext4replay to  undo the file system changes done during migration

Changes from from my previous patches are as follows:
a) Mark the file system unclean if we fail migrating
b) support for migrating more than one file
c) Support for migrating all the ext3 inode in the file system
d) Fix the free block counts. ( Make sure fsck pass without errors after migration )
e) Mark the blocks used for extent idx as used so that we don't double allocate them
f) Don't mark the blocks used for indirect block map as free untill we fully migrate
   the inode.This make sure we don't use these blocks for extent idx and overwrite them.
g) Fix the migration when we end up with more than one extent idx block.


Changes from from my previous patches are as follows:
a) support for files with holes
b) use the block iterator present in libext2fs
c) don't mark  the indirect blocks as unused early. If we mark the
   the blocks unused, they can be resued for extent index. If we later
   fail to migrate, the indirect blocks content would be overwritten.

ext4migrate command takes the below syntax
ext4migrate --display | --migrate  <image_name> [<filename>]

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
b) Writ the update block bitmap. if failed exit.
b) Write the inode. if failed Undo the write of block bitmap and exit.

The patch applies on top of e2fsprogs found at

http://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/e2fsprogs-1.39-tyt1/e2fsprogs-1.39-tyt1.tar.bz2

Right now i am building ext4migrate and ext4replay by linking against libtd. This will not
be needed once I rebase the patches against the latest e2fsprogs which has the tdb code
available as a part libext2fs

-aneesh
