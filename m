From: Justin Maggard <jmaggard10@gmail.com>
Subject: >2TB file issue with e2fsck
Date: Thu, 18 Mar 2010 14:25:23 -0700
Message-ID: <150c16851003181425s3cea7067o1505279f9d01b0a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f198.google.com ([209.85.216.198]:62737 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0CRVZY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Mar 2010 17:25:24 -0400
Received: by pxi36 with SMTP id 36so1849288pxi.21
        for <linux-ext4@vger.kernel.org>; Thu, 18 Mar 2010 14:25:23 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ran into an interesting issue, and thought I'd report it.  I created a
4TB file using posix_fallocate() on a freshly-created ext4 filesystem,
unmounted, and then ran e2fsck -f on it.  Using e2fsprogs 1.41.9,
e2fsck ran through with no issues.  Versions 1.41.10 and 1.41.11,
however, reported finding an error.  Output was the same for both
1.41.10 and 1.41.11:

e2fsck 1.41.10 (10-Feb-2009)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, i_blocks is 8589935432, should be 840.  Fix? yes

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

c: ***** FILE SYSTEM WAS MODIFIED *****
c: 12/90523648 files (0.0% non-contiguous), 1079543383/1448361984 blocks

I'm in the process of trying it again using dd to create the large
file instead of posix_fallocate(), but I suspect the results will be
the same.  Writing out such a huge file using dd takes a lot longer,
since as was discussed on this list a couple weeks ago, large
sequential writes on ext4 max out around 350MB/s. :)

-Justin
