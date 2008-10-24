From: Arthur Jones <ajones@riverbed.com>
Subject: ext3: slow symlink corruption on umount...
Date: Fri, 24 Oct 2008 11:37:34 -0700
Message-ID: <20081024183733.GA25797@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.riverbed.com ([206.169.144.7]:42840 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYJXSrJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Oct 2008 14:47:09 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,  I'm seeing slow symlink corruption on ext3 on linux-2.6.27,
yesterday's linux-2.6 git tree and 2.6.9 RHEL4.7.  I.e. every kernel
I've tried I see this effect.  To reproduce this, I need:

* 250MB + tar file in memory (tmpfs or in the buffer cache)
* long symlinks in the tar file (over 60 characters)
* umount immediately after untarring

What I see is that the symlinks are corrupted, e.g.:

# ls -l etc/vmware-vix-disklib
etc/vmware-vix-disklib -> ??f

fsck shows:

Symlink /etc/vmware-vix-disklib (inode #16454) is invalid.

Debugfs shows:

debugfs:  stat <16454>
Inode: 16454   Type: symlink    Mode:  0777   Flags: 0x0   Generation: 1431972005
User:     0   Group:     0   Size: 65
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x4900ac69 -- Thu Oct 23 09:55:05 2008
atime: 0x4900ac84 -- Thu Oct 23 09:55:32 2008
mtime: 0x4900ac69 -- Thu Oct 23 09:55:05 2008
BLOCKS:
(0):56034
TOTAL: 1

I'm still tracking down exactly what's going on.  Anyone seen
anything like this before?  ext2 does not show this effect (I've
not tried ext4).  It happens when the backing block device is
a SATA drive or flash.

Thanks,

Arthur
