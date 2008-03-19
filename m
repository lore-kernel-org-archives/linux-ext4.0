From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc e2fsprogs and fast symlink
Date: Thu, 20 Mar 2008 01:08:01 +0530
Message-ID: <20080319193801.GA16687@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:59607 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbYCSTiK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 15:38:10 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2JJd1xC023796
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 06:39:01 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2JJc7j24186366
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 06:38:08 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2JJc7GU011013
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 06:38:07 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

While testing on powerpc i found that e2fsck is getting confused about
fast symlink on powerpc. On x86_64 it works fine.

lrwxrwxrwx  1 root root    60 Mar 19 15:18 d -> /usr/share/icons/hicolor/48x48/apps/gnome-netstatus-txrx.png
[root@gekko-lp2 ~]# /usr/local/e2fsprogs/sbin/debugfs  /dev/sda7 
debugfs 1.40.8 (13-Mar-2008)
debugfs:  stat d
Inode: 24483   Type: symlink    Mode:  0777   Flags: 0x80000
Generation: 2913520215
User:     0   Group:     0   Size: 60
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x47e166f9 -- Wed Mar 19 15:18:17 2008
atime: 0x47e166fb -- Wed Mar 19 15:18:19 2008
mtime: 0x47e166f9 -- Wed Mar 19 15:18:17 2008
Size of extra inode fields: 28
BLOCKS:

debugfs:

root@gekko-lp2 ~]# /usr/local/e2fsprogs/sbin/e2fsck  -f /dev/sda7
e2fsck 1.40.8 (13-Mar-2008)
Pass 1: Checking inodes, blocks, and sizes
Error while reading over extent tree in inode 24483: Corrupt extent
header
Clear inode<y>? yes

Inode 24483, i_blocks is 8, should be 0.  Fix<y>? yes

Fast symlink 100055 has EXTENT_FL set.  Clear<y>? 

-aneesh
