From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Ext4 Punch Hole Support: Change summary and test case summary
Date: Tue, 19 Apr 2011 00:37:59 -0700
Message-ID: <4DAD3BD7.3080107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48426 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab1DSHiE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Apr 2011 03:38:04 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3J7Fsj9027549
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:15:54 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3J7c3nr159256
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:38:03 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3J7c3c3012870
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:38:03 -0400
Received: from [9.48.114.155] (sig-9-48-114-155.mts.ibm.com [9.48.114.155])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p3J7c21a012792
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:38:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

Here is the latest version of the punch hole patch for ext4.  There have been a lot of revisions and tests since the last patch that was sent.  It looks like some parts of it may conflict with the "[PATCH RFC 2/3] ext4:Add two functions splitting an extent" patch, so we will still need to work that part out.  But I wanted to keep people updated and get some feed back.  Here is a quick list of the big changes since v4:

- The first patch adds a flag to ext4_has_free_blocks which enables the use of reserved blocks.  
Since the extents may need to be split during the punch hole process, it is possible that it may require more blocks than are available.  This new flag will allow a punch hole to proceed even if the disk is full.

- The code for splitting an extent has been simplified into a new ext4_split_unwritten_extents flag.  
The ext4_split_extents function from the first patch in v4 has been removed.

- The code for finding and punching out blocks in an extent has been moved in the the ext4_ext_map_blocks function, and invoked with a new punch hole flag.  

- The code that converts the extent to uninitialized has also been moved into the ext4_ext_map_blocks function with the new punch hole code, 
so the ext4_ext_convert_blocks_uninit function from the first patch in v4 has been removed


Also, here is a list of test cases that were done to help find any bugs.  
These test cases were initially created to be used with a debug patch to help ensure that the new code paths behave as expected, but we plan to turn them in new test cases for xfstests and ltp after we have 
the punch hole code wrapped up.


Small Hole Test
---------------------------------------------------------------
A hole is punched in a 10K file from bytes 8180 to 16216 resulting in one block being removed,
and the non block aligned data to be cleared.  

This test is a general purpose punch hole test to verify that the code can successfully
split the extents, and remove the affected blocks, as well as clearing the associated pages

This test successful when the following conditions are met:
- ls shows that the file now occupies one less block
- df shows there is one more block available
- File frag shows that the second block is absent from the extents
- The test file contains zeros from bytes 8180 to 16216


Cold Cache Test
---------------------------------------------------------------
This test is similar to the Small Hole Test, but the drive is unmounted and remounted before 
the hole is punched out to make sure that there are no pages in the cache. This test verifies
that the hole contains zeros even when the pages are cold.
This test is successful when the same conditions as the Small Hole Test are met.


Dirty Data Test
---------------------------------------------------------------
This test is similar to the Small Hole Test, but the file is not copied to the test area.  Instead
a new file is created, and the data is written into the file.  This test verifies
that the hole contains zeros even when the pages are dirty.  
This test is successful when the same conditions as the Small Hole Test are met.


Big Hole Test
---------------------------------------------------------------
A hole large hole is punched in a large file (exact file size=638169088 bytes, exact hole size = 638150422 bytes, offset = 6144 bytes), 
resulting in all but 5 blocks being punched out (2 in the front, 3 in the back).  This test case verifies that the code can properly
punch out a hole covering multiple extents.

This test is successful when the following conditions are met:
- File frag shows extents only for the first two blocks and the last 3 blocks
- The test file contains zeros from bytes 6144 to 638156566
(* ls and df is not measured here because some blocks will still be reserved as index
 blocks causing the consumed space to be appear larger)


Big Hole Removal Test
---------------------------------------------------------------
This test is similar to the Big Hole Test, but the file is deleted after the hole is punched out.

This test is successful when the following conditions are met:
- df shows that the number of available blocks is the same before the test file is copied 
  into the file system, and after the file is deleted


First Byte Hole Test
---------------------------------------------------------------
This test cases punches a hole in 10K file from bytes 0 to 8180 resulting in one block being removed at the 
beginning of the file.  This test verifies that the code appropriately handles punching holes appearing at the 
beginning of the file.

This test is successful when the following conditions are met:
- File frag shows that the first extent starts at block one
- ls shows that the file now occupies one less block
- df shows there is one more block available
- The first 8180 bytes of the file contains zeros


Last Block Hole Test
---------------------------------------------------------------
This test cases punches a hole in 10K file from bytes 32768 to 40960 resulting in a hole that extends to the end
of the file.  This test verifies that the code appropriately handles removing blocks at the end of the file

