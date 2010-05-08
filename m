From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Sat, 8 May 2010 14:30:32 GMT
Message-ID: <201005081430.o48EUWDw021756@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57039 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0EHOad (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 May 2010 10:30:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o48EUWtD021757
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 8 May 2010 14:30:32 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906


Thierry Vignaud <thierry.vignaud@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |thierry.vignaud@gmail.com




--- Comment #20 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-05-07 09:45:32 ---
I can confirm that Jens's fix the original regression for me,
so IMHO first part well done.

About second one.
(In reply to comment #13)
> A delalloc option. In fact dirty inode is still dirty even after first
> call of writeback_single_inode which is called from __sync_filesystem(0)
> due to delalloc allocation happen during inode write. So it takes second
> __sync_filesystem call to clear dirty flags. Currently i'm working on that
> issue. I hope i'll post a solution today.

Proposed patch was posted may be found here: 
http://marc.info/?l=linux-fsdevel&m=127322500915287&w=2

--- Comment #21 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-05-07 10:49:00 ---
#########################################
# Testcase
#Prep stage
for ((i=0;i<1000;i++)) ;do echo test > /tmp/FILES/file-$i ;done
tar cf /tmp/files.tar /tmp/FILES
#Actual measurements  
FSTYPE=ext4
OPT='-obarrier=1'
mkfs.$FSTYPE /dev/sdb1 
mount /dev/sdb1 /mnt  $OPT
time tar xf /tmp/files.tar  -C /mnt/
time umount /mnt
#########################################

w/o update dflags patch
real    0m0.142s
user    0m0.005s
sys     0m0.093s

real    0m8.506s
user    0m0.000s
sys     0m0.016s

with update dflags patch
real    0m0.105s
user    0m0.006s
sys     0m0.086s

real    0m0.148s
user    0m0.002s
sys     0m0.007s

Seems where are no visible diffidence for btrfs and xfs.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
