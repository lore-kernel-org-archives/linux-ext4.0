From: Allison Henderson <achender@vnet.ibm.com>
Subject: [PATCH 0/3 v5] XFS TESTS: Add Fallocate Punch Hole Tests
Date: Mon, 06 Jun 2011 16:32:27 -0700
Message-ID: <4DED638B.3080806@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44320 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1FFXca (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 19:32:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

Here is v5 of the punch hole tests that I have been working with Dave on.  In v4 I merged in the non over-lapping tests from v3 into 252, and I separated the code paths for punch hole and fallocate in the fsx patch.  In v5, patch 1 was re based to the latest xfstests code due to activity that had caused the patch to not apply.  I've also included the ENOSPC test that we used in the ext4 punch hole tests.  Some things I need some feedback on:


Ext4 is currently having a hard time passing xfstest 252, test number 12.  The test is:

	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
		-c "$alloc_cmd 0 20k" \	
		-c "pwrite 8k 4k" -c "fsync" \		
		-c "$zero_cmd 4k 12k" \
		-c "$map_cmd -v" $testfile | $filter_cmd
	[ $? -ne 0 ]&&  die_now

and the output is:

        12. unwritten -> data -> unwritten
0: [0..7]: unwritten
1: [8..31]: hole
2: [32..39]: unwritten

Ext4 gets data extents here instead of unwritten extents.  I did some investigating and it looks like the fsync command causes the extents to be written out before the punch hole operation even starts.  I believe what happens is that when an unwritten extent gets written to, it doesnt always split the extent.  If the extent is small enough, then it just zeros out the portions that are not written to, and the whole extent becomes a written extent.  Im not sure if that is incorrect or if we need to change the test to not compare the extent types.

Also, we had a test for ext4 punch hole that tests to see if a hole can still be punched when the disk is full.  The test has been modified to use the xfsprogs facilities to fit the xfstests framework, but has become very slow.   I found that if I replace the line:

$XFS_IO_PROG -F -f -c "pwrite  0 $file_size" $dir/$file_count.bin&>  /dev/null

with the original code:

dd if=/dev/zero of=$dir/$file_count.bin bs=$file_size count=1 &> /dev/null

it becomes a lot faster (takes off almost 15 minutes).  Is there anything we can do to improve the xfsprogs command?  Thx!


Allison Henderson
