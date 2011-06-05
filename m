From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36722] New: TRIM support is broken for Crucial M4 drives
Date: Sun, 5 Jun 2011 15:05:38 GMT
Message-ID: <bug-36722-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:48417 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1FEPFj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Jun 2011 11:05:39 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p55F5cfH014812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 5 Jun 2011 15:05:38 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36722

           Summary: TRIM support is broken for Crucial M4 drives
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38.8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: kernel-bugs.dev1world@spamgourmet.com
        Regression: No


Created an attachment (id=60842)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=60842)
dmesg output

The TRIM is disabled as per the following messages:

# dmesg | grep "discard not"
[   18.614000] EXT4-fs warning (device sdi8): release_blocks_on_commit:2674:
discard not supported, disabling
[42486.763000] EXT4-fs warning (device sdi11): release_blocks_on_commit:2674:
discard not supported, disabling

but TRIM support is there:

# hdparm -I /dev/sdi | grep TRIM
           *    Data Set Management TRIM supported (limit 8 blocks)
           *    Deterministic read data after TRIM

The drive is on this controller and not part of any RAID:

# lspci | grep LSI

04:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008
PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)

The dmesg is attached.

Can someone also say what this message means:

[42087.056000] EXT4-fs (sdi11): Unaligned AIO/DIO on inode 654340 by
VirtualBox; performance will be poor.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
