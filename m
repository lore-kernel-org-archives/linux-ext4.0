From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [BUG] 2.6.27-rc1 - Filesystem warning on ext4 with e2fsck
Date: Mon, 11 Aug 2008 15:50:46 +0530
Message-ID: <48A0127E.6000505@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kernel list <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	aneesh.kumar@linux.vnet.ibm.com, Andy Whitcroft <apw@shadowen.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:42386 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYHKKUz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2008 06:20:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

After running the fsx linux test on the ext4 partition mounted with 
-o errors=panic,journal_async_commit, filesystem check is reporting
warning

# /usr/local/e2fsprogs/sbin/e2fsck -fnv /dev/sda6 
e2fsck 1.41.0 (10-Jul-2008)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
/lost+found not found.  Create? no

Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/sda6: ********** WARNING: Filesystem still has errors **********


      63 inodes used (0.00%)
       2 non-contiguous inodes (3.2%)
         # of inodes with ind/dind/tind blocks: 12/11/11
  463336 blocks used (1.77%)
       0 bad blocks
       1 large file

      31 regular files
      23 directories
       0 character device files
       0 block device files
       0 fifos
       0 links
       0 symbolic links (0 fast symbolic links)
       0 sockets
--------
      54 files

# /usr/local/e2fsprogs/sbin/e2fsck -V
e2fsck 1.41.0 (10-Jul-2008)
        Using EXT2FS Library version 1.41.0, 10-Jul-2008

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
