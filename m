From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] ext4: collapse a single extent tree block into the
 inode if possible
Date: Thu, 9 Aug 2012 09:07:54 -0400
Message-ID: <20120809130754.GB4511@thunk.org>
References: <1344516283-4430-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43802 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab2HINH5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Aug 2012 09:07:57 -0400
Content-Disposition: inline
In-Reply-To: <1344516283-4430-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's a test script which demonstrates how we can up with an external
extent tree block containing a single extent.  It needs to run as root
since it will be mounting a test file system image on /mnt.


#!/bin/bash
fs=/u1/test-fs.img
num=128
max=$(expr $num \* 8)
size=$(expr $num \* 32)k

dd if=/dev/zero of=$fs bs=4k count=$(expr $max \* 4)

mke2fs -t ext4 -b 4096 -qF $fs
mount -t ext4 $fs /mnt

cd /mnt
fallocate -l $size test-file
for i in $(seq 0 8 $max | sed -e '$d') ; do
	dd if=/dev/zero of=test-file conv=notrunc,nocreat bs=4k \
	   seek=$i count=1 > /dev/null 2>&1
done
sync

dd if=/dev/zero of=test-file conv=notrunc,nocreat \
	bs=4k count=$max > /dev/null 2>&1
sync
cd /

umount /mnt
debugfs $fs -R "stat test-file"

