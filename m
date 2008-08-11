From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Mon, 11 Aug 2008 13:25:55 +0530
Message-ID: <20080811070505.GA6400@skywalker>
References: <E1KSEkA-00009o-CV@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:50712 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYHKH6V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2008 03:58:21 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7B7uvhe022289
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 17:56:57 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7B7uUbp190244
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 17:56:31 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7B7uUcO010412
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 17:56:30 +1000
Content-Disposition: inline
In-Reply-To: <E1KSEkA-00009o-CV@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 10, 2008 at 01:30:14PM -0400, Theodore Ts'o wrote:
> 
> Thanks to a comment on a recent blog entry of mine[1], I think I've
> uncovered a rather embarassing bug in mballoc.
> 
> [1]http://thunk.org/tytso/blog/2008/08/08/fast-ext4-fsck-times
> 
> I created a fresh 5 gig ext4 filesystem, and then populating it using a
> single-threaded tar command:
> 
> 	(cd /usr ; tar cf - bin lib) | (cd /mnt; tar xfp -)
> 
> I then unmounted the filesystem, and ran an instrumented e2fsck looking
> for fragmented files, and found a whole series of fragmanted files with
> the following pattern:
> 
> Inode 122: (0):58399, (1-3):43703-43705
> Inode 124: (0):58400, (1):43707
> Inode 127: (0):58401, (1-7):43709-43715
> Inode 128: (0):58402, (1-2):43716-43717
> Inode 129: (0):58403, (1-3):43718-43720
> Inode 133: (0):58404, (1-5):43722-43726
> Inode 135: (0):58405, (1):43728
> Inode 136: (0):58406, (1-3):43729-43731
> Inode 141: (0-1):58407-58408, (2-6):43734-43738
> Inode 143: (0):58409, (1):43740
> Inode 144: (0):58410, (1-5):43741-43745
> Inode 146: (0):58411, (1):43746
> 
> Inode	Pathname
> 122	/bin/smproxy
> 124	/bin/debconf-updatepo
> 127	/bin/iostat
> 128	/bin/xeyes
> 129	/bin/pbmtog3
> 133	/bin/join-dctrl
> 135	/bin/dpkg-name
> 136	/bin/lockfile
> 141	/bin/id
> 143	/bin/ppmcolormask
> 144	/bin/tty
> 146	/bin/colrm
> 
> If I do this test with -o nodelalloc, I get a slightly different
> pattern.  Now I get a whole series of discontiguous regions after the
> first 15 blocks:
> 
> inode    last_block           pblk  lblk len
> =============================================
> 2932: was 47087 actual extent 41894 (15, 3)...
> 3512: was 47829 actual extent 41908 (15, 1)...
> 3535: was 47904 actual extent 41912 (15, 37)...
> 3549: was 47977 actual extent 41949 (15, 4)...
> 3637: was 48225 actual extent 41959 (15, 6)...
> 3641: was 48245 actual extent 41965 (15, 13)...
> 3675: was 48418 actual extent 41978 (15, 1)...
> 3675: was 41979 actual extent 48640 (16, 15)...
> 3714: was 41984 actual extent 48656 (1, 2)...
> 3954: was 49449 actual extent 48660 (15, 16)...
> 3999: was 49569 actual extent 48679 (15, 2)...
> 4010: was 49644 actual extent 48681 (15, 1)...
> 4143: was 49943 actual extent 48687 (15, 10)...
> 4202: was 50036 actual extent 48699 (15, 6)...
> 
> So all of the discontiguities start at logical block #15, and when I
> examine the inodes, what we find is one extent for blocks 0-14, ending
> at the last_block number, and then the second extent which extends for
> the rest of the file, starting somewhere else earlier in the block
> group.
> 
> So a very similar issue, even without delayed allocation.  That leads me
> to suspect the problem is somewhere inside mballoc.  Aneesh, Andreas,
> Alex --- I think you folks are most familiar the mballoc code the;
> someone have time to take a look?  This is clearly a bug, and clearly
> something we want to fix.  If we can't get an optimal layout with one
> single-threaded process writing to the filesystem, what hope do we have
> of getting it right on more realistic benchmarks or real-world usage?
> 

Are these small files ? The locality group preallocation is discarded
with the recent changes. 6be2ded1d7c51b39144b9f07d2c839e1bd8707f1 on
linus tree ?

-aneesh