This test is successful when the following conditions are met:
- File frag shows that the last extent only extends to block 8
- ls shows that the file now occupies two less blocks
- df shows there are two more block available
- The file contains zeros between bytes 32768 to 40960


Extended Last Block Hole Test
---------------------------------------------------------------
This test cases punches a hole in 10K file from bytes 32768 to 45056 resulting in a hole that extends beyond 
the end of the file.  This test verifies that the code appropriately handles removing blocks beyond the end of the file

This test is successful when the following conditions are met:
- File frag shows that the last extent only extends to block 8
- ls shows that the file now occupies two less blocks
- df shows there are two more block available
-The file contains zeros between bytes 32768 to 40960


One block hole test
---------------------------------------------------------------
This test punches a hole in a file that is only one block in size from byte 1024 to 3072
This test is successful when the following conditions are met:
-ls, df, and filefrag show no changes before and after the hole punch
-The file contains zeros between bytes 1024 and 3072



Off Edge Hole Test
---------------------------------------------------------------
This test case punched a hole that is beyond the edge of the file.
This test is successful when ls, df, filefrag and the file contents show no changes



Delayed Allocation Hole Test
---------------------------------------------------------------
This test is similar to the Small Hole Test, but the file is not sync'd to the disk before the hole is punched out.

This test is successful when the following conditions are met:
- ls shows that the file now occupies one less block
- df shows there is one more block available
- File frag shows that the second block is absent from the extents, and the first and last extents are delayed
- The test file contains zeros from bytes 8180 to 16216


Pre allocation Hole Test
---------------------------------------------------------------
This test is similar to the Small Hole Test, but the file is preallocated before the hole is punched out.

This test is successfull when the following conditions are met:
- ls shows that the file now occupies one less block
- df shows there is one more block available
- File frag shows that the second block is absent from the extents, and the first and last extents are unwritten
- The test file contains zeros from bytes 8180 to 16216




Multi Hole Test
---------------------------------------------------------------
This test verifies the code ability to handle existing holes
The test punches out 3 consecutive overlapping holes in a 10K file:
Hole 1: offset 8192, length 8192
Hole 2: offset 8192, length 8192
Hole 3: offset 8180, length 8192
Hole 4: offset 8204, length 8192
Hole 5: offset 12288, length 12288

After each hole punch, output from ls, df and file frag are shown.

This test is successful when the following conditions are met:
- Hole 1 shows the following changes:
	- ls shows that the file now occupies two less blocks
	- df shows there is two more blocks available
	- File frag shows that the second and third blocks are absent from the extents
	- The test file contains zeros from bytes 8192 to 16384
- Hole 2 shows no changes in ls, df, filefrag or file contents.
- Hole 3 shows no changes in ls, df, filefrag but the file contents should be zeroed out between 8192 and 16372
- Hole 5 shows no changes in ls, df, filefrag but the file contents should be zeroed out between 8180 and 16396
- Hole 5 shows that the hole has increased by two blocks for ls, df, and filefrag.  
  The file contents should be zeroed out between 8180 and 24576


Multi Hole Test Front
---------------------------------------------------------------
This test verifies the code ability to handle existing holes at the front of the file.
The test punches two 8192 byte holes starting at byte 0.

This test is successful when the following conditions are met:
- Hole 1 shows the following changes:
	- ls shows that the file now occupies two less blocks
	- df shows there are two more block available
	- File frag shows that the first extent starts at block 2
	- The test file contains zeros from bytes 0 to 8192
- Hole 2 shows no changes in ls, df, filefrag or file contents.



Multi Hole Delayed Test
---------------------------------------------------------------
This test verifies the code ability to handle existing holes in delayed blocks.
This test is similar to the Delayed Allocation Hole Test, but the hole is punched twice

This test is successful when the following conditions are met:
- ls shows that the file now occupies one less block
- df shows there is one more block available
- File frag shows that the second block is absent from the extents, and the first and last extents are delayed
- The test file contains zeros from bytes 8180 to 16216



ENOSPC Hole Test
---------------------------------------------------------------
This test case was created to show that the punch hole can proceed even if the disk is full.  This test case fills the file system as much as possible, and then proceeds to punch out every other two blocks of the largest file, refilling the file system after each hole.  With out the ext4_has_free_blocks  
flag to enable the use of reserved blocks, the ENOSPC error was encountered after about 333 iterations.  This test case is considered passed after 5000 successful hole punches.

FSX Stress Test
---------------------------------------------------------------
To help track down any unidentified bugs, a copy of the fsx stress code was obtained from xfstests, and modified to include hole punching as part of it  
test operation.  This test is considered complete after 100000 successful file operations




