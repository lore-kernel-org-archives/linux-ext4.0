From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH RFC 0/6] add full off-line resize2fs support for flex_bg file systems
Date: Sat, 29 Dec 2012 03:55:22 -0500
Message-ID: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40806 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab2L2Izg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 03:55:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This addresses the corruption problems reported by George Spelvin when
we created a file system with a non-default number of reserved gdt
blocks using the -E resize=NNN option.  It does this by adding full
support for flex_bg file systems, so that we don't have to worry about
allocating overlapping metadata tables while we are growing the number
of block group descriptor blocks, in the case where the resize inode
does not have enough reserved blocks, or is not present altogether.

Theodore Ts'o (6):
  mke2fs: fix crash when parsing "-E resize=NNN" with "-O 64bit"
  resize2fs: reserve fs metadata blocks first in blocks_to_move()
  resize2fs: reserve all metadata blocks for flex_bg file systems
  resize2fs: handle bg descriptors which overlap with other bg's
    metadata
  resize2fs: allow resizing flex_bg && !resize_inode file systems
  resize2fs: create optimized flex_bg block groups

 misc/mke2fs.c      |   8 +++++
 resize/main.c      |  22 ------------
 resize/resize2fs.c | 102 ++++++++++++++++++++++++++++++++++-------------------
 3 files changed, 73 insertions(+), 59 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

