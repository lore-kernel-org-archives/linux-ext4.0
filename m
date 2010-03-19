From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15579] New: ext4 -o discard produces incorrect blocks of zeroes
 in newly created files under heavy read+truncate+append-new-file load
Date: Fri, 19 Mar 2010 10:51:38 GMT
Message-ID: <bug-15579-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35895 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0CSKvj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Mar 2010 06:51:39 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2JApcce006324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Mar 2010 10:51:38 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15579

           Summary: ext4 -o discard produces incorrect blocks of zeroes in
                    newly created files under heavy
                    read+truncate+append-new-file load
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.33
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: kernel-bugs@abeckmann.de
        Regression: No


I'm testing ext4 -o discard on a Super Talent FTM56GX25H SSD. The speed
increase by using the discard option seems promising.
But I'm experiencing problems under a certain stressful file system load:

(approximate description, the actual sizes/numbers are not exact MB/GB, but
that shouldn't be a problem)
* you have a 252 GB ext4 -m 0 -T largefile filesystem
* you have 250 input files of size 1 GB each and an empty output file
* while the input has not been consumed
  - load 1 MB from the end of each input file
  - truncate the input files to reduce their size by 1 MB
  - do some computation ...
  - append 250 MB to the output file

Checking the output file after operation has finished I find blocks of 0x00
that should not be there. These blocks are usually the size of 1MB (the size
that was truncated and 'discarded') and always multiples of 16KB (the minimal
discard/TRIM-able unit (also the discard/TRIM alignment) of the SSD, found by
doing manual experiments using hdparm --trim-sector-ranges).
In several repetitions I've counted about 10-12MB of invalid 0x00 bytes in the
output.

The problem does not occur if I use 250000 inputfiles instead, read a subset of
250 files and delete them before writing the output. This is significantly
slower.

A possible cause could be some race condition between
* freeing filesystem blocks by truncating a file and queuing them for
DISCARD/TRIM
* allocating free filesystem blocks for a new append/write to a file
* submitting the DISCARD/TRIM request to the disk
* submitting the write request to the disk

Is there a possibility to generate debug information from ext4 that would be
helpful for tracking down this problem? The file system on the SSD is the only
ext[2-4] file system in the machine.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
