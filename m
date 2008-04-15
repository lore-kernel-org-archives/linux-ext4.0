From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Ininitial e2fsprogs TODO list (please expand)
Date: Tue, 15 Apr 2008 11:52:16 -0500
Message-ID: <20080415115216.1f6868de@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36300 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368AbYDOQwk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2008 12:52:40 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3FGqbQB008215
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 12:52:37 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3FGqb37168712
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 12:52:37 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3FGqbJw026181
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 12:52:37 -0400
Received: from gara.konoha.net (wecm-9-67-160-152.wecm.ibm.com [9.67.160.152])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m3FGqai8026123
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 12:52:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As discuss on the call yesterday, some folks (my self included) really
want a TODO list to help them keep track of what things are left undone
in e2fsprogs as we try to get ext4 out the door.  Here is my initial
list of items that still need addressing.  Hopefully we can expand this
list and document it somewhere like the ext4 wiki or the SourceForge
bug tracker.

- Rename uninit_groups to uninit_bg to be consistent with other
defined features.  Retain the old name for historical purpose.

- The return value of ext2fs_super_and_bgd_loc() is not to be trusted.
Document this in the source code.

- Make sure ext2fs_super_and_bgd_loc() does not get used anywhere where
the return value is expected to be accurate (aside from mke2fs).

- Remove lazy_bg feature from being set in mke2fs.  Feature has been
declare a dangerous hack by its creator, remove it to avoid people
building on top of it.

- Add flex_bg meta-data grouping support.

- Remove support for not zeroing the inode tables from the
uninit_groups patches.  This support is dangerous without a proper
kernel thread that zeros them in the background when the filesystem is
mounted.  Depends on the lazy_bg removal.

- Activate undo-manager in mke2fs only when inode tables are not being
zeroed.  Undo-manager is horribly slow if we need to store the
information of all the blocks that have been zeroed during mke2fs.  The
amount of storage needed for the undo on a 16TB filesystem could be
problematic.  Depends on kernel thread inode table zeroing.

- Make a 64-bit clean API that extends the existing one.  The current
API can not support larger than 32-bit blocks so a new set API calls is
need in order to provide large filesystem support and retain backwards
compatibility with the old API.

- 64-bit bitmap interface.  In order to support larger than 32-bit
blocks, a new bitmap interface is needed that can retain ABI
compatibility with the old one.



-JRS
