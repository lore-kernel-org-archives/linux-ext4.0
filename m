From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Add regression test for clearing an xattr block
Date: Sun, 13 Apr 2008 21:27:55 -0600
Message-ID: <20080414032755.GF8058@webber.adilger.int>
References: <47FF8A50.2030800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:34311 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYDND16 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Apr 2008 23:27:58 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3E3RvQi013240
	for <linux-ext4@vger.kernel.org>; Sun, 13 Apr 2008 20:27:57 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZA00801PGDZM00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 13 Apr 2008 20:27:57 -0700 (PDT)
In-reply-to: <47FF8A50.2030800@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 11, 2008  10:57 -0500, Eric Sandeen wrote:
> I got burned by the bug at:
> http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=commitdiff;h=86bc90f4f11df090f86dc764a4ea2d6dd5c13ffe
> 
> so figured maybe a testcase was in order... 
> 20/20 hindsight I guess!

Is the "ea_checks" patch and respective test in the upstream e2fsprogs?
We had added additional checks to e2fsck for xattr blocks/large inodes.

The test output looks like below - there are a number of different types
of EA corruption, though the error message is always the same.  The patch
was in the series I previously sent "e2fsprogs-ea_check.patch", and the
patch + test image are in the tarball at
http://downloads.lustre.org/people/adilger/e2fsprogs-1.40.5-patches.tar.gz
though I could re-send one or both to the list if desired.

=================================
+Pass 1: Checking inodes, blocks, and sizes
+Inode 13 has a bad extended attribute block 26.  Clear? yes
+
+Inode 13, i_blocks is 4, should be 2.  Fix? yes
+
+Extended attribute in inode 14 has a hash (1649340189) which is invalid
+Clear? yes
+
+Inode 14, i_blocks is 2, should be 0.  Fix? yes
+
+Inode 17 has a bad extended attribute block 28.  Clear? yes
+
+Inode 17, i_blocks is 4, should be 2.  Fix? yes
+
+Inode 16 has a bad extended attribute block 29.  Clear? yes
+
+Inode 16, i_blocks is 2, should be 0.  Fix? yes
+
+Inode 19 has a bad extended attribute block 33.  Clear? yes
+
+Inode 19, i_blocks is 2, should be 0.  Fix? yes
+
+Inode 12 has a bad extended attribute block 55.  Clear? yes
+
+Inode 12, i_blocks is 2, should be 0.  Fix? yes
+
+Inode 15, i_blocks is 2, should be 0.  Fix? yes
+
+Pass 2: Checking directory structure
+Extended attribute block for inode 15 (/far) is invalid (999).
+Clear? yes


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

