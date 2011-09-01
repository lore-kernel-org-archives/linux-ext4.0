From: Chen Huan <chenhuan@nrchpc.ac.cn>
Subject: e2fsck aborts when invalid indirect block is encountered
Date: Thu, 1 Sep 2011 14:34:10 +0800
Message-ID: <20110901063410.GA8313@notebook.chenhuan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [221.122.61.228] ([221.122.61.228]:45962 "EHLO mx.nrchpc.ac.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751097Ab1IAHTf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Sep 2011 03:19:35 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, All.

During a recent read-only checking of an corrupted ext3 file system,
I found a strange behaviour of e2fsck: when an inode has an invalid
indirect block number, e2fsck aborts with the following message:

    e2fsck 1.39 (29-May-2006)
    Pass 1: Checking inodes, blocks, and sizes
    Inode 12 has illegal block(s).  Clear? no

    Illegal block #-1 (4294967295) in inode 12.  IGNORED.
    Error while iterating over blocks in inode 12: Illegal indirect block found
    e2fsck: aborted

You can reproduce it with this code snippet:

    #!/bin/sh

    dev=/dev/sde
    mnt=/mnt

    mkfs.ext3 -F $dev
    mount $dev $mnt
    dd if=/dev/zero of=$mnt/file bs=1M count=1
    umount $dev
    debugfs -w -R 'sif file block[IND] 0xFFFFFFFF' $dev
    e2fsck -f -n $dev

Doing a fixing without -n option can safely delete this bad blocknum.

My question is: Is this behaviour a bug or intended?
