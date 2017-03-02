From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/3] e2fsprogs: new tools e2info/e2spacey
Date: Wed, 01 Mar 2017 20:52:06 -0800
Message-ID: <148843032650.21733.13980225191301375698.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45217 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753519AbdCBEwM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Mar 2017 23:52:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here are some minor fixes and two new e2fsprogs tools!  The first patch
fixes a bunch of compiler warnings.

The first tool, e2info, uses the proposed ext4 geometry ioctl to query a
mounted ext4 filesystem for geometry information and prints it.

The second tool, e2spacey, uses the proposed GETFSMAP and ext4 ioctls to
find all the free space on a mounted filesystem to display a histogram
of extent sizes, or optionally how much free space can be found in each
flexbg.  (Note: the xfs_io tool can be used for general getfsmap queries
on ext4 filesystems.)

If you want to go play with these tools, you can grab the source from my
git repo[1].  You'll need the patches on mailing list, or my
djwong-devel kernel tree[2].

This is a tremendous way to eat your data!

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
