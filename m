From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: powerpc e2fsprogs and fast symlink
Date: Thu, 20 Mar 2008 13:17:40 +0530
Message-ID: <20080320074740.GA11891@skywalker>
References: <20080319193801.GA16687@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:46391 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbYCTHru (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2008 03:47:50 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2K7leQQ027472
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 13:17:40 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2K7le831105974
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 13:17:40 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2K7leii017079
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 07:47:40 GMT
Content-Disposition: inline
In-Reply-To: <20080319193801.GA16687@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 20, 2008 at 01:08:01AM +0530, Aneesh Kumar K.V wrote:
> Hi Ted,
> 
> While testing on powerpc i found that e2fsck is getting confused about
> fast symlink on powerpc. On x86_64 it works fine.
> 
> lrwxrwxrwx  1 root root    60 Mar 19 15:18 d -> /usr/share/icons/hicolor/48x48/apps/gnome-netstatus-txrx.png
> [root@gekko-lp2 ~]# /usr/local/e2fsprogs/sbin/debugfs  /dev/sda7 
> debugfs 1.40.8 (13-Mar-2008)
> debugfs:  stat d
> Inode: 24483   Type: symlink    Mode:  0777   Flags: 0x80000
> Generation: 2913520215
> User:     0   Group:     0   Size: 60
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 8
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x47e166f9 -- Wed Mar 19 15:18:17 2008
> atime: 0x47e166fb -- Wed Mar 19 15:18:19 2008
> mtime: 0x47e166f9 -- Wed Mar 19 15:18:17 2008
> Size of extra inode fields: 28
> BLOCKS:
> 
> debugfs:
> 
> root@gekko-lp2 ~]# /usr/local/e2fsprogs/sbin/e2fsck  -f /dev/sda7
> e2fsck 1.40.8 (13-Mar-2008)
> Pass 1: Checking inodes, blocks, and sizes
> Error while reading over extent tree in inode 24483: Corrupt extent
> header
> Clear inode<y>? yes
> 
> Inode 24483, i_blocks is 8, should be 0.  Fix<y>? yes
> 
> Fast symlink 100055 has EXTENT_FL set.  Clear<y>? 
> 

The extent support on powerpc doesn't seems to work with e2fsprogs.
make check on e2fsprogs on powerpc gives

f_extents: basic extents support: failed
