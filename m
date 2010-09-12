From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18302] New: [BUG] bad performance and system stalls when using
 dm-crypt
Date: Sun, 12 Sep 2010 11:00:32 GMT
Message-ID: <bug-18302-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59840 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0ILLAe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Sep 2010 07:00:34 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o8CB0XYD014366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 12 Sep 2010 11:00:33 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=18302

           Summary: [BUG] bad performance and system stalls when using
                    dm-crypt
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.35.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: db.pub.mail@gmail.com
        Regression: No


Please see
http://thread.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/4558 for the
full mailing list thread that is related to my bug report here :) 

Summary: 
'Right, I see the issue as the following: requesting a lot of writes
and then a number of read operations from different processes leads to
a *poor* outcome.
I say this because if I do "dd /dev/zero of=/tmp/DELETEME"
after a short time the entire system stalls and it really is *very*
difficult to end the dd, which is writing to the disk :)'



---> The first post in the thread I sent to the dm-crypt list :)

I am not sure if this really is a bug or just expected behaviour with
ext3 in ordered mode with luks / dm-crypt adding some extra latency
...

----
I am experiencing really bad performance and a fair amount of system
stalls using dm-crypt(luks)  on debian lenny with  with an ext3
ordered mode  /

"
Version:        1
Cipher name:    aes
Cipher mode:    cbc-essiv:sha256
Hash spec:      sha1
"
/dev/mapper/foo-root on / type ext3 (rw,relatime,errors=remount-ro)
Swap is also within the luks partition.

The kernel version is 2.6.35.4.

A simple test is just to dd if=/dev/zero of=DELETEME for a short time
and the system will stall rather a lot - it is not a complete lock up
- just the entire system is unresponsive for large periods at a time
(from around 30seconds - to 2 minutes). This may be related to
http://thread.gmane.org/gmane.linux.kernel.mm/51444 .


The system is a 6 core amd phenom with 4gb of ram - the hard drive is
a WD 1TB sata 3 drive hooked up to a (sata 3 controller)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA
Controller [IDE mode] (rev 40)


00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA
Controller [IDE mode] (rev 40) (prog-if 01 [AHCI 1.0])
       Subsystem: ASUSTeK Computer Inc. Device 8443
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
       Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 64, Cache Line Size: 64 bytes
       Interrupt: pin A routed to IRQ 42
       Region 0: I/O ports at c000 [size=8]
       Region 1: I/O ports at b000 [size=4]
       Region 2: I/O ports at a000 [size=8]
       Region 3: I/O ports at 9000 [size=4]
       Region 4: I/O ports at 8000 [size=16]
       Region 5: Memory at fe8ffc00 (32-bit, non-prefetchable) [size=1K]
       Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
Queue=0/2 Enable+
               Address: 00000000fee3f00c  Data: 4161
       Capabilities: [70] SATA HBA <?>
       Capabilities: [a4] PCIe advanced features <?>
       Kernel driver in use: ahci
       Kernel modules: ahci

------

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
