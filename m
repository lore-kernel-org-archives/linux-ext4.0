From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [RFC] Design for large EAs
Date: Mon, 09 Feb 2009 16:39:17 +0530
Message-ID: <1234177757.3065.32.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@Sun.COM>, agruen@suse.de
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:65029 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbZBILGv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 06:06:51 -0500
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id n19B6UXH006744
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 11:06:44 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KES00K00PBVS300@mail-apac.sun.com> for linux-ext4@vger.kernel.org; Mon,
 09 Feb 2009 19:06:26 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Earlier I had posted patches which added large EA support by storing all
EAs with size greater than 1/2 of blocksize into an external inode. Ted
had expressed reservations that this may use up too many inodes. Further
discussion ensued and few different designs were discussed. Here's the
relevant thread:
http://kerneltrap.org/index.php?q=mailarchive/linux-ext4/2008/12/3/4296884/thread

There was agreement on an ext4 concall that we can increase extended
attribute space by allocating contiguous EA blocks. So only those EAs
with size > blocksize will be stored in external inode. Thereby less
number of inodes will be wasted and we will have space for more number
of entries as well. I have included few design details, and it would be
nice to have agreement on these before I move on to coding.

----

Problem Definition: 
Increase Extended Attribute space by allocating contiguous EA blocks.

Design:

1) On-disk structure changes

        - h_blocks field in ext4_xattr_header can be used to indicate
number of contiguous EA blocks for the inode. We can have a maximum of
64KB of EA space since we are limited by 16-bit value offset field in
ext4_xattr_entry.
        - The EXT4_FEATURE_INCOMPAT_EA_INODE flag will encapsulate the
external inode EA and multiple EA blocks features.
	- A new magic number for h_magic(EXT4_XATTR_MAGIC_V2) in
ext4_xattr_header to indicate that this inode has multiple EA blocks.

2) We will initially allocate only a single EA block if xattr fits in
one block. If xattrs do not fit in single EA block then we will try to
allocate 64KB of contiguous blocks. If allocation of 64KB fails we will
try to allocate 32KB and then 16KB of contiguous blocks, ...

3) EA value will be stored in external inode if value_size > blocksize.
All EA values in EA blocks will not cross 4KB boundaries. This way we
can always read in an EA value by reading only a single block and making
the code simpler. I don't think we want to store medium sized EAs
(5-32KB) to be stored in EA blocks anyway.

Questions:

1) Since we will have 64KB EA space, we will need to allocate 64KB
buffers to read in the EA space. This way a lot of the code will remain
as-is, since most of the macros/functions assume that EA space is
contiguous(as was with single EA block). Will allocation of such large
buffers(even with vmalloc) lead to any problems?
3) We won't be using refcount for EA blocks any more. Any problems with
this? Should we think about removing the entire mb_cache code or atleast
disable mb_cache when not needed?

Thanks,
Kalpak

