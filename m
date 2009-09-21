From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14203] New: File permissions not working correctly
Date: Mon, 21 Sep 2009 18:32:26 GMT
Message-ID: <bug-14203-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46777 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZIUScX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Sep 2009 14:32:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8LIWQm2002477
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2009 18:32:26 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14203

           Summary: File permissions not working correctly
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.31-10-386
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: kendragonXXI@gmail.com
        Regression: No


I have two ext4 partitions, one for the entire system(P1) and the other for all
my stuff(P2). The problem occurs in the P2 partition. If I set the permission
of a file to read-only(444), I'm still able to rename or delete that file, no
matters who's the owner of the file(that's happen even when the file owner is
the root). Another curious thing is that I can rename the file but I can not
replace that file with a file with the same name(in that case the error message
that I don't have permission to do that appears.

The permissions in the P1 partition works perfect. Here is the fstab file. If
more info is needed I'm glad to give it(kendragonXXI@gmail.com)

-----------------------------------------

cat fstab
# /etc/fstab: static file system information.
#
# Use 'vol_id --uuid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
# / was on /dev/sda1 during installation
UUID=22ac88ac-ca10-4e94-8ae4-f92bd36e52be /               ext4   
relatime,errors=remount-ro 0       1
# /MASTER was on /dev/sda6 during installation
UUID=03e372ab-0d64-44da-824e-ee5c87e68d39 /MASTER         ext4    relatime     
  0       2
# swap was on /dev/sda5 during installation
UUID=b3e5fce9-4543-43d3-965f-71f2c847d63b none            swap    sw           
  0       0
/dev/scd0       /media/cdrom0   udf,iso9660 user,noauto,exec,utf8 0       0

---------------------------------------

uname -a
Linux kendragonXXI 2.6.31-10-386 #34-Ubuntu SMP Wed Sep 16 02:18:28 UTC 2009
i686 GNU/Linux

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
